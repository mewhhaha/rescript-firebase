open Classnames

type state =
  | LoadingMessages
  | ErrorMessages
  | LoadedMessages(array<Feed.message>)
@send external messageContent: Firestore.document => Feed.content = "data"

let onDocuments = callback => {
  open Firestore
  db->collection("documents")->Collection.orderBy("created", #asc)->Collection.onSnapshot(callback)
}

let scrollToBottom = el => {
  let elObj = ReactDOM.domElementToObj(el)
  elObj["scrollTo"](0, elObj["scrollHeight"])
}

let scrollAtBottom = el => {
  let elObj = ReactDOM.domElementToObj(el)
  elObj["scrollHeight"] - elObj["scrollTop"] === elObj["clientHeight"]
}

let both = (a, b, v) => (v->a, v->b)

@react.component
let make = (~user: Firebase.Auth.user) => {
  let (state, setState) = React.useState(() => LoadingMessages)
  let scrollRef = React.useRef(Js.Nullable.null)

  React.useEffect0(() => {
    open Firestore

    let callback = query => {
      let messages =
        query->Collection.toArray->Array.map(both(Firestore.Document.id, messageContent))

      let elRef = scrollRef.current->Js.Nullable.toOption
      let shouldScroll = elRef->Option.map(scrollAtBottom)
      setState(_ => LoadedMessages(messages))
      if shouldScroll == Some(true) {
        elRef->Option.forEach(scrollToBottom)
      }
    }
    let unsub = onDocuments(callback)

    Some(unsub)
  })

  let onSend = () => scrollRef.current->Js.Nullable.toOption->Option.forEach(scrollToBottom)

  <div className="flex flex-col w-full xl:max-w-4xl min-h-0 h-full bg-gray-700">
    <TitleStripe />
    <div
      ref={ReactDOM.Ref.domRef(scrollRef)}
      className={cn([
        "flex justify-center flex-grow overflow-y-scroll overflow-anchor-none",
        "animate-pulse"->on(state == LoadingMessages),
      ])}
      style={ReactDOM.Style.make(~backgroundImage=j`url(./svg/chat.svg)`, ())}>
      <div className="flex flex-col w-11/12">
        {switch state {
        | LoadingMessages => React.null
        | ErrorMessages => React.string("Error")
        | LoadedMessages(messages) => <MessageArea messages user />
        }}
        <div className="flex-none w-full h-6 overflow-anchor-auto" />
      </div>
    </div>
    <SendArea user onSend />
  </div>
}
