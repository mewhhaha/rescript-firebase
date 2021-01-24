let makeColor = str => {
  let hex =
    str
    ->Js.String2.toLowerCase
    ->Js.String2.replaceByRe(%re("/[^0-9a-f]/g"), "")
    ->Js.String2.substring(~from=0, ~to_=6)
  j`#${hex}`
}

@react.component
let make = (~content: Feed.content, ~showUser: bool) => {
  let {uid: Firebase.Auth.UserId(uid), files, text} = content
  let (downloads, setDownloads) = React.useState(() =>
    files->Belt.Array.map(f => (f, Media.Progress(0.0)))
  )

  React.useEffect0(() => {
    downloads->Belt.Array.forEach(download => {
      switch download {
      | (id, Progress(_)) => {
          let Firestore.Id(path) = id
          let fileRef = Storage.root->Storage.child(j`files/${path}`)
          let ur = fileRef->Storage.getDownloadURL
          let md = fileRef->Storage.getMetadata

          open Js.Promise
          all2((ur, md))->then_(((url, metadata)) => {
            let fileType = if Media.reAcceptedImage->Js.Re.test_(metadata->Storage.contentType) {
              #image
            } else {
              #video
            }
            setDownloads(
              Belt.Array.map(_, d =>
                switch d {
                | (downloadId, _) when downloadId == id => (
                    downloadId,
                    Media.Finished(url, fileType),
                  )
                | _ => d
                }
              ),
            )
            resolve()
          }, _)->ignore
        }
      | _ => ()
      }
    })

    None
  })

  <div className="flex flex-col w-full px-2 py-1 break-words">
    {switch showUser {
    | true => {
        let userColor = makeColor(uid)
        <span className="text-xs font-bold pb-1" style={ReactDOM.Style.make(~color=userColor, ())}>
          {React.string(uid)}
        </span>
      }
    | false => React.null
    }}
    {switch files {
    | [] => React.null
    | _ => <span className="pt-1"> <MediaArea medias=downloads /> </span>
    }}
    <span className="text-white"> {React.string(text)} </span>
  </div>
}
