type content = {
  created: Firestore.timestamp,
  uid: Firebase.Auth.userId,
  files: array<Firestore.id>,
  text: string,
}
type message = (Firestore.id, content)
