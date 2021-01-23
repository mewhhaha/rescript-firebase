module.exports = {
  purge: {
    content: ['./src/**/*.res'],    
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      width: ['focus'],
      margin: ['first']
    },
  },
  plugins: [],
}
