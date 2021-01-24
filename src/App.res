@react.component
let make = (~user: Firebase.Auth.user) => {
  <div
    className="flex fixed justify-center w-full inset-y-0 xl:inset-y-4 xl:max-w-4xl xl:border border-gray-600 ">
    <Messenger user />
  </div>
}
