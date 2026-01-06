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
  import { Field, type FieldProps, FieldErrors, Control, Label as FormsnapLabel } from 'formsnap';
  import { determineIsRequired, fieldErrorsVariants } from '$lib/components/form/index';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Input from '$lib/components/forms/fields/Input.svelte';
  import { Label } from '$lib/components/ui/label';
  import { Checkbox } from '$lib/components/ui/checkbox';
  import * as Form from '$lib/components/form';

  type $$Props = Merge<
    Merge<ComponentProps<Input>, FieldProps<T, U>>,
    {
      label?: string;
      showRequiredIndicator?: boolean;
      allowConstraints?: boolean;
    }
  >;

  export const getInputElement = () => inputRef?.getInputElement();

  export let form: SuperForm<T>;
  export let name: U;
  export let type: $$Props['type'] = undefined;
  export let label: $$Props['label'] = undefined;
  export let disabled: $$Props['disabled'] = undefined;
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;
  export let allowConstraints: $$Props['allowConstraints'] = false;

  let inputRef: Input | undefined;

  $: ({ form: formData } = form);

  $: {
    const value = $formData[name];
    if (type === 'number' && typeof value === 'string' && value !== '') {
      $formData[name] = Number(value) as T[U];
    }
  }

  let checked: ComponentProps<Checkbox>['checked'];
  $: if (type === 'checkbox') {
    checked = Boolean($formData[name]);
  }

  function handleCheckboxClick() {
    $formData[name] = !checked as T[U];
  }
</script>

<Field {name} {form} let:constraints let:errors>
  {@const shouldShowRequiredIndicator = showRequiredIndicator && determineIsRequired(constraints)}
  {@const optionalConstraints = allowConstraints ? constraints : undefined}

  <div class={columnsVariants({ number: 0, gap: 2 })}>
    <Control let:attrs>
      {#if type === 'checkbox'}
        <div class="flex items-center">
          <Checkbox
            {...attrs}
            {checked}
            {...optionalConstraints}
            disabled={Boolean(disabled)}
            on:click={handleCheckboxClick}
          />
          <input name={attrs.name} hidden value={checked} />

          {#if label}
            <FormsnapLabel asChild let:labelAttrs>
              <Label {...labelAttrs}>
                <!-- eslint-disable-next-line svelte/no-at-html-tags -->
                {@html label}&nbsp;{#if shouldShowRequiredIndicator}<Form.RequiredIndicator />{/if}
              </Label>
            </FormsnapLabel>
          {/if}
        </div>
      {:else}
        {#if label}
          <FormsnapLabel asChild let:labelAttrs>
            <Label {...labelAttrs}>
              <!-- eslint-disable-next-line svelte/no-at-html-tags -->
              {@html label}&nbsp;{#if shouldShowRequiredIndicator}<Form.RequiredIndicator />{/if}
            </Label>
          </FormsnapLabel>
        {/if}

        <Input
          bind:this={inputRef}
          {...attrs}
          {disabled}
          {type}
          {...optionalConstraints}
          {...$$restProps}
          min={0}
          bind:value={$formData[name]}
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
      {/if}
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>
