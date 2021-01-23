type state = Sign | SignedIn(Firebase.Auth.user) | SignedOut

@react.component
let make = (~children) => {
  let (state, setState) = React.useState(() => Sign)

  React.useEffect0(() => {
    let callback = user => {
      setState(_ => SignedIn(user))
    }
    let unsub = Firebase.auth()->Firebase.Auth.onAuthStateChanged(callback)

    Some(unsub)
  })
  switch state {
  | Sign => <div id="firebaseui-auth-container" />
  | SignedIn(user) => children(user)
  | SignedOut => React.string("Bye")
  }
}
