/** @type {import('tailwindcss').Config} */
const config = {
  darkMode: ['class'],
  content: ['./src/**/*.{html,js,svelte,ts}'],
  safelist: ['dark'],
  theme: {
    fontFamily: {
      sans: ['Noto Sans Variable', 'sans-serif'],
    },
    container: {
      center: true,
      padding: '2rem',
      screens: {
        '2xl': '1400px',
      },
    },
    extend: {
      colors: {
        border: 'hsl(var(--border) / <alpha-value>)',
        input: 'hsl(var(--input) / <alpha-value>)',
        ring: 'hsl(var(--ring) / <alpha-value>)',
        background: 'hsl(var(--background) / <alpha-value>)',
        foreground: 'hsl(var(--foreground) / <alpha-value>)',
        primary: {
          DEFAULT: 'hsl(var(--primary) / <alpha-value>)',
          foreground: 'hsl(var(--primary-foreground) / <alpha-value>)',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary) / <alpha-value>)',
          foreground: 'hsl(var(--secondary-foreground) / <alpha-value>)',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive) / <alpha-value>)',
          foreground: 'hsl(var(--destructive-foreground) / <alpha-value>)',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted) / <alpha-value>)',
          foreground: 'hsl(var(--muted-foreground) / <alpha-value>)',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent) / <alpha-value>)',
          foreground: 'hsl(var(--accent-foreground) / <alpha-value>)',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover) / <alpha-value>)',
          foreground: 'hsl(var(--popover-foreground) / <alpha-value>)',
        },
        card: {
          DEFAULT: 'hsl(var(--card) / <alpha-value>)',
          foreground: 'hsl(var(--card-foreground) / <alpha-value>)',
        },
        'blue-dark': {
          50: '#edf2ff',
          100: '#dfe6ff',
          200: '#c5d2ff',
          300: '#a2b3ff',
          400: '#7d8afc',
          500: '#5e63f6',
          600: '#4840eb',
          700: '#3c33cf',
          800: '#122ca7',
          900: '#2b297e',
          950: '#1b194d',
        },
        'blue-light': {
          50: '#f3f8fa',
          100: '#e9f1f9',
          200: '#d6e4fe',
          300: '#bdd2e4',
          400: '#a2bbd7',
          500: '#90a9cd',
          600: '#7288d9',
          700: '#6175a1',
          800: '#506083',
          900: '#45526a',
          950: '#282e3e',
        },
        grays: {
          50: '#f6f6f6',
          100: '#e7e7e7',
          200: '#d1d1d1',
          300: '#b0b0b0',
          400: '#888888',
          500: '#6d6d6d',
          600: '#5d5d5d',
          700: '#4f4f4f',
          800: '#454545',
          900: '#3d3d3d',
          white: '#ffffff',
          black: '#0c0c0c',
        },
        negative: {
          50: '#fef2f2',
          100: '#fee2e2',
          200: '#fee2e2',
          300: '#fca5a5',
          400: '#f87171',
          500: '#ef4444',
          600: '#dc2626',
          700: '#b91c1c',
          800: '#991b1b',
          900: '#7f1d1d',
          950: '#450a0a',
        },
        'green-dark': '#009511',
        'red-dark': '#FF3620',
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      lineHeight: {
        3.5: '0.875rem',
      },
      boxShadow: {
        100: '0px 4px 16px 0px rgb(0 0 0 / 16%)',
      },
    },
  },
};

export default config;
