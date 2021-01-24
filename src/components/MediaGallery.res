open Classnames

@react.component
let make = (
  ~medias: array<(Firestore.id, Media.t)>,
  ~onAdd: option<ReactEvent.Mouse.t => unit>=?,
  ~portraitSize=?,
) => {
  <div className="flex flex-wrap space-x-2 space-x-reverse space-y-2 space-y-reverse items-center">
    {medias
    ->Array.map(((Firestore.Id(id), media)) => {
      <MediaFrame key=id media size=portraitSize>
        {switch media {
        | Finished(src, #image) => <img src className="w-full h-full object-fill rounded-md" />
        | Finished(src, #video) =>
          <video className="w-full h-full object-fill rounded-md"> <source src /> </video>
        | _ => React.null
        }}
      </MediaFrame>
    })
    ->Array.concat([
      switch onAdd {
      | None => React.null
      | Some(onClick) =>
        <button
          onClick
          className={cn([
            "flex flex-none justify-center focus:outline-none rounded-md w-12 h-12 hover:opacity-50 border bg-gray-700",
          ])}>
          <span className="text-white font-bold text-2xl pt-1"> {React.string("+")} </span>
        </button>
      },
    ])
    ->React.array}
  </div>
}
