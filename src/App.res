@react.component
let make = (~user: Firebase.Auth.user) => {
  <div
    className="flex fixed justify-center w-full inset-y-0 xl:inset-y-4 xl:max-w-6xl xl:border border-gray-600">
    <div className="flex flex-col w-full max-w-sm h-full bg-gray-900 border-r border-gray-600">
      <TitleStripe />
    </div>
    <Messenger user />
  </div>
}
