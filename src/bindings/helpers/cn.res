let cn = classes =>
  classes->Belt.Array.map(Js.String2.trim)->Belt.Array.reduce("", (a, b) => `${a} ${b}`)
let on = (classes, p) =>
  if p {
    classes
  } else {
    ""
  }
