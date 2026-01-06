<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import type { SuperForm } from 'sveltekit-superforms';
  import Checkbox from '$lib/components/ui/checkbox/checkbox.svelte';
  import { Fieldset, type FieldProps, FieldErrors, Control, Label } from 'formsnap';

  type $$Props = FieldProps<T, U> & {
    options: { label: string; value: string }[];
    name: string;
    disabled?: boolean;
  };

  export let form: SuperForm<T>;
  export let name: U;
  export let options: $$Props['options'];
  export let disabled: $$Props['disabled'] = false;

  $: ({ form: formData } = form);
  $: checked = $formData[name]
    ? options.findIndex((option) => option.value === $formData[name])
    : null;

  function handleClick(v: number) {
    if (disabled) return;

    checked = checked === v ? null : v;
    $formData[name] = (checked !== null ? options[checked].value : null) as T[U];
  }
</script>

<Fieldset {name} {form} let:errors>
  <div class="flex flex-col gap-6">
    <input {name} hidden value={checked !== null ? options[checked].value : null} />

    {#each options as option, i}
      <Control let:attrs>
        <div class="flex items-center space-x-4">
          <Checkbox {...attrs} checked={checked === i} {disabled} on:click={() => handleClick(i)} />
          <Label class="label cursor-pointer select-none">
            {option.label}
            {attrs['aria-required'] ? '*' : ''}
          </Label>
        </div>
      </Control>
    {/each}

    {#if errors.length > 0}
      <FieldErrors class="text-sm text-destructive" />
    {/if}
  </div>
</Fieldset>
