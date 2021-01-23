@react.component
let make = (~content: Feed.content, ~user: option<Firebase.Auth.user>) => {
  let {files, text} = content

  <div className="flex flex-col w-full px-2 py-1 break-words">
    {switch user {
    | None => React.null
    | Some({uid: UserId(uid)}) =>
      <span className="text-xs font-bold text-green-500 pb-1"> {React.string(uid)} </span>
    }}
    {switch files {
    | [] => React.null
    | _ => <FileArea files />
    }}
    <span className="text-white"> {React.string(text)} </span>
  </div>
}
