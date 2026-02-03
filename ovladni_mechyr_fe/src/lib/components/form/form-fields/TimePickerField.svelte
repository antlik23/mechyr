<script context="module" lang="ts">
  import type { FormPath } from 'sveltekit-superforms';

  type T = Record<string, unknown>;
  type U = unknown;
</script>

<script generics="T extends Record<string, unknown>, U extends FormPath<T>" lang="ts">
  import type { SuperForm } from 'sveltekit-superforms';
  import type { Merge } from 'type-fest';
  import { Field, type FieldProps, FieldErrors, Control, Label as FormsnapLabel } from 'formsnap';
  import { formatTime } from '$lib/utils/dates';
  import { determineIsRequired, fieldErrorsVariants } from '../index';
  import { Label } from '$lib/components/ui/label';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import RequiredIndicator from '../required-indicator.svelte';
  import { ClockIcon } from 'lucide-svelte';
  import { cn } from '$lib/utils';

  type $$Props = Merge<
    FieldProps<T, U>,
    {
      label?: string;
      disabled?: boolean;
      showRequiredIndicator?: boolean;
      class?: string;
    }
  >;

  export let form: SuperForm<T>;
  export let name: U;
  export let label: $$Props['label'] = undefined;
  export let disabled: $$Props['disabled'] = undefined;
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;
  let className: $$Props['class'] = undefined;
  export { className as class };

  $: ({ form: formData } = form);

  let inputElement: HTMLInputElement;

  // Convert stored value (HH:MM:SS) to display value (HH:MM)
  $: timeValue = $formData[name]
    ? ($formData[name] as string).slice(0, 5)
    : '';

  // Handle time change from native time input
  function handleTimeChange(event: Event) {
    const target = event.target as HTMLInputElement;
    const time = target.value;
    
    if (time && time.length === 5) {
      // Parse HH:MM and convert to HH:MM:SS format
      const [hours, minutes] = time.split(':').map(Number);
      $formData[name] = formatTime({ hour: hours, minute: minutes }) as T[U];
    } else {
      $formData[name] = '' as T[U];
    }
  }

  // Open time picker when icon is clicked
  function handleIconClick() {
    if (!disabled && inputElement) {
      inputElement.showPicker?.();
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
            {@html label}&nbsp;{#if shouldShowRequiredIndicator}<RequiredIndicator />{/if}
          </Label>
        </FormsnapLabel>
      {/if}

      <div class="relative">
        <input
          bind:this={inputElement}
          {...attrs}
          type="time"
          value={timeValue}
          on:change={handleTimeChange}
          disabled={disabled}
          class={cn(
            'time-input',
            'flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background',
            'file:border-0 file:bg-transparent file:text-sm file:font-medium',
            'placeholder:text-muted-foreground',
            'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
            'disabled:cursor-not-allowed disabled:opacity-50',
            'pr-10', // Extra padding on right for icon
            className
          )}
        />
        <button
          type="button"
          on:click={handleIconClick}
          disabled={disabled}
          class="absolute right-0 top-0 flex h-10 w-10 items-center justify-center disabled:cursor-not-allowed disabled:opacity-50"
          tabindex="-1"
        >
          <ClockIcon class="h-4 w-4 text-muted-foreground" />
        </button>
      </div>
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>

<style>
  /* Hide native time picker icon in Chrome, Safari, Edge */
  :global(.time-input::-webkit-calendar-picker-indicator) {
    display: none;
    -webkit-appearance: none;
  }

  /* Hide native time picker icon in Firefox */
  :global(.time-input::-moz-calendar-picker-indicator) {
    display: none;
  }

  /* Remove default clear button */
  :global(.time-input::-webkit-clear-button) {
    display: none;
    -webkit-appearance: none;
  }
</style>
