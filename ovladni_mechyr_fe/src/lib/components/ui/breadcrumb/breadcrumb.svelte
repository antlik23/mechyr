<script lang="ts">
  import type { HTMLAttributes } from 'svelte/elements';

  type $$Props = HTMLAttributes<HTMLElement> & {
    el?: HTMLElement;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let el: $$Props['el'] = undefined;
</script>

<nav bind:this={el} class={className} aria-label="breadcrumb" {...$$restProps}>
  <slot />
</nav>
