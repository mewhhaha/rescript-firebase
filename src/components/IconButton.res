open Classnames

@react.component
let make = (~disabled, ~icon, ~onClick) => {
  <div
    className={cn(["relative flex-none w-6 h-6 rounded-full", "hover:bg-gray-200"->on(!disabled)])}>
    <button
      onClick={onClick}
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
