let reAcceptedMedia = %re("/^((image)|(video))/")
let reAcceptedImage = %re("/^image/")
let reAcceptedVideo = %re("/^image/")

type t = Finished(string, [#image | #video]) | Progress(float) | Error
