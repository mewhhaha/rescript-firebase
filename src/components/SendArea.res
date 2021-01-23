open Classnames

let addDocument = (document: Feed.content) => {
  open Firestore
  db->collection("documents")->Collection.add(document)
}

@react.component
let make = (~user: Firebase.Auth.user) => {
  let (state, setState) = React.useState(() => "")
  let expanded = state != ""
  let rows = state->Js.String2.splitAtMost("\n", ~limit=3)->Belt.Array.length

  let onSubmit = event => {
    open Firestore.Timestamp

    ReactEvent.Form.preventDefault(event)
    switch state {
    | "" => ()
    | _ => {
        setState(_ => "")
        addDocument({
          files: [],
          text: state,
          uid: user.uid,
          created: serverTimestamp(),
        })
      }
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
