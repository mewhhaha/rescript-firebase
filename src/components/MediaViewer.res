@react.component
let make = (~src, ~fileCategory, ~onClose) => {
  <div className="fixed top-0 left-0 flex items-center justify-center w-screen h-screen">
    <div className="absolute w-full h-full bg-gray-500 opacity-50 z-40" />
    <div className="absolute z-50 object-center">
      <FocusOn onEscapeKey=onClose onClickOutside=onClose>
        {switch fileCategory {
        | #image => <img src />
        | #video => <video controls={true}> <source src /> </video>
        | #unknown => React.null
        }}
      </FocusOn>
    </div>
  </div>
}
