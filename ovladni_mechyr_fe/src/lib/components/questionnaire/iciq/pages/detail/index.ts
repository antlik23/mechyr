import Root from './root.svelte';

export function shouldContinueFromIciqForm(score: number) {
  return score >= 0;
}

export { Root as Detail };
