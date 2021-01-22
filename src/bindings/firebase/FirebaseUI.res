type firebaseUI
type auth
type authUI
type accessToken
type refreshToken
type idToken
type emailAddress

type credential = {
  accessToken: accessToken,
  idToken: idToken,
}
type user = {
  displayName: string,
  refreshToken: refreshToken,
  email: emailAddress,
}
type authResult = {
  credential: credential,
  user: user,
}
type redirectUrl

type authCallbacks = {
  signInSuccessWithAuthResult: (authResult, redirectUrl) => bool,
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
let makeConfig = callback => {
  signInOptions: [Firebase.Auth.googleAuthProvider->Firebase.Auth.getProviderId],
  callbacks: {
    signInSuccessWithAuthResult: callback,
    signInSuccessUrl: href,
    signInFlow: Some(#popup),
  },
}

let start = config => ui->startUI(container, config)
