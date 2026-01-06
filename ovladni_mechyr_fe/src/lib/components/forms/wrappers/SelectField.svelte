<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import type { SuperForm } from 'sveltekit-superforms';
  import type { Merge } from 'type-fest';
  import { createEventDispatcher, type ComponentEvents, type ComponentProps } from 'svelte';
  import { Field, type FieldProps, FieldErrors, Control, Label as FormsnapLabel } from 'formsnap';
  import { determineIsRequired, fieldErrorsVariants } from '$lib/components/form/index';
  import Select from '$lib/components/forms/fields/Select.svelte';
  import { Label } from '$lib/components/ui/label';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form/index';

  type $$Props = Merge<
    Merge<ComponentProps<Select>, FieldProps<T, U>>,
    {
      label?: string;
      showRequiredIndicator?: boolean;
      'data-testid'?: string;
    }
  >;

  export let form: SuperForm<T>;
  export let name: U;
  export let label: $$Props['label'] = undefined;
  export let multiple: $$Props['multiple'] = undefined;
  export let data: $$Props['data'];
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;

  const dispatch = createEventDispatcher<{
    select: ComponentEvents<Select>['select']['detail'];
  }>();

  $: ({ form: formData } = form);

  let selected: ComponentProps<Select>['selected'];
  $: selected = determineSelected($formData[name] as Parameters<typeof determineSelected>['0']);

  function handleSelect({ detail: { value } }: ComponentEvents<Select>['select']) {
    $formData[name] = value as T[U];

    dispatch('select', { value });
  }

  function determineSelected(
    selectedValue: $$Props['data'][number]['value'] | $$Props['data'][number]['value'][] | undefined
  ) {
    if (multiple) {
      if (!Array.isArray(selectedValue)) return;

      return selectedValue.map((selectedValue) => {
        return {
          value: selectedValue,
          label: data.find((dataItem) => dataItem.value === selectedValue)?.label,
        };
      });
    } else {
      if (Array.isArray(selectedValue)) return;

      return {
        value: selectedValue,
        label: data.find(
          (dataItem) => dataItem.value !== undefined && dataItem.value === selectedValue
        )?.label,
      };
    }
  }
</script>

<Field {name} {form} let:constraints let:errors>
  {@const shouldShowRequiredIndicator = showRequiredIndicator && determineIsRequired(constraints)}

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

      <Select {...attrs} {data} {multiple} {selected} {...$$restProps} on:select={handleSelect} />
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>
