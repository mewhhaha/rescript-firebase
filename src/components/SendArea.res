open Classnames

let addMessage = (content: Feed.content) => {
  open Firestore
  db->collection("documents")->Collection.add(content)
}

@react.component
let make = (~user: Firebase.Auth.user) => {
  let (state, setState) = React.useState(() => "")
  let expanded = state != ""
  let rows = state->Js.String2.splitAtMost("\n", ~limit=3)->Belt.Array.length

  let sendMessage = () => {
    open Firestore.Timestamp
    switch state {
    | "" => ()
    | _ => {
        setState(_ => "")
        addMessage({
          files: [],
          text: state,
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

  <form className="flex p-4 items-center space-x-2 w-full bg-gray-700" onSubmit>
    <div
      className={cn([
        "flex space-x-2 transition-all",
        "max-w-0"->on(expanded),
        "max-w-xs"->on(!expanded),
      ])}>
      <IconButton disabled={expanded} id="video" icon={React.string("V")} />
      <IconButton disabled={expanded} id="image" icon={React.string("I")} />
    </div>
    <div className="flex flex-grow rounded-2xl min-w-0 bg-gray-200 px-4 py-1 focus-within:ring">
      <textarea
        placeholder="Aa"
        rows
        className={cn([
          "flex-grow bg-gray-200 resize-none  min-w-0 opacity-100",
          "focus:outline-none",
        ])}
        onKeyDown=onEnter
        value=state
        onChange={event => setState(_ => ReactEvent.Form.target(event)["value"])}
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
      disabled={!expanded}
    />
  </form>
}
