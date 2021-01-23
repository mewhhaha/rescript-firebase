@unboxed
type id = ID(string)
type file = {t: [#image | #video], id: id}
type add = {user: Firebase.Auth.userId, files: array<file>, text: string}
type get = {id: id, user: Firebase.Auth.userId, files: array<file>, text: string}
