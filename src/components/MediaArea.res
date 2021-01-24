@react.component
let make = (~medias: array<(Firestore.id, Media.t)>) => {
  <div className="flex flex-wrap space-x-2 space-x-reverse space-y-2 space-y-reverse">
    {medias
    ->Array.map(((Firestore.Id(id), media)) => {
      <MediaFrame key=id media>
        {switch media {
        | Finished(src, fileCategory) =>
          switch fileCategory {
          | #image => <img src />
          | #video => <video className="flex-grow object-fill"> <source src={src} /> </video>
          }
        | Progress(_) => React.null
        | Error => React.null
        }}
      </MediaFrame>
    })
    ->React.array}
  </div>
}
