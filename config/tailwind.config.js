const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        'manrope': ['"Manrope"', 'sans-serif'],
        'nimbus': ['"nimbus-sans"', 'sans-serif'],
        'nimbus-ext': ['"nimbus-sans-extended"', 'sans-serif']
      },
      colors: {
        night: '#0f172a',
        night_light: '#111a4a',
        night_dark: '#1B2439',
        jaguar: '#292a31',
        jaguar_light: '#4a4c57',
        mayo: '#fdfe7d',
        concrete: '#f3f3f0',
        ciel: '#91dbbe',
        pinky: '#f472b6',
        apricot: '#f19288',
        ocra:'#e8d1da',
        sazerac:'#f5dcc5',
        silver: '#87889a',
        steel: '#242533',
        primary_blue: '#2563eb',
        black_coral:'#585C6F',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
