@react.component
let make = (~files: array<Firestore.id>) => {
  files
  ->Belt.Array.map(id => {
    let Firestore.Id(idString) = id
    React.null
  })
  ->React.array
}
