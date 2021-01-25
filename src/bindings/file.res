type t
type fileReader

module Id = {
  @unboxed
  type t = Uuid(string)

  let make = () => Uuid(Uuid.V4.make())
}

@get external type_: t => string = "type"
@get external name: t => string = "name"

module Reader = {
  @new external make: unit => fileReader = "FileReader"
  @send external on: (fileReader, [#load], unit => unit, bool) => unit = "addEventListener"
  @get external result: fileReader => option<string> = "result"
  @send external readAsDataURL: (fileReader, t) => unit = "readAsDataURL"
}
