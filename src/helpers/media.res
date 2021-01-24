let reAcceptedMedia = %re("/^((image)|(video))/")
let reAcceptedImage = %re("/^image/")
let reAcceptedVideo = %re("/^image/")

let fileCategory = t =>
  switch () {
  | _ when reAcceptedImage->Js.Re.test_(t) => #image
  | _ when reAcceptedVideo->Js.Re.test_(t) => #video
  | _ => #unknown
  }

type t = Finished(string, [#image | #video | #unknown]) | Progress(float) | Error
