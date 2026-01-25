import Root from './root.svelte';

export function shouldContinueFromIpssForm(score: number) {
  return score < 8;
}

export { Root as Detail };
