let cn = classes => classes->Array.map(Js.String2.trim)->Array.reduce("", (a, b) => `${a} ${b}`)
let on = (classes, p) =>
  if p {
    classes
  } else {
    ""
  }
