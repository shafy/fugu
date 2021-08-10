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
    extend: {
      fontFamily: {
        'system': ['-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen-Sans, Ubuntu, Cantarell, "Helvetica Neue", sans-serif']
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
