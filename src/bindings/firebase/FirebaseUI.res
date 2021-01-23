type firebaseUI
type auth
type authUI
type redirectUrl

type authCallbacks = {
  signInSuccessWithAuthResult: (Firebase.Auth.authResult, redirectUrl) => bool,
  signInSuccessUrl: string,
  signInFlow: option<[#popup]>,
}

type config = {
  signInOptions: array<Firebase.signInOption>,
  callbacks: authCallbacks,
}

@scope(("window", "location")) @val external href: string = "href"
@scope(("firebaseui", "auth")) @new external makeUI: Firebase.auth => authUI = "AuthUI"
@send external startUI: (authUI, string, config) => unit = "start"

let ui = makeUI(Firebase.auth())
let container = "#firebaseui-auth-container"
let config = {
  signInOptions: [Firebase.Auth.googleAuthProvider->Firebase.Auth.getProviderId],
  callbacks: {
    signInSuccessWithAuthResult: (_, _) => true,
    signInSuccessUrl: href,
    signInFlow: Some(#popup),
  },
}

let start = () => ui->startUI(container, config)
