<script lang="ts">
  import type { HTMLInputAttributes } from 'svelte/elements';
  import { type ComponentProps } from 'svelte';

  import { cn } from '$lib/utils.js';

  import { Input } from '$lib/components/ui/input';
  import Icon from '$lib/components/wrappers/Icon.svelte';

  type $$Props = HTMLInputAttributes & {
    append?: string | ComponentProps<Icon>['icon'];
    prepend?: string | ComponentProps<Icon>['icon'];
  };

  export const getInputElement = () => {
    return document.getElementById($$restProps.id) as HTMLInputElement | null;
  };

  let className: $$Props['class'] = undefined;
  export { className as class };
  export let value: $$Props['value'] = undefined;
  export let append: $$Props['append'] = '';
  export let prepend: $$Props['prepend'] = '';
  export let disabled: $$Props['disabled'] = false;
</script>

<div
  class="relative flex items-center [&:has(input:focus-visible)_.append]:outline [&:has(input:focus-visible)_.append]:outline-1 [&:has(input:focus-visible)_.prepend]:outline [&:has(input:focus-visible)_.prepend]:outline-1"
>
  {#if prepend}
    {#if typeof prepend === 'string'}
      <div
        class={`${disabled ? 'text-gray-600 opacity-50' : ''} border-r-none prepend rounded-md rounded-r-none border border-r-0 border-slate-300 bg-background py-[calc(0.5rem-1px)] pl-4`}
      >
        <span class="pointer-events-none flex border-r-2 pr-2 text-base text-gray-600">
          {prepend}
        </span>
      </div>
    {:else}
      <Icon
        class="pointer-events-none absolute left-4 top-1/2 -translate-y-1/2 text-gray-600"
        icon={prepend}
      />
    {/if}
  {/if}

  <Input
    class={cn(
      `${append && typeof append === 'string' ? 'rounded-r-none border-r-0' : append && typeof append !== 'string' ? 'pr-12' : ''} ${prepend && typeof prepend === 'string' ? 'rounded-l-none border-l-0' : prepend && typeof prepend !== 'string' ? 'pl-12' : ''}`,
      className
    )}
    {disabled}
    {...$$restProps}
    bind:value
    on:blur
    on:change
    on:click
    on:focus
    on:focusin
    on:focusout
    on:keydown
    on:keypress
    on:keyup
    on:mouseover
    on:mouseenter
    on:mouseleave
    on:mousemove
    on:paste
    on:input
    on:wheel
  />

  {#if append}
    {#if typeof append === 'string'}
      <div
        class={`${disabled ? 'text-gray-600 opacity-50' : ''} border-l-none append rounded-md rounded-l-none border border-l-0 border-slate-300 bg-background py-[calc(0.5rem-1px)] pr-4`}
      >
        <span class="pointer-events-none flex border-l-2 pl-2 text-base text-gray-600">
          {append}
        </span>
      </div>
    {:else}
      <Icon
        class="pointer-events-none absolute right-4 top-1/2 -translate-y-1/2 text-gray-600"
        icon={append}
      />
    {/if}
  {/if}
</div>
