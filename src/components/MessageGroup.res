open Classnames

@react.component
let make = (~group: array<Feed.message>, ~user: Firebase.Auth.user) => {
  switch group->Array.get(0) {
  | None => React.null
  | Some((Firestore.Id(id), _)) =>
    <div key=id className="flex flex-col w-full space-y-0.5">
      {group
      ->Array.mapWithIndex((i, message) => {
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
}
