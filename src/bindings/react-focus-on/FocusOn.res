@module("react-focus-on") @react.component
external make: (
  ~children: React.element,
  ~onEscapeKey: unit => unit=?,
  ~onClickOutside: unit => unit=?,
) => React.element = "FocusOn"
