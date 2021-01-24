open Classnames

let addMessage = (content: Feed.content) => {
  open Firestore
  db->collection("documents")->Collection.add(content)
}

let listen = (task, file, setUpload) => {
  task->Storage.on(
    #state_change,
    snapshot => {
      setUpload(Media.Progress(snapshot->Storage.progress))
    },
    _ => {
      setUpload(Media.Error)
    },
    () => {
      let fileCategory = file->File.type_->Media.fileCategory
      let reader = File.Reader.make()
      reader->File.Reader.on(
        #load,
        () => {
          switch reader->File.Reader.result {
          | None => ()
          | Some(src) => setUpload(Media.Finished(src, fileCategory))
          }
        },
        false,
      )

      reader->File.Reader.readAsDataURL(file)
    },
  )
}

@react.component
let make = (~user: Firebase.Auth.user, ~onSend) => {
  let (text, setText) = React.useState(() => "")
  let (uploads, setUploads) = React.useState(() => [])
  let expanded = Js.String2.trim(text) != "" || uploads != []
  let finished = uploads->Array.every(upload =>
    switch upload->Tuple.snd {
    | Media.Finished(_) => true
    | _ => false
    }
  )
  let rows = text->Js.String2.splitAtMost("\n", ~limit=3)->Array.length

  let sendMessage = () => {
    open Firestore.Timestamp

    switch expanded {
    | false => ()
    | true => {
        setText(_ => "")
        setUploads(_ => [])
        onSend()
        addMessage({
          files: uploads->Array.map(Tuple.fst),
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
    if Media.reAcceptedMedia->Js.Re.test_(file->File.type_) {
      let Firestore.Id(path) as id = Firestore.Id(Uuid.V4.make())
      let fileRef = Storage.root->Storage.child(j`files/${path}`)

      let task = fileRef->Storage.put(file)

      setUploads(prev => Array.concat([(id, Media.Progress(0.0))], prev))

      let setUpload = v => {
        setUploads(
          Array.map(_, u =>
            switch u {
            | (upId, Media.Progress(_)) when upId == id => (upId, v)
            | _ => u
            }
          ),
        )
      }

      task->listen(file, setUpload)
    }
  }

  <form className="flex flex-col space-y-2 p-4 w-full bg-gray-700" onSubmit>
    <MediaArea medias=uploads />
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
          if expanded && finished {
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
