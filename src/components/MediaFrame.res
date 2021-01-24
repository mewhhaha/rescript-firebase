open Classnames

@react.component
let make = (~children, ~media: Media.t) => {
  let (show, setShow) = React.useState(_ => None)
  let onClose = () => setShow(_ => None)
  <button
    onClick={event =>
      switch (ReactEvent.Synthetic.defaultPrevented(event), media) {
      | (false, Finished(src, fileType)) => setShow(_ => Some((src, fileType)))
      | _ => ()
      }}
    className={cn([
      "flex flex-none focus:outline-none rounded-md w-12 h-12 hover:opacity-50 border first:mr-2",
      switch media {
      | Progress(_) => "bg-blue-300 animate-pulse"
      | Finished(_) => "bg-blue-400"
      | Error => "bg-red-400"
      },
    ])}>
    {children}
    {switch show {
    | None => React.null
    | Some((src, fileType)) => <Portal> <MediaViewer src fileType onClose /> </Portal>
    }}
  </button>
}