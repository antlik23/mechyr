import type { ProgressBar } from '@prgm/sveltekit-progress-bar';
import { writable } from 'svelte/store';

export const progressBar = writable<ProgressBar | undefined>(undefined);
