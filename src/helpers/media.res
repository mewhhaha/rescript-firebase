let reAcceptedMedia = %re("/^((image)|(video))/")
let reAcceptedImage = %re("/^image/")
let reAcceptedVideo = %re("/^video/")

let fileCategory = t =>
  switch () {
  | _ if reAcceptedImage->Js.Re.test_(t) => #image
  | _ if reAcceptedVideo->Js.Re.test_(t) => #video
  | _ => #unknown
  }

type t = Finished(string, [#image | #video | #unknown]) | Progress(float) | Error
