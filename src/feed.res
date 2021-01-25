type userInfo = {name: string}
type content = {
  created: Firestore.timestamp,
  uid: Firebase.Auth.userId,
  files: array<File.Id.t>,
  text: string,
}
type message = (Firestore.id, content)
