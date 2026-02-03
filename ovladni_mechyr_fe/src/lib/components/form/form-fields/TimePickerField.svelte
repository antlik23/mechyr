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
  import type { PopoverProps } from 'bits-ui';
  import { Field, type FieldProps, FieldErrors, Control, Label as FormsnapLabel } from 'formsnap';
  import { getHours, getMinutes } from 'date-fns';
  import { formatTime, getTimeValues } from '$lib/utils/dates';
  import { determineIsRequired, fieldErrorsVariants } from '../index';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { Button } from '$lib/components/ui/button';
  import { Label } from '$lib/components/ui/label';
  import Time from '$lib/components/time/Time.svelte';
  import * as Popover from '$lib/components/ui/popover';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Input from '$lib/components/forms/fields/Input.svelte';
  import RequiredIndicator from '../required-indicator.svelte';
  import Icon from '$lib/components/wrappers/Icon.svelte';
  import { ClockIcon } from 'lucide-svelte';

  let open = false;
  let inputElement: HTMLInputElement;

  type $$Props = Merge<
    FieldProps<T, U>,
    {
      placeholder?: ComponentProps<Input>['placeholder'];
      label?: string;
      disabled?: ComponentProps<Input>['disabled'];
      append?: ComponentProps<Icon>['icon'];
      appendClasses?: ComponentProps<Icon>['class'];
      showRequiredIndicator?: boolean;
      popoverProps?: PopoverProps;
    }
  >;

  export let form: SuperForm<T>;
  export let name: U;
  export let placeholder: $$Props['placeholder'] = undefined;
  export let label: $$Props['label'] = undefined;
  export let disabled: $$Props['disabled'] = undefined;
  export let append: $$Props['append'] = ClockIcon;
  export let appendClasses: $$Props['appendClasses'] = 'size-4 [&_svg]:size-[inherit]';
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;
  export let popoverProps: $$Props['popoverProps'] = { portal: 'body' };

  $: ({ form: formData } = form);

  $: value = $formData[name]
    ? getTimeValues($formData[name] as string)
    : { hour: undefined, minute: undefined };

  $: formattedValue = formatTime(value);
  $: formattedValueWithoutSeconds = formattedValue.slice(0, 5);

  // Display value: show --:-- when empty, otherwise formatted time
  $: displayValue = formattedValueWithoutSeconds || '--:--';

  function handleValueChange(event: ComponentEvents<Time>['valueChange']) {
    $formData[name] = formatTime(event.detail) as T[U];
    open = false; // Close popover after selection
  }

  function handleClearClick() {
    $formData[name] = '' as T[U];
    open = false;
  }

  function handleNowClick() {
    const now = new Date();
    $formData[name] = formatTime({ hour: getHours(now), minute: getMinutes(now) }) as T[U];
    open = false;
  }

  function handleInputFocus() {
    // Select all text when focusing
    if (inputElement) {
      // Set cursor at start if showing placeholder
      if (displayValue === '--:--') {
        setTimeout(() => {
          inputElement.setSelectionRange(0, 0);
        }, 0);
      } else {
        setTimeout(() => {
          inputElement.select();
        }, 0);
      }
    }
  }

  function handleKeyDown(event: KeyboardEvent) {
    const target = event.target as HTMLInputElement;
    const currentValue = target.value;

    // Allow navigation keys
    if (['ArrowLeft', 'ArrowRight', 'Home', 'End', 'Tab'].includes(event.key)) {
      return;
    }

    // Allow delete/backspace
    if (['Backspace', 'Delete'].includes(event.key)) {
      event.preventDefault();
      const newValue = '--:--';
      target.value = newValue;
      $formData[name] = '' as T[U];
      setTimeout(() => target.setSelectionRange(0, 0), 0);
      return;
    }

    // Only allow numbers
    if (!/^\d$/.test(event.key)) {
      event.preventDefault();
      return;
    }

    event.preventDefault();

    const digit = event.key;
    let newValue = currentValue === '--:--' ? '__:__' : currentValue.replace(/-/g, '_');
    const parts = newValue.split(':');
    let hours = parts[0];
    let minutes = parts[1];

    // Determine where to place the digit
    if (hours.includes('_')) {
      const firstUnderscore = hours.indexOf('_');
      hours = hours.substring(0, firstUnderscore) + digit + hours.substring(firstUnderscore + 1);

      // Validate hours
      const hoursNum = parseInt(hours.replace(/_/g, '0'));
      if (hoursNum > 23) {
        hours = '2_';
      }
    } else if (minutes.includes('_')) {
      const firstUnderscore = minutes.indexOf('_');
      minutes =
        minutes.substring(0, firstUnderscore) + digit + minutes.substring(firstUnderscore + 1);

      // Validate minutes
      const minutesNum = parseInt(minutes.replace(/_/g, '0'));
      if (minutesNum > 59) {
        minutes = '5_';
      }
    }

    newValue = `${hours}:${minutes}`;
    target.value = newValue.replace(/_/g, '-');

    // If complete, save value
    if (!newValue.includes('_')) {
      const [h, m] = newValue.split(':').map(Number);
      $formData[name] = formatTime({ hour: h, minute: m }) as T[U];
    }
  }

  function handleInputClick() {
    if (open) {
      open = false;
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

      <Popover.Root closeOnOutsideClick={true} openFocus={false} bind:open {...popoverProps}>
        <div class="relative">
          <input
            bind:this={inputElement}
            {...attrs}
            class={cn(
              'flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm font-normal ring-offset-background transition-colors',
              'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2',
              'disabled:cursor-not-allowed disabled:opacity-50',
              'placeholder:text-muted-foreground',
              displayValue === '--:--' && 'text-muted-foreground'
            )}
            {disabled}
            {placeholder}
            readonly={open}
            type="text"
            value={displayValue}
            on:focus={handleInputFocus}
            on:click={handleInputClick}
            on:keydown={handleKeyDown}
          />
          <Popover.Trigger asChild let:builder>
            <Button
              class="absolute right-0 top-0 h-10 w-10"
              builders={[builder]}
              {disabled}
              size="icon"
              tabindex={-1}
              variant="ghost"
              on:mousedown={(e) => e.preventDefault()}
            >
              {#if append}
                <Icon class={cn('text-muted-foreground', appendClasses)} icon={append} />
              {/if}
            </Button>
          </Popover.Trigger>
        </div>
        <Popover.Content class="z-[9999] w-64 p-0">
          <Time
            hourValue={value.hour}
            minuteValue={value.minute}
            on:valueChange={handleValueChange}
          >
            <div slot="append" class={columnsVariants({ number: 2, gap: 4 })}>
              <Button variant="outline" on:click={handleClearClick}>{m.clear()}</Button>
              <Button on:click={handleNowClick}>{m.now()}</Button>
            </div>
          </Time>
        </Popover.Content>
      </Popover.Root>

      <input {name} type="hidden" value={formattedValue} />
    </Control>

    {#if errors.length > 0}
      <FieldErrors class={fieldErrorsVariants()} />
    {/if}
  </div>
</Field>
