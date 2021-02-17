open Classnames

let click = el => ReactDOM.domElementToObj(el)["click"]()

let targetValue = event => ReactEvent.Form.target(event)["value"]

let addMessage = (content: Feed.content) => {
  open Firestore
  db->collection("messages")->Collection.add(content)
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
  let inputRef = React.useRef(Js.Nullable.null)
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

  let onUpload = event => {
    ReactEvent.Mouse.preventDefault(event)
    inputRef.current->Js.Nullable.toOption->Option.forEach(click)
  }
  let onFileSelect = file => {
    if Media.reAcceptedMedia->Js.Re.test_(file->File.type_) {
      let File.Id.Uuid(uuid) as id = File.Id.make()
      let fileRef = Storage.root->Storage.child(j`files/${uuid}`)

      let task = fileRef->Storage.put(file)

      setUploads(prev => Array.concat(prev, [(id, Media.Progress(0.0))]))

      let setUpload = v => {
        setUploads(
          Array.map(_, u =>
            switch u {
            | (upId, Media.Progress(_)) if upId == id => (upId, v)
            | _ => u
            }
          ),
        )
      }

      task->listen(file, setUpload)
    }
  }

  let onChange = event => {
    open ReactEvent
    let files: array<File.t> = Form.target(event)["files"]

    files->Array.forEach(file => {
      onFileSelect(file)
    })
  }

  <form className="flex flex-col space-y-2 p-4 w-full bg-gray-700" onSubmit>
    <input
      type_="file" multiple={true} ref={ReactDOM.Ref.domRef(inputRef)} className="hidden" onChange
    />
    {uploads->Tag.children->Tag.conditional(<MediaGallery medias=uploads onAdd=onUpload />)}
    <div className="flex items-end space-x-2">
      <div className={cn(["flex space-x-2 transition-all", expanded ? "max-w-0" : "max-w-xs"])}>
        <IconButton disabled={expanded} icon={React.string("U")} onClick=onUpload />
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
          onChange={event => setText(_ => event->targetValue)}
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
