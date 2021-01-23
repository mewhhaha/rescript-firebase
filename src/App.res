type state =
  | LoadingDocuments
  | ErrorDocuments
  | LoadedDocuments(array<Feed.get>)
@send external documentData: Firestore.document => Feed.get = "data"

let onDocuments = callback => {
  open Firestore
  db->collection("documents")->Collection.onSnapshot(callback)
}

@react.component
let make = (~user: Firebase.Auth.user) => {
  let (state, setState) = React.useState(() => LoadingDocuments)

  React.useEffect0(() => {
    open Firestore

    let callback = query => {
      let docs = query->Collection.toArray |> Js.Array.map(doc => doc->documentData)
      setState(_ => LoadedDocuments(docs))
    }
    let unsub = onDocuments(callback)

    Some(unsub)
  })

  <div className="flex flex-col flex-grow">
    {switch state {
    | LoadingDocuments => React.string("Loading")
    | ErrorDocuments => React.string("Error")
    | LoadedDocuments(payload) =>
      payload
      ->Belt.Array.map(({id, files, text}) => {
        let Feed.ID(idString) = id
        <div key=idString> <FileArea files /> <div> {React.string(text)} </div> </div>
      })
      ->React.array
    }}
    <SendArea user />
  </div>
}
