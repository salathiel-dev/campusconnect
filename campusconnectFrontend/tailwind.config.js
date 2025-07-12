/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './App.{js,jsx,ts,tsx}',
    './src/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        'ufr-blue': '#193866',
        'interactive-blue': '#3A86FF',
        'highlight-yellow': '#FFBE0B',
        'soft-blue': '#E0EFFF',
        'light-gray': '#F0F2F5',
        'dark-gray': '#2D3748',
        'medium-gray': '#A0AEC0',
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
        display: ['Montserrat', 'sans-serif'],
      },
    },
  },
  plugins: [],
};