@react.component
let make = (~files: array<Feed.file>) => {
  files
  ->Belt.Array.map(({t, id}) => {
    let Feed.ID(idString) = id
    switch t {
    | #image => <img key=idString src=idString />
    | #video => <span key=idString> {React.string(idString)} </span>
    }
  })
  ->React.array
}
