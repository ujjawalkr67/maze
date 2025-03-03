module.exports = {
    content : [
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/views/**/*',
        './app/assets/stylesheets/**/*.css'
    ],
    theme: {
        extend: {
            fontFamily: {
                sans: ['Poppins', 'sans-serif'],
                jakarta: ['Plus Jakarta Sans', 'sans-serif'],
              },
        },
    },
    plugins: [],
}