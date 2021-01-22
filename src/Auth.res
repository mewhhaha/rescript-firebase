type state = Sign | SignedIn(FirebaseUI.authResult) | SignedOut

@react.component
let make = (~children) => {
  let (state, setState) = React.useState(() => Sign)

  React.useEffect0(() => {
    let config = FirebaseUI.makeConfig((authResult, _) => {
      setState(_ => SignedIn(authResult))
      true
    })
    FirebaseUI.start(config)
    None
  })
  switch state {
  | Sign =>
    <div className="flex flex-grow items-center justify-center">
      <div id="firebaseui-auth-container" />
    </div>
  | SignedIn(authResult) => children(authResult)
  | SignedOut => React.string("Bye")
  }
}
