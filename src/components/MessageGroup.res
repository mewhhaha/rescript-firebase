open Classnames

@react.component
let make = (~group: array<Feed.message>, ~user: Firebase.Auth.user) => {
  switch group[0]->Option.map(Tuple.fst) {
  | None => React.null
  | Some(Firestore.Id(id)) =>
    <div key=id className="flex flex-col w-full space-y-0.5">
      {group
      ->Array.mapWithIndex((i, message) => {
        let (Firestore.Id(id), content) = message
        let firstRow = i == 0
        let thisUser = user.uid == content.uid
        <span
          key=id
          className={cn([
            "max-w-xs",
            "rounded-tl-xl"->on(!thisUser && firstRow),
            "rounded-tr-xl"->on(thisUser && firstRow),
            !thisUser
              ? "self-start rounded-r-xl bg-gray-500"
              : "self-end rounded-l-xl bg-green-700",
          ])}>
          <MessageRow content showUser=firstRow />
        </span>
      })
      ->React.array}
    </div>
  }
}
