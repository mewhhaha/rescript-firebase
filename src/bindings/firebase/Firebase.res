type firebase
type auth
type provider
type signInOption

@scope("firebase") @val external auth: unit => auth = "auth"

module Auth = {
  @scope(("firebase", "auth")) @val external googleAuthProvider: provider = "GoogleAuthProvider"
  @get external getProviderId: provider => signInOption = "PROVIDER_ID"
}
