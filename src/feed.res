type file = {t: [#image | #video], id: Firestore.id}
type content = {
  created: Firestore.timestamp,
  uid: Firebase.Auth.userId,
  files: array<file>,
  text: string,
}
type message = (Firestore.id, content)
