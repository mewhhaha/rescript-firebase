type firestore
type collection
type query
type document
type unsubscribe = unit => unit
type snapshot<'a> = 'a => unit

type data

@val @scope("firebase") external firestore: unit => firestore = "firestore"
@send external collection: (firestore, string) => collection = "collection"

module Collection = {
  @send external collect: collection => Js.Promise.t<query> = "get"
  @send external forEach: (query, document => unit) => unit = "forEach"
  @send external document: (collection, string) => document = "doc"
  @send external onSnapshot: (collection, snapshot<query>) => unsubscribe = "onSnapshot"
  @send external add: (collection, 'a) => unit = "add"

  let toArray = collection => {
    let array = []
    collection->forEach(doc => {
      array |> Js.Array.push(doc) |> ignore
    })

    array
  }
}

module Document = {
  @send external data: (document, unit) => 'a = "data"
  @send external onSnapshot: (document, snapshot<document>) => unsubscribe = "onSnapshot"
}

let db = firestore()
