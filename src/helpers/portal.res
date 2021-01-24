let portalId = "portal"

@scope("document") @val external createElement: [#div] => Dom.element = "createElement"
@scope("document") @val external getElementById: string => option<Dom.element> = "getElementById"
@send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
@send external removeChild: (Dom.element, Dom.element) => unit = "removeChild"

let domPortal = lazy {getElementById("portal")}

@react.component
let make = (~children) => {
  let (el, _) = React.useState(() => createElement(#div))

  React.useEffect1(() => {
    Lazy.force(domPortal)->Option.map(root => {
      root->appendChild(el)

      () => {
        root->removeChild(el)
      }
    })
  }, [el])
  ReactDOM.createPortal(children, el)
}
