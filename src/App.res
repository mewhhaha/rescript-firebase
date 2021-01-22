type payload = {"message": array<string>}
@bs.scope("JSON") @bs.val external parseResponse: Fetch.response => payload = "parse"
@bs.get external getMessage: payload => array<string> = "message"

type state =
  | LoadingDogs
  | ErrorFetchingDogs
  | LoadedDogs(array<string>)

@react.component
let make = (~user: FirebaseUI.authResult) => {
  let (state, setState) = React.useState(() => LoadingDogs)

  let x: int = ""
  React.useEffect0(() => {
    let abort = Fetch.get("https://dog.ceo/api/breeds/image/random/3", state =>
      switch state {
      | Error(_) => setState(_ => ErrorFetchingDogs)
      | Loaded(OK(res)) => setState(_ => LoadedDogs(res->parseResponse->getMessage))
      | Loaded(NoContent) => setState(_ => LoadedDogs([]))
      | _ => ()
      }
    )

    Some(abort)
  })

  React.useEffect0(() => {
    open Firestore
    open Js.Promise

    let unsub = db
    ->collection("documents")
    ->Collection.document("bOeoBPn75iRmQHjyUziv")
    ->Document.onSnapshot(document => {
      Js.log(document->Document.data)
      ()
    })

    db->collection("documents")->Collection.collect->then_(documents => {
      documents->Collection.forEach(document => {
        Js.log(document->Document.data)
      })

      resolve()
    }, _)->ignore

    Some(unsub)
  })

  <div>
    {switch state {
    | LoadingDogs => React.string("Loading")
    | ErrorFetchingDogs => React.string("Error")
    | LoadedDogs(dogs) =>
      React.array(
        Belt.Array.map(dogs, d => {
          <img key=d src=d />
        }),
      )
    }}
  </div>
}
