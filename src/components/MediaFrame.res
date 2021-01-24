open Classnames

type size = Small | Medium | Any

@react.component
let make = (~children, ~media: Media.t, ~size=Some(Small)) => {
  let (show, setShow) = React.useState(_ => None)
  let onClose = () => setShow(_ => None)
  <button
    onClick={event => {
      switch (ReactEvent.Mouse.defaultPrevented(event), media) {
      | (false, Finished(src, fileCategory)) => setShow(_ => Some((src, fileCategory)))
      | _ => ()
      }
      ReactEvent.Mouse.preventDefault(event)
    }}
    className={cn([
      "flex focus:outline-none rounded-md hover:opacity-50 first:mr-2 mb-2",
      switch media {
      | Progress(_) => "bg-blue-300 animate-pulse"
      | Finished(_) => "bg-blue-400"
      | Error => "bg-red-400"
      },
      switch size {
      | Some(Small) => "w-12 h-12"
      | Some(Medium) => "w-32 h-32"
      | _ => ""
      },
    ])}>
    {children}
    {switch show {
    | None => React.null
    | Some((src, fileCategory)) => <Portal> <MediaViewer src fileCategory onClose /> </Portal>
    }}
  </button>
}
