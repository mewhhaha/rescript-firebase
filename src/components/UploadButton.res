open Classnames

let click = el => ReactDOM.domElementToObj(el)["click"]()

@react.component
let make = (~disabled, ~icon, ~id, ~onUpload) => {
  let inputRef = React.useRef(Js.Nullable.null)
  let onChange = event => {
    open ReactEvent
    let files: array<File.t> = Form.target(event)["files"]

    files->Array.forEach(file => {
      onUpload(file)
    })
  }
  <div
    className={cn(["relative flex-none w-6 h-6 rounded-full", "hover:bg-gray-200"->on(!disabled)])}>
    <input
      type_="file"
      multiple={true}
      id
      ref={ReactDOM.Ref.domRef(inputRef)}
      className="hidden"
      onChange
    />
    <button
      onClick={_ => {
        switch inputRef.current->Js.Nullable.toOption {
        | None => ()
        | Some(el) => el->click
        }
      }}
      disabled
      className={cn([
        "focus:outline-none focus:ring text-white hover:text-black",
        "transition-transform transform absolute w-full h-full",
        "scale-0 rotate-180"->on(disabled),
      ])}>
      {icon}
    </button>
  </div>
}
