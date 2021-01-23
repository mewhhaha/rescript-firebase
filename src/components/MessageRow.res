let makeColor = str => {
  let hex =
    str
    ->Js.String2.toLowerCase
    ->Js.String2.replaceByRe(%re("/[^0-9a-f]/g"), "")
    ->Js.String2.substring(~from=0, ~to_=6)
  j`#${hex}`
}

@react.component
let make = (~content: Feed.content, ~showUser: bool) => {
  let {uid: Firebase.Auth.UserId(uid), files, text} = content

  <div className="flex flex-col w-full px-2 py-1 break-words">
    {switch showUser {
    | true => {
        let userColor = makeColor(uid)
        <span className="text-xs font-bold pb-1" style={ReactDOM.Style.make(~color=userColor, ())}>
          {React.string(uid)}
        </span>
      }
    | false => React.null
    }}
    {switch files {
    | [] => React.null
    | _ => <FileArea files />
    }}
    <span className="text-white"> {React.string(text)} </span>
  </div>
}
