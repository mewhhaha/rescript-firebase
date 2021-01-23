open Cn

@react.component
let make = (~disabled, ~icon, ~id) => {
  let ref = React.useRef(Js.Nullable.null)
  <div className="relative flex-none w-6 h-6 rounded-xl hover:bg-gray-200">
    <input type_="file" id ref={ReactDOMRe.Ref.domRef(ref)} className="hidden" />
    <button
      onClick={_ => {
        switch ref.current->Js.Nullable.toOption {
        | None => ()
        | Some(el) => ReactDOMRe.domElementToObj(el)["click"]()
        }
      }}
      disabled
      className={cn([
        "focus:outline-none focus:ring",
        "transition-transform transform absolute w-full h-full",
        "scale-0 rotate-180"->on(disabled),
      ])}>
      {icon}
    </button>
  </div>
}
