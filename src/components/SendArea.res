open Cn

let addDocument = (document: Feed.add) => {
  open Firestore
  db->collection("documents")->Collection.add(document)
}

@react.component
let make = (~user: Firebase.Auth.user) => {
  let (state, setState) = React.useState(() => "")
  let expanded = state != ""

  <form
    className="flex p-4 items-center space-x-2 w-full max-w-xs"
    onSubmit={event => {
      ReactEvent.Form.preventDefault(event)
      switch state {
      | "" => ()
      | _ => {
          setState(_ => "")
          addDocument({files: [], text: state, user: user.uid})
        }
      }
    }}>
    <div
      className={cn([
        "flex space-x-2 transition-all",
        "max-w-0"->on(expanded),
        "max-w-xs"->on(!expanded),
      ])}>
      <IconButton disabled={expanded} id="video" icon={React.string("V")} />
      <IconButton disabled={expanded} id="image" icon={React.string("I")} />
    </div>
    <input
      placeholder="Aa"
      className={cn([
        "flex-grow bg-gray-200 rounded-2xl min-w-0 h-8 pb-1 px-4 opacity-100",
        "focus:outline-none focus:ring",
      ])}
      value=state
      onChange={event => setState(_ => ReactEvent.Form.target(event)["value"])}
    />
    <button
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
