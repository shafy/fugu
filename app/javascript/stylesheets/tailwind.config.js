module.exports = {
  purge: {
    content: [
      "./app/**/*.html.erb",
      "./app/helpers/**/*.rb",
      "./app/javascript/**/*.js",
    ],
    options: {
      safelist: [
        "type",
      ]
    }
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
