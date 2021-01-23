type state =
  | LoadingDocuments
  | ErrorDocuments
  | LoadedDocuments(array<Feed.message>)
@send external messageContent: Firestore.document => Feed.content = "data"

let onDocuments = callback => {
  open Firestore
  db->collection("documents")->Collection.orderBy("created", #asc)->Collection.onSnapshot(callback)
}

let scrollToBottom = el => ReactDOM.domElementToObj(el)["scrollIntoView"](~block="end")

let scrollToSelf = (divRef: React.ref<Js.Nullable.t<Dom.element>>) => {
  switch divRef.current->Js.Nullable.toOption {
  | Some(el) => el->scrollToBottom
  | _ => ()
  }
}

let both = (a, b, v) => (v->a, v->b)

@react.component
let make = (~user: Firebase.Auth.user) => {
  let (state, setState) = React.useState(() => LoadingDocuments)
  let divRef = React.useRef(Js.Nullable.null)

  React.useEffect0(() => {
    open Firestore

    let callback = query => {
      let messages =
        query->Collection.toArray->Belt.Array.map(both(Firestore.Document.id, messageContent))

      setState(_ => LoadedDocuments(messages))

      open Belt
      let lastMessage = messages->Array.get(messages->Array.length - 1)
      let userMessage = lastMessage->Option.map(((_, content)) => content.uid == user.uid)
      let shouldScroll = state == LoadedDocuments([]) || userMessage == Some(true)
      if shouldScroll {
        scrollToSelf(divRef)
      }
    }
    let unsub = onDocuments(callback)

    Some(unsub)
  })

  <div className="flex flex-col w-full min-h-0 max-w-sm h-full max-h-96">
    <div
      className="flex flex-col flex-grow overflow-y-scroll overflow-anchor-none w-full bg-gray-700 p-1">
      {switch state {
      | LoadingDocuments => React.string("Loading")
      | ErrorDocuments => React.string("Error")
      | LoadedDocuments(messages) => <MessageArea messages user />
      }}
      <div className="h-px flex-none overflow-anchor-auto" ref={ReactDOM.Ref.domRef(divRef)} />
    </div>
    <SendArea user />
  </div>
}
