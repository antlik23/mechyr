<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { SuperForm } from 'sveltekit-superforms';
  import type { Merge } from 'type-fest';
  import type { RadioGroupData } from '$lib/components/form/types';
  import {
    type FieldProps,
    FieldErrors,
    Control,
    Label as FormsnapLabel,
    Fieldset,
    Legend,
  } from 'formsnap';
  import { determineIsRequired, fieldErrorsVariants } from '$lib/components/form/index';
  import * as RadioGroup from '$lib/components/ui/radio-group';
  import { Label } from '$lib/components/ui/label';
  import { labelVariants } from '$lib/components/ui/label/label.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form/index';

  type $$Props = Merge<
    Merge<Partial<ComponentProps<RadioGroup.Item>>, FieldProps<T, U>>,
    {
      label?: string;
      data: RadioGroupData[];
      coerceTo?: 'string' | 'number' | 'boolean';
      showRequiredIndicator?: boolean;
    }
  >;

  export let form: SuperForm<T>;
  export let name: U;
  export let label: $$Props['label'] = undefined;
  export let data: $$Props['data'];
  export let coerceTo: $$Props['coerceTo'] = 'string';
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;

  $: ({ form: formData } = form);
  $: value = String($formData[name]);

  function handleChange(selectedValue: string) {
    $formData[name] = coerceValue(selectedValue) as T[U];
  }

  function coerceValue(selectedValue: Parameters<typeof handleChange>['0']) {
    switch (coerceTo) {
      case 'boolean':
        if (selectedValue === 'true') return true;
        if (selectedValue === 'false') return false;

        return selectedValue;
      case 'number':
        if (selectedValue !== '') return Number(selectedValue);

        return selectedValue;
      case 'string':
      case undefined:
        return String(selectedValue);
      default:
        // Assert unreachable.
        coerceTo satisfies never;
        break;
    }
  }
</script>

<Fieldset
  {name}
  class={columnsVariants({ number: 0, gap: 2, useSpacing: true, useGrid: false })}
  {form}
  let:constraints
  let:errors
>
  {@const shouldShowRequiredIndicator = showRequiredIndicator && determineIsRequired(constraints)}

  {#if label}
    <Legend class={labelVariants()}>
      <!-- eslint-disable-next-line svelte/no-at-html-tags -->
      {@html label}&nbsp;{#if shouldShowRequiredIndicator}<Form.RequiredIndicator />{/if}
    </Legend>
  {/if}

  <RadioGroup.Root onValueChange={handleChange} bind:value>
    {#each data as { value, label, disabled }}
      <Control let:attrs>
        <div class="flex items-center">
          <RadioGroup.Item {disabled} {value} {...attrs} {...$$restProps} />
          <RadioGroup.Input name={attrs.name} {value} />

          <FormsnapLabel asChild let:labelAttrs>
            <Label {...labelAttrs}>{label}</Label>
          </FormsnapLabel>
        </div>
      </Control>
    {/each}
  </RadioGroup.Root>

  {#if errors.length > 0}
    <FieldErrors class={fieldErrorsVariants()} />
  {/if}
</Fieldset>
