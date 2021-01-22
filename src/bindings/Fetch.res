type request
type response
@new external makeXMLHttpRequest: unit => request = "XMLHttpRequest"
@send external addEventListener: (request, string, unit => unit) => unit = "addEventListener"
@get external getResponse: request => response = "response"
@get external getStatus: request => int = "status"
@send external open_: (request, string, string) => unit = "open"
@send external send: request => unit = "send"
@send external abort: request => unit = "abort"

type statusSuccess = OK(response) | NoContent | OtherSuccess
type statusError = BadRequest | Unauthorized | OtherError

type requestState =
  | Loading
  | Error(statusError)
  | Loaded(statusSuccess)

let parseStatusSuccess = request =>
  switch request->getStatus {
  | 200 => OK(request->getResponse)
  | 204 => NoContent
  | _ => OtherSuccess
  }

let parseStatusError = request =>
  switch request->getStatus {
  | 400 => BadRequest
  | 401 => Unauthorized
  | _ => OtherError
  }

let get = (url, handler) => {
  handler(Loading)
  let request = makeXMLHttpRequest()
  request->addEventListener("load", () => {
    handler(Loaded(parseStatusSuccess(request)))
  })
  request->addEventListener("error", () => {
    handler(Error(parseStatusError(request)))
  })
  request->open_("GET", url)
  request->send

  () => {
    request->abort
  }
}
