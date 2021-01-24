type firestore
type timestamp
type collection
type query
type document
type unsubscribe = unit => unit
type snapshot<'a> = 'a => unit

@unboxed
type id = Id(string)
type data

@scope("firebase") @val external firestore: unit => firestore = "firestore"
@send external collection: (firestore, string) => collection = "collection"

module Timestamp = {
  @scope(("firebase", "firestore", "Timestamp")) @val
  external fromDate: Js.Date.t => timestamp = "fromDate"
  @scope(("firebase", "firestore", "FieldValue")) @val
  external serverTimestamp: unit => timestamp = "serverTimestamp"
}

module Collection = {
  @send external collect: collection => Js.Promise.t<query> = "get"
  @send external forEach: (query, document => unit) => unit = "forEach"
  @send external document: (collection, string) => document = "doc"
  @send external onSnapshot: (collection, snapshot<query>) => unsubscribe = "onSnapshot"
  @send external add: (collection, 'a) => unit = "add"
  @send external orderBy: (collection, string, [#desc | #asc]) => collection = "orderBy"
  @get external docs: query => array<document> = "docs"
}

module Document = {
  @send external data: document => 'a = "data"
  @send external set: (document, 'a) => unit = "set"
  @get external id: document => id = "id"
  @send external onSnapshot: (document, snapshot<document>) => unsubscribe = "onSnapshot"
}

let db = firestore()
