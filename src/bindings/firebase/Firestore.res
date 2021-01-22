type firestore
type collection
type collectionQuery
type document
type unsubscribe = unit => unit
type snapshotHandler = document => unit
type data

@val @scope("firebase") external firestore: unit => firestore = "firestore"
@send external collection: (firestore, string) => collection = "collection"

module Collection = {
  @send external collect: collection => Js.Promise.t<collectionQuery> = "get"
  @send external forEach: (collectionQuery, document => unit) => unit = "forEach"
  @send external document: (collection, string) => document = "doc"
}

module Document = {
  @send external data: document => data = "data"
  @send external onSnapshot: (document, snapshotHandler) => unsubscribe = "onSnapshot"
}

let db = firestore()
