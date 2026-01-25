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

  type $$Props = Merge<
    FieldProps<T, U>,
    {
      placeholder?: ComponentProps<Input>['placeholder'];
      label?: string;
      disabled?: ComponentProps<Input>['disabled'];
      prepend?: ComponentProps<Icon>['icon'];
      prependClasses?: ComponentProps<Icon>['class'];
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
  export let prepend: $$Props['prepend'] = undefined;
  export let prependClasses: $$Props['prependClasses'] = undefined;
  export let append: $$Props['append'] = ClockIcon;
  export let appendClasses: $$Props['appendClasses'] = 'size-4 [&_svg]:size-[inherit]';
  export let showRequiredIndicator: $$Props['showRequiredIndicator'] = true;
  export let popoverProps: $$Props['popoverProps'] = undefined;

  $: ({ form: formData } = form);

  $: value = $formData[name]
    ? getTimeValues($formData[name] as string)
    : { hour: undefined, minute: undefined };

  $: formattedValue = formatTime(value);
  $: formattedValueWithoutSeconds = formattedValue.slice(0, 5);

  function handleValueChange(event: ComponentEvents<Time>['valueChange']) {
    $formData[name] = formatTime(event.detail) as T[U];
  }

  function handleClearClick() {
    $formData[name] = '' as T[U];
  }

  function handleNowClick() {
    const now = new Date();
    $formData[name] = formatTime({ hour: getHours(now), minute: getMinutes(now) }) as T[U];
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

      <Popover.Root openFocus {...popoverProps}>
        <Popover.Trigger asChild let:builder>
          <Button
            {...attrs}
            class={cn('font-normal', !formattedValue && 'text-muted-foreground')}
            builders={[builder]}
            {disabled}
            variant="input"
          >
            {#if prepend}
              <Icon
                class={cn('-ml-[1px] mr-[1px] text-muted-foreground', prependClasses)}
                icon={prepend}
              />
            {/if}

            <span class="truncate">
              {#if formattedValueWithoutSeconds}
                {formattedValueWithoutSeconds}
              {:else if placeholder}
                {placeholder}
              {/if}
            </span>

            {#if append}
              <Icon class={cn('ml-auto text-muted-foreground', appendClasses)} icon={append} />
            {/if}
          </Button>
        </Popover.Trigger>
        <Popover.Content class="w-64 p-0">
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
