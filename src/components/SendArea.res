open Classnames

let addMessage = (content: Feed.content) => {
  open Firestore
  db->collection("documents")->Collection.add(content)
}

type upload = Finished(string, [#image | #video]) | Progress(float) | Error

let reAcceptedMedia = %re("/^((image)|(video))/")
let reAcceptedImage = %re("/^image/")
let reAcceptedVideo = %re("/^image/")

@react.component
let make = (~user: Firebase.Auth.user, ~onSend) => {
  let (text, setText) = React.useState(() => "")
  let (uploads, setUploads) = React.useState(() => [])
  let expanded = Js.String2.trim(text) != ""
  let finished = uploads->Belt.Array.every(((_, u)) =>
    switch u {
    | Finished(_) => true
    | _ => false
    }
  )
  let rows = text->Js.String2.splitAtMost("\n", ~limit=3)->Belt.Array.length

  let sendMessage = () => {
    open Firestore.Timestamp
    switch text {
    | "" => ()
    | _ => {
        setText(_ => "")
        setUploads(_ => [])
        onSend()
        addMessage({
          files: uploads->Belt.Array.map(((id, _)) => Firestore.Id(id)),
          text: text,
          uid: user.uid,
          created: serverTimestamp(),
        })
      }
    }
  }

  let onSubmit = event => {
    open ReactEvent
    Form.preventDefault(event)
    sendMessage()
  }

  let onEnter = event => {
    open ReactEvent
    if Keyboard.key(event) == "Enter" && !Keyboard.shiftKey(event) {
      Keyboard.preventDefault(event)
      sendMessage()
    }
  }

  let onUpload = file => {
    if reAcceptedMedia->Js.Re.test_(file->File.type_) {
      let id = Uuid.V4.make()
      let fileRef = Storage.root->Storage.child(j`files/${id}`)

      let task = fileRef->Storage.put(file)

      setUploads(prev => Belt.Array.concat([(id, Progress(0.0))], prev))

      let setUpload = v => {
        setUploads(
          Belt.Array.map(_, f =>
            switch f {
            | (uploadId, Progress(_)) when uploadId == id => (uploadId, v)
            | _ => f
            }
          ),
        )
      }

      task->Storage.on(
        #state_change,
        snapshot => {
          setUpload(Progress(snapshot->Storage.progress))
        },
        _ => {
          setUpload(Error)
        },
        () => {
          let fileType = if reAcceptedImage->Js.Re.test_(file->File.type_) {
            #image
          } else {
            #video
          }
          let reader = File.Reader.make()
          reader->File.Reader.on(
            #load,
            () => {
              switch reader->File.Reader.result {
              | None => ()
              | Some(src) => setUpload(Finished(src, fileType))
              }
            },
            false,
          )

          reader->File.Reader.readAsDataURL(file)
        },
      )
    }
  }

  <form className="flex flex-col space-y-2 p-4 w-full bg-gray-700" onSubmit>
    <div className="flex flex-wrap space-x-2 space-x-reverse space-y-2 space-y-reverse">
      {uploads
      ->Belt.Array.map(((id, upload)) =>
        <div
          key=id
          className={cn([
            "flex flex-none rounded-md w-12 h-12 border first:mr-2",
            switch upload {
            | Progress(_) => "bg-blue-300 animate-pulse"
            | Finished(_) => "bg-blue-400"
            | Error => "bg-red-400"
            },
          ])}>
          {switch upload {
          | Finished(src, fileType) =>
            switch fileType {
            | #image => <img src />
            | _ => <video className="flex-grow object-cover"> <source src={src} /> </video>
            }
          | Progress(progress) => React.null
          | Error => React.null
          }}
        </div>
      )
      ->React.array}
    </div>
    <div className="flex items-end space-x-2">
      <div
        className={cn([
          "flex space-x-2 transition-all",
          "max-w-0"->on(expanded),
          "max-w-xs"->on(!expanded),
        ])}>
        <UploadButton disabled={expanded} id="image" icon={React.string("U")} onUpload />
      </div>
      <div
        className="flex flex-grow rounded-2xl min-w-0 bg-gray-200 px-4 py-1 focus-within:ring -mb-1">
        <textarea
          placeholder="Aa"
          rows
          className={cn([
            "flex-grow bg-gray-200 resize-none  min-w-0 opacity-100",
            "focus:outline-none",
          ])}
          onKeyDown=onEnter
          value=text
          onChange={event => setText(_ => ReactEvent.Form.target(event)["value"])}
        />
      </div>
      <button
        type_="submit"
        className={cn([
          "flex-none w-6 h-6 opacity-50 border-4",
          if expanded {
            "transition-opacity bg-blue-600 border-blue-200 hover:opacity-100"
          } else {
            "bg-gray-600 border-gray-200"
          },
        ])}
        disabled={!expanded || !finished}
      />
    </div>
  </form>
}
