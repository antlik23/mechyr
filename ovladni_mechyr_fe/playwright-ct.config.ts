import { defineConfig, devices } from '@playwright/experimental-ct-svelte';
import { svelte, vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import path from 'path';

/**
 * See https://playwright.dev/docs/test-configuration.
 */
const viewport = { width: 800, height: 600 };
export default defineConfig({
  testDir: './tests/components',
  /* The base directory, relative to the config file, for snapshot files created with toMatchSnapshot and toHaveScreenshot. */
  snapshotDir: './__snapshots__/components',

  snapshotPathTemplate: '{snapshotDir}/{testFilePath}/{arg}-{projectName}{ext}',

  /* Maximum time one test can run for. */
  timeout: 10 * 1000,
  /* Run tests in files in parallel */
  fullyParallel: true,
  /* Fail the build on CI if you accidentally left test.only in the source code. */
  forbidOnly: !!process.env.CI,
  /* Retry on CI only */
  retries: process.env.CI ? 2 : 0,
  /* Limit the number of workers on CI, use default locally */
  workers: process.env.CI ? 3 : undefined,
  /* Reporter to use. See https://playwright.dev/docs/test-reporters */
  reporter: 'html',
  /* Shared settings for all the projects below. See https://playwright.dev/docs/api/class-testoptions. */
  use: {
    /* Collect trace when retrying the failed test. See https://playwright.dev/docs/trace-viewer */
    trace: 'on-first-retry',

    /* Port to use for Playwright component endpoint. */
    ctPort: 3100,

    ctViteConfig: {
      plugins: [
        svelte({
          preprocess: vitePreprocess(),
          extensions: ['.svelte', '.svg'],
        }),
      ],
      resolve: {
        alias: {
          $lib: path.resolve('./src/lib/'),
          '$paraglide/messages': './src/paraglide/messages.js',
          '$paraglide/messages.js': './src/paraglide/messages.js',
        },
      },
    },
  },

  /* Configure projects for major browsers */
  projects: [
    {
      name: 'chromium',
      use: {
        ...devices['Desktop Chrome'],
        viewport,
      },
    },
    {
      name: 'firefox',
      use: {
        ...devices['Desktop Firefox'],
        viewport,
      },
    },
    {
      name: 'webkit',
      use: {
        ...devices['Desktop Safari'],
        viewport,
      },
    },
  ],
});
