/// <reference types="vitest" />
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import svg from '@poppanator/sveltekit-svg';
import { kitRoutes } from 'vite-plugin-kit-routes';
import { paraglide } from '@inlang/paraglide-sveltekit/vite';

export default defineConfig({
  test: {
    include: ['./tests/unit/**'],
  },
  plugins: [
    paraglide({
      project: './project.inlang',
      outdir: './src/paraglide',
    }),
    sveltekit(),
    kitRoutes({
      post_update_run:
        'npm exec prettier ./src/lib/ROUTES.ts -- -w && node ./ignore-routes-ts-error.js',
    }),
    svg({
      includePaths: ['./src/lib/assets/icons/'],
      svgoOptions: {
        multipass: true,
        plugins: [
          {
            name: 'preset-default',
            // by default svgo removes the viewBox which prevents svg icons from scaling
            // not a good idea! https://github.com/svg/svgo/pull/1461
            params: { overrides: { removeViewBox: false } },
          },
          {
            name: 'addAttributesToSVGElement',
            // Add by default aria-hidden="true" to all svgs, since they are almost always decorative.
            params: {
              attribute: { 'aria-hidden': 'true' },
            },
          },
        ],
      },
    }),
  ],
});
