type storage
type storageRef
type snapshot
type task
type error

@scope("firebase") @val external storage: unit => storage = "storage"
@send external ref: storage => storageRef = "ref"
@send external child: (storageRef, string) => storageRef = "child"
@get external name: storageRef => string = "name"
@get external fullPath: storageRef => string = "fullPath"
@send external put: (storageRef, File.t) => task = "put"
@send
external on: (task, [#state_change], snapshot => unit, error => unit, unit => unit) => unit = "on"
@get external bytesTransferred: snapshot => float = "bytesTransferred"
@get external totalBytes: snapshot => float = "totalBytes"
@get external snapshot: task => snapshot = "snapshot"
@scope(("snapshot", "ref")) @send
external getDownloadURL: task => Js.Promise.t<string> = "getDownloadURL"

let x = Js.log(storage())
let root = storage()->ref

let progress = snapshot => snapshot->bytesTransferred /. snapshot->totalBytes
