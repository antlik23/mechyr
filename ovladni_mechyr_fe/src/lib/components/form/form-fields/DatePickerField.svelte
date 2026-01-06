<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import type { ComponentEvents, ComponentProps } from 'svelte';
  import type { SuperForm } from 'sveltekit-superforms';
  import type { Merge } from 'type-fest';
  import { parseDate } from '@internationalized/date';
  import { determineIsRequired, fieldErrorsVariants } from '../index';
  import { Field, type FieldProps, FieldErrors, Control, Label as FormsnapLabel } from 'formsnap';
  import DatePicker from '../fields/DatePicker.svelte';
  import { Label } from '$lib/components/ui/label';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import RequiredIndicator from '../required-indicator.svelte';

  type $$Props = Merge<
    Merge<ComponentProps<DatePicker>, FieldProps<T, U>>,
    {
      label?: string;
      showRequiredIndicator?: boolean;
      'data-testid'?: string;
    }
  >;

  export let form: SuperForm<T>;
  export let name: U;
  export let label: $$Props['label'] = undefined;
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;

  $: ({ form: formData } = form);

  let value: ComponentProps<DatePicker>['value'];
  $: value = $formData[name] ? parseDate($formData[name] as string) : undefined;

  function handleDateSelect({ detail: { date } }: ComponentEvents<DatePicker>['select']) {
    $formData[name] = (date ?? '') as T[U];
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
            {@html label}&nbsp;{#if shouldShowRequiredIndicator}<RequiredIndicator />{/if}
          </Label>
        </FormsnapLabel>
      {/if}

      <DatePicker
        {...attrs}
        appendClasses="size-4 [&_svg]:size-[inherit]"
        {value}
        {...$$restProps}
        on:select={handleDateSelect}
      />

      <input {name} type="hidden" {value} />
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>
