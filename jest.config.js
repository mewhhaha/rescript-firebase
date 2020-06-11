module.exports = {
  ...{
    ...require('@snowpack/app-scripts-react/jest.config.js')(),
    // FIXME:
    // We've configured BuckleScript to generate JavaScript with ESM syntax (import/export),
    // This is not only for our .re, .rei files, but also built-in libraries and all dependencies.
    //
    // By default any .js files under node_modules won't be transformed in our Jest config, this will
    // cause an error like this:
    //
    //     Jest encountered an unexpected token
    //
    //     -- snip --
    //
    //     /<app_path>/node_modules/@glennsl/bs-jest/src/jest.js:3
    //     import * as List from "bs-platform/lib/es6/list.js";
    //            ^
    //
    //     SyntaxError: Unexpected token *
    //
    //       1 | // Generated by BUCKLESCRIPT, PLEASE EDIT WITH CARE
    //       2 |
    //     > 3 | import * as Jest from "@glennsl/bs-jest/src/jest.js";
    //         | ^
    //
    //     -- snip ---
    //
    // this is a workaround to enable babel to travel throught node_modules at the moment.
    transformIgnorePatterns: [],
  },
};
