let makeColor = str => {
  let hex =
    str
    ->Js.String2.toLowerCase
    ->Js.String2.replaceByRe(%re("/[^0-9a-f]/g"), "")
    ->Js.String2.substring(~from=0, ~to_=4)
  j`#${hex}`
}

@react.component
let make = (~content: Feed.content, ~showUser: bool) => {
  let {uid: Firebase.Auth.UserId(uid), files, text} = content
  let (downloads, setDownloads) = React.useState(() =>
    files->Array.map(f => (f, Media.Progress(0.0)))
  )

  React.useEffect0(() => {
    downloads->Array.forEach(download => {
      switch download {
      | (id, Progress(_)) => {
          let Firestore.Id(path) = id
          let fileRef = Storage.root->Storage.child(j`files/${path}`)
          let ur = fileRef->Storage.getDownloadURL
          let md = fileRef->Storage.getMetadata

          open Js.Promise
          all2((ur, md))->then_(((url, metadata)) => {
            let fileCategory = metadata->Storage.contentType->Media.fileCategory
            setDownloads(
              Array.map(_, d => d->Tuple.fst == id ? (id, Media.Finished(url, fileCategory)) : d),
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
    {
      let userColor = makeColor(uid)

      showUser->Tag.conditional(
        <span className="text-xs font-bold pb-1" style={ReactDOM.Style.make(~color=userColor, ())}>
          <UserName uid />
        </span>,
      )
    }
    {downloads
    ->Tag.children
    ->Tag.conditional(
      <span className="pt-1">
        <MediaGallery
          medias=downloads
          portraitSize={switch downloads->Array.length {
          | 1 => MediaFrame.Any
          | x when x > 1 && x < 5 => MediaFrame.Medium
          | _ => MediaFrame.Small
          }}
        />
      </span>,
    )}
    <span className="text-white"> {React.string(text)} </span>
  </div>
}
