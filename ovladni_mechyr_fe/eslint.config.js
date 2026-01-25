import js from '@eslint/js';
import ts from 'typescript-eslint';
import prettier from 'eslint-config-prettier';
import svelte from 'eslint-plugin-svelte';
import globals from 'globals';
import svelteParser from 'svelte-eslint-parser';
import tanstack from '@tanstack/eslint-plugin-query';

export default ts.config(
  js.configs.recommended,
  ...ts.configs.recommended,
  {
    rules: {
      'no-import-assign': 'off',
      'no-unused-vars': 'off',
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          varsIgnorePattern: '^(_|\\$\\$).*',
        },
      ],
    },
  },
  ...svelte.configs['flat/recommended'],
  {
    rules: {
      'svelte/block-lang': [
        'error',
        {
          script: 'ts',
        },
      ],
      'svelte/sort-attributes': ['warn'],
    },
  },
  {
    files: ['**/*.svelte'],
    languageOptions: {
      parser: svelteParser,
      parserOptions: {
        parser: ts.parser,
        extraFileExtensions: ['.svelte'],
      },
    },
  },
  ...tanstack.configs['flat/recommended'],
  prettier,
  ...svelte.configs['flat/prettier'],
  {
    languageOptions: {
      ecmaVersion: 2022,
      sourceType: 'module',
      globals: { ...globals.node, ...globals.browser },
    },
  },
  {
    ignores: [
      '**/build',
      '**/.svelte-kit',
      '**/node_modules',
      '**/playwright-report',
      '**/vscode',
      '**/wrangler',
      '**/.git',
      '**/.gitea',
      '**/docs',
      '**/test-results',
      '**/static',
      '**/project.inlang',
      '**/messages',
      '**/package',
      '**/.env',
      '**/.env.*',
      '!**/.env.example',
      '**/pnpm-lock.yaml',
      '**/messages.js',
      '**/src/paraglide',
    ],
  }
);
