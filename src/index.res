// Hot Module Replacement (HMR) - Remove this snippet to remove HMR.
// Learn more: https://www.snowpack.dev/#hot-module-replacement
@scope(("import", "meta")) @val external hot: bool = "hot"

@scope(("import", "meta", "hot")) @val
external accept: unit => unit = "accept"

%%raw(`import './tailwind.css';`)

ReactDOMRe.renderToElementWithId(
  <React.StrictMode>
    <div className="flex w-screen h-screen">
      <Auth> {authResult => <App user=authResult />} </Auth>
    </div>
  </React.StrictMode>,
  "root",
)

if hot {
  accept()
}
