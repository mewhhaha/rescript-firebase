@react.component
let make = (~uid) => {
  let (name, setName) = React.useState(_ => uid)

  React.useEffect0(() => {
    open Firestore
    let unsub =
      db
      ->collection("users")
      ->Collection.document(uid)
      ->Document.onSnapshot(snapshot => {
        let {name}: Feed.userInfo = snapshot->Document.data
        setName(_ => name)
      })
    Some(unsub)
  })

  {React.string(name)}
}
