@react.component
let make = (~medias: array<(Firestore.id, Media.t)>) => {
  <div className="flex flex-wrap space-x-2 space-x-reverse space-y-2 space-y-reverse">
    {medias
    ->Array.map(((Firestore.Id(id), media)) => {
      <MediaFrame key=id media>
        {switch media {
        | Finished(src, #image) => <img src className="w-full h-full object-cover" />
        | Finished(src, #video) =>
          <video className="w-full h-full object-cover"> <source src /> </video>
        | _ => React.null
        }}
      </MediaFrame>
    })
    ->React.array}
  </div>
}
