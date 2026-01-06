import Root from './root.svelte';

export function shouldContinueFromOabForm(score: number) {
  return score >= 8;
}

export { Root as Detail };
