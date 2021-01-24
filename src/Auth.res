type state = Loading | SignIn | SignedIn(Firebase.Auth.user) | SignedOut

let updateUser = ({uid: Firebase.Auth.UserId(uid), displayName}: Firebase.Auth.user) => {
  open Firestore
  let userInfo: Feed.userInfo = {name: displayName}
  db->collection("users")->Collection.document(uid)->Document.set(userInfo)
}

@react.component
let make = (~children) => {
  let (state, setState) = React.useState(() => Loading)

  React.useEffect0(() => {
    let callback = u => {
      switch u->Js.Nullable.toOption {
      | None => {
          setState(_ => SignIn)
          FirebaseUI.start()
        }
      | Some(user) => {
          updateUser(user)
          setState(_ => SignedIn(user))
        }
      }
    }
    let unsub = Firebase.auth()->Firebase.Auth.onAuthStateChanged(callback)

    Some(unsub)
  })

  switch state {
  | Loading => <Loading />
  | SignIn => <div id="firebaseui-auth-container" />
  | SignedIn(user) => children(user)
  | SignedOut => React.string("Bye")
  }
}
