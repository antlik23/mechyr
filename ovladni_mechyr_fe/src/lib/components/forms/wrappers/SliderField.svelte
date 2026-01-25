<script context="module" lang="ts">
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import type { SuperForm } from 'sveltekit-superforms';
  import type { Merge } from 'type-fest';
  import { type ComponentProps } from 'svelte';
  import { Slider as SliderPrimitive } from 'bits-ui';
  import { Field, type FieldProps, FieldErrors, Control, Label as FormsnapLabel } from 'formsnap';
  import { determineIsRequired, fieldErrorsVariants } from '$lib/components/form/index';
  import { Slider } from '$lib/components/ui/slider';
  import { Label } from '$lib/components/ui/label';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form/index';

  type $$Props = Merge<
    Merge<ComponentProps<Slider>, FieldProps<T, U>>,
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

  $: value = [$formData[name]] as ComponentProps<Slider>['value'];

  function handleValueChange(
    value: Parameters<NonNullable<ComponentProps<Slider>['onValueChange']>>['0']
  ) {
    // TODO: handle multiple slider thumbs.
    $formData[name] = value[0] as T[U];
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

      <Slider {...attrs} {value} {...$$restProps} onValueChange={handleValueChange}>
        <svelte:fragment slot="append">
          <SliderPrimitive.Input {name} />
        </svelte:fragment>
      </Slider>
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>
