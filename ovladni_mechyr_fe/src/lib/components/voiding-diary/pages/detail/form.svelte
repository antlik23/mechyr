<script lang="ts">
  import { goto } from '$app/navigation';
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import * as Form from '$lib/components/form';
  import DatePickerField from '$lib/components/form/form-fields/DatePickerField.svelte';
  import TimePickerField from '$lib/components/form/form-fields/TimePickerField.svelte';
  import SelectField from '$lib/components/forms/wrappers/SelectField.svelte';
  import * as Card from '$lib/components/ui/card';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { formatTime, getTimeValues } from '$lib/utils/dates';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { addDays } from 'date-fns';
  import { onMount } from 'svelte';
  import { writable } from 'svelte/store';
  import { slide } from 'svelte/transition';
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { assert, type Equals } from 'tsafe';
  import { voidingDiaryFormSchema, type VoidingDiaryFormSchemaTypes } from './form-schema';
  import type { VoidingDiary } from './types';

  export let initialData: {
    voidingDiary?: VoidingDiary;
    patientId?: number;
  } = {};
  export let context: 'read' | 'new' | 'edit' = 'new';
  export let userContext: 'doctor' | 'patient';
  export let allowTaintAlert = context === 'new';

  const defaultFormData = prepareSuperFormDefaultFormData<VoidingDiaryFormSchemaTypes>({
    diary_start_date: initialData.voidingDiary?.diary_start_date,
    diary_duration_days: initialData.voidingDiary?.diary_duration_days ?? DEFAULT_STRING_VALUE,
    bedtime_day_one: initialData.voidingDiary?.bedtime_day_one
      ? formatTime(getTimeValues(initialData.voidingDiary.bedtime_day_one))
      : undefined,
    wake_up_time_day_one: initialData.voidingDiary?.wake_up_time_day_one
      ? formatTime(getTimeValues(initialData.voidingDiary.wake_up_time_day_one))
      : undefined,
    bedtime_day_two: initialData.voidingDiary?.bedtime_day_two
      ? formatTime(getTimeValues(initialData.voidingDiary.bedtime_day_two))
      : undefined,
    wake_up_time_day_two: initialData.voidingDiary?.wake_up_time_day_two
      ? formatTime(getTimeValues(initialData.voidingDiary.wake_up_time_day_two))
      : undefined,
    completed: initialData.voidingDiary?.completed,
  });

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(voidingDiaryFormSchema)), {
    SPA: true,
    validators: zodClient(voidingDiaryFormSchema),
    taintedMessage: allowTaintAlert ? () => taintedFormAlertDialogRef.taintedMessage() : undefined,
    async onUpdate({ form, cancel }) {
      if (!form.valid || context === 'read') return;

      const toastSuccessText = writable('');

      await handleRequest(
        async () => {
          let diaryId = initialData.voidingDiary?.id;

          switch (context) {
            case 'new': {
              const { data } = await apiClient.POST('/api/v1/voiding_diaries', {
                body: {
                  voiding_diary: {
                    ...form.data,
                    bedtime_day_two:
                      form.data.diary_duration_days >= 2 ? form.data.bedtime_day_two : undefined,
                    wake_up_time_day_two:
                      form.data.diary_duration_days >= 2
                        ? form.data.wake_up_time_day_two
                        : undefined,
                    user_id: initialData.patientId,
                  },
                },
              });

              diaryId = data?.voiding_diary.id;
              toastSuccessText.set(m.successfulVoidingDiaryCreate());
              break;
            }
            case 'edit': {
              assert(diaryId, 'Available diary ID');

              await apiClient.PUT('/api/v1/voiding_diaries/{id}', {
                params: { path: { id: diaryId } },
                body: {
                  voiding_diary: {
                    ...form.data,
                    bedtime_day_two:
                      form.data.diary_duration_days >= 2 ? form.data.bedtime_day_two : undefined,
                    wake_up_time_day_two:
                      form.data.diary_duration_days >= 2
                        ? form.data.wake_up_time_day_two
                        : undefined,
                  },
                },
              });

              toastSuccessText.set(m.successfulVoidingDiaryEdit());
              break;
            }
            default:
              assert<Equals<typeof context, never>>();
          }

          queryClient.invalidateQueries();

          assert(diaryId, 'Available diary ID');

          if (userContext === 'patient') {
            await goto(localizeRoute(route('/voiding-diary/list/[diaryId]/records', { diaryId })));
          } else {
            assert(initialData.patientId, 'Available Patient ID');

            await goto(
              localizeRoute(
                route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records', {
                  patientId: initialData.patientId,
                  diaryId,
                })
              )
            );
          }
        },
        {
          onError: cancel,
          toastSuccessText,
        }
      );
    },
  });

  const { enhance, form: formData } = form;

  let lastDiaryDurationDays: VoidingDiaryFormSchemaTypes['diary_duration_days'] =
    $formData.diary_duration_days;

  $: disabled = context === 'read';

  $: handleDiaryDurationDaysChange($formData.diary_duration_days);

  onMount(() => {
    if (!allowTaintAlert && $formData.diary_duration_days < 2) {
      handleDiaryDurationDaysChange($formData.diary_duration_days, false);
    }
  });

  function handleDiaryDurationDaysChange(
    newDiaryDurationDays: VoidingDiaryFormSchemaTypes['diary_duration_days'],
    checkLastValue = true
  ) {
    if (checkLastValue && newDiaryDurationDays === lastDiaryDurationDays) return;
    lastDiaryDurationDays = newDiaryDurationDays;

    if (newDiaryDurationDays >= 2) {
      // Reset to ensure validation.
      $formData.bedtime_day_two = '';
      $formData.wake_up_time_day_two = '';
    } else {
      // Fill in to ensure no validation.
      const timeNow = formatTime(getTimeValues(new Date().toISOString()));
      $formData.bedtime_day_two = timeNow;
      $formData.wake_up_time_day_two = timeNow;
    }
  }
