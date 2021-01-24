let reAcceptedMedia = %re("/^((image)|(video))/")
let reAcceptedImage = %re("/^image/")
let reAcceptedVideo = %re("/^image/")

let fileCategory = t =>
  if reAcceptedImage->Js.Re.test_(t) {
    #image
  } else {
    #video
  }

type t = Finished(string, [#image | #video]) | Progress(float) | Error
