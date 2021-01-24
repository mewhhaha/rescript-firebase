open Classnames

let groupBy = (array, get) => {
  switch array->Belt.Array.length {
  | 0 => []
  | _ =>
    array->Belt.Array.reduce([[]], (groups, item) => {
      let lastIndex = groups->Belt.Array.length - 1
      if (
        switch groups[lastIndex]->Belt.Array.get(0) {
        | None => true
        | Some(prev) when get(prev) == get(item) => true
        | _ => false
        }
      ) {
        groups[lastIndex] |> Js.Array.push(item)
      } else {
        groups |> Js.Array.push([item])
      }->ignore

      groups
    })
  }
}

@react.component
let make = (~messages: array<Feed.message>, ~user: Firebase.Auth.user) => {
  <div className="flex flex-col w-full space-y-2">
    {messages
    ->groupBy(((_, {uid})) => uid)
    ->Belt.Array.map(group => {
      switch group->Belt.Array.get(0) {
      | None => React.null
      | Some((Firestore.Id(id), _)) =>
        <div key=id className="flex flex-col w-full space-y-0.5">
          {group
          ->Belt.Array.mapWithIndex((i, message) => {
            let (Firestore.Id(id), content) = message
            let firstRow = i == 0
            let thisUser = user.uid == content.uid
            <span
              key=id
              className={cn([
                "max-w-xs bg-gray-500",
                "rounded-r-xl"->on(thisUser),
                "rounded-tl-xl"->on(thisUser && firstRow),
                "rounded-l-xl"->on(!thisUser),
                "rounded-tr-xl"->on(!thisUser && firstRow),
                if thisUser {
                  "self-start"
                } else {
                  "self-end"
                },
              ])}>
              <MessageRow content showUser=firstRow />
            </span>
          })
          ->React.array}
        </div>
      }
    })
    ->React.array}
  </div>
}