</script>

<form class={columnsVariants({ number: 0, gap: 6, useSpacing: true })} method="POST" use:enhance>
  <!-- TODO: move to paraglide messages -->
  <DatePickerField name="diary_start_date" {disabled} {form} label="Kdy chcete deník začít vést?" />

  {#if $formData.diary_start_date}
    <div transition:slide>
      <SelectField
        name="diary_duration_days"
        data={[
          { value: 1, label: '1 den' },
          { value: 2, label: '2 dny' },
        ]}
        {disabled}
        {form}
        label={'Kolik dní chcete deník vést'}
      />
    </div>
  {/if}

  {#if $formData.diary_duration_days >= 1}
    <div transition:slide>
      <Card.Root>
        <Card.Header>
          <Title
            level="h2"
            text={new Date($formData.diary_start_date).toLocaleDateString(languageTag())}
          />
        </Card.Header>
        <Card.Content class={columnsVariants({ number: 0, gap: 6 })}>
          <TimePickerField
            name="bedtime_day_one"
            {disabled}
            {form}
            label={'V kolik hodin jste šel/šla spát?'}
          />

          <TimePickerField
            name="wake_up_time_day_one"
            {disabled}
            {form}
            label={'V kolik hodin jste vstal/vstala?'}
          />
        </Card.Content>
      </Card.Root>
    </div>
  {/if}

  {#if $formData.diary_duration_days >= 2}
    <div transition:slide>
      <Card.Root>
        <Card.Header>
          <Title
            level="h2"
            text={addDays(new Date($formData.diary_start_date), 1).toLocaleDateString(
              languageTag()
            )}
          />
        </Card.Header>
        <Card.Content class={columnsVariants({ number: 0, gap: 6 })}>
          <TimePickerField
            name="bedtime_day_two"
            {disabled}
            {form}
            label={'V kolik hodin jste šel/šla spát?'}
          />

          <TimePickerField
            name="wake_up_time_day_two"
            {disabled}
            {form}
            label={'V kolik hodin jste vstal/vstala?'}
          />
        </Card.Content>
      </Card.Root>
    </div>
  {/if}

  <Button {disabled} type="submit">
    {#if context === 'new'}
      {m.create()}
    {:else}
      {m.save()}
    {/if}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>

{#if allowTaintAlert}
  <TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
{/if}
