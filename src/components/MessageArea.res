let groupBy = (array, get) => {
  switch array->Array.length {
  | 0 => []
  | _ => {
      let groups = [[]]
      array->Array.forEach(item => {
        let lastIndex = groups->Array.length - 1

        let pushLast = () => groups[lastIndex]->Option.map(Js.Array.push(item))->ignore
        let pushNext = () => groups->Js.Array.push([item], _)->ignore

        switch groups[lastIndex]->Option.flatMap(group => group->Array.get(0)) {
        | Some(prev) if get(prev) == get(item) => pushLast()
        | None => pushLast()
        | _ => pushNext()
        }
      })

      groups
    }
  }
}

@react.component
let make = (~messages: array<Feed.message>, ~user: Firebase.Auth.user) => {
  <div className="flex flex-col w-full space-y-2">
    {messages
    ->groupBy(((_, {uid})) => uid)
    ->Array.mapWithIndex((i, group) => {
      <MessageGroup key={Int.toString(i)} group user />
    })
    ->React.array}
  </div>
}
