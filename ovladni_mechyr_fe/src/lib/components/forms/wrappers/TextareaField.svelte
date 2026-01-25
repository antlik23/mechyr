<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';
  import { determineIsRequired, fieldErrorsVariants } from '$lib/components/form';
  import Textarea from '$lib/components/forms/fields/Textarea.svelte';
  import { Label } from '$lib/components/ui/label';
  import { Control, Field, FieldErrors, Label as FormsnapLabel, type FieldProps } from 'formsnap';
  import type { ComponentProps } from 'svelte';
  import type { SuperForm } from 'sveltekit-superforms';
  import type { Merge } from 'type-fest';

  type $$Props = Merge<
    Merge<ComponentProps<Textarea>, FieldProps<T, U>>,
    {
      label?: string;
      description?: string;
      showRequiredIndicator?: boolean;
      allowConstraints?: boolean;
    }
  >;

  export let form: SuperForm<T>;
  export let name: U;
  export let label: $$Props['label'] = undefined;
  export let description: $$Props['description'] = undefined;
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;
  export let allowConstraints: $$Props['allowConstraints'] = false;

  $: ({ form: formData } = form);
</script>

<Field {name} {form} let:constraints let:errors>
  {@const shouldShowRequiredIndicator = showRequiredIndicator && determineIsRequired(constraints)}
  {@const optionalConstraints = allowConstraints ? constraints : undefined}

  <div class={columnsVariants({ number: 0, gap: 2 })}>
    <Control let:attrs>
      {#if label}
        <FormsnapLabel asChild let:labelAttrs>
          <Label {...labelAttrs}>
            <!-- eslint-disable-next-line svelte/no-at-html-tags -->
            {@html label}&nbsp;{#if shouldShowRequiredIndicator}<Form.RequiredIndicator />{/if}
          </Label>
        </FormsnapLabel>
      {/if}

      {#if description}
        <!-- eslint-disable-next-line svelte/no-at-html-tags -->
        <p class="text-sm text-gray-600">{@html description}</p>
      {/if}
      <Textarea
        {...attrs}
        {...optionalConstraints}
        {...$$restProps}
        bind:value={$formData[name]}
        on:blur
        on:change
        on:click
        on:focus
        on:keydown
        on:keypress
        on:keyup
        on:mouseover
        on:mouseenter
        on:mouseleave
        on:paste
        on:input
      />
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>
