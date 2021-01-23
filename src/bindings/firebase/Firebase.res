type firebase
type auth
type provider
type signInOption

@scope("firebase") @val external auth: unit => auth = "auth"

module Auth = {
  type userId
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
    uid: userId,
  }
  type authResult = {
    credential: credential,
    user: user,
  }

  @scope(("firebase", "auth")) @val external googleAuthProvider: provider = "GoogleAuthProvider"
  @get external getProviderId: provider => signInOption = "PROVIDER_ID"
}
