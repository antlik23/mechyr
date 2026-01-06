<script lang="ts">
  import { goto } from '$app/navigation';
  import { apiClient } from '$lib/api/api';
  import { queries, queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import * as Form from '$lib/components/form';
  import DatePickerField from '$lib/components/form/form-fields/DatePickerField.svelte';
  import TimePickerField from '$lib/components/form/form-fields/TimePickerField.svelte';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import SelectField from '$lib/components/forms/wrappers/SelectField.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { getDateString, getTimeString } from '$lib/utils/dates';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { addDays, isAfter, isBefore } from 'date-fns';
  import { writable } from 'svelte/store';
  import { defaults, setError, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { assert, type Equals } from 'tsafe';
  import { getBeverageTypeList } from './constants';
  import {
    voidingDiaryRecordInputFormSchema,
    type VoidingDiaryRecordInputFormSchemaTypes,
  } from './form-schema';
  import type { VoidingDiary, VoidingDiaryRecord } from './types';

  export let initialData: {
    voidingDiaryRecord?: VoidingDiaryRecord;
    voidingDiary: VoidingDiary;
    diaryId: number;
    patientId?: number;
  };
  export let context: 'read' | 'new' | 'edit' = 'new';
  export let userContext: 'doctor' | 'patient' | 'admin';

  const defaultFormData = prepareSuperFormDefaultFormData<VoidingDiaryRecordInputFormSchemaTypes>({
    recorded_at: initialData.voidingDiaryRecord?.recorded_at
      ? getDateString(initialData.voidingDiaryRecord.recorded_at)
      : undefined,
    recordedAtTime: initialData.voidingDiaryRecord?.recorded_at
      ? getTimeString(initialData.voidingDiaryRecord.recorded_at)
      : undefined,
    beverage_type: initialData.voidingDiaryRecord?.beverage_type ?? DEFAULT_STRING_VALUE,
    fluid_intake: initialData.voidingDiaryRecord?.fluid_intake ?? DEFAULT_STRING_VALUE,
  });

  const minimumDate = new Date(initialData.voidingDiary.diary_start_date);
  const maximumDate = addDays(minimumDate, initialData.voidingDiary.diary_duration_days);

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(voidingDiaryRecordInputFormSchema)), {
    SPA: true,
    validators: zodClient(voidingDiaryRecordInputFormSchema),
    taintedMessage: () => taintedFormAlertDialogRef.taintedMessage(),
    async onUpdate({ form, cancel }) {
      if (!form.valid || context === 'read') return;

      const minimumDateFormatted = minimumDate.toLocaleDateString(languageTag());
      const maximumDateFormatted = maximumDate.toLocaleDateString(languageTag());

      const recordedAtDate = new Date(form.data.recorded_at);

      if (isBefore(recordedAtDate, minimumDate)) {
        return setError(form, 'recorded_at', m.dateMustBeMin({ minDate: minimumDateFormatted }));
      } else if (isAfter(recordedAtDate, maximumDate)) {
        return setError(form, 'recorded_at', m.dateMustBeMax({ maxDate: maximumDateFormatted }));
      }

      const toastSuccessText = writable('');

      await handleRequest(
        async () => {
          const { recordedAtTime, ...restFormData } = form.data;
          const recorded_at = new Date(`${form.data.recorded_at}T${recordedAtTime}`).toISOString();

          switch (context) {
            case 'new':
              await apiClient.POST('/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records', {
                params: { path: { voiding_diary_id: initialData.diaryId } },
                body: { voiding_record: { ...restFormData, recorded_at } },
              });

              toastSuccessText.set(m.successfulEntryAdd());
              break;
            case 'edit': {
              const recordId = initialData.voidingDiaryRecord?.id;
              assert(recordId, 'Record ID available');

              await apiClient.PUT(
                '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}',
                {
                  params: { path: { voiding_diary_id: initialData.diaryId, id: recordId } },
                  body: { voiding_record: { ...restFormData, recorded_at } },
                }
              );

              toastSuccessText.set(m.successfulEntryEdit());
              break;
            }
            default:
              assert<Equals<typeof context, never>>();
          }

          queryClient.invalidateQueries({ queryKey: queries.voidingDiaries._def });

          if (userContext === 'patient') {
            await goto(
              localizeRoute(
                route('/voiding-diary/list/[diaryId]/records', { diaryId: initialData.diaryId })
              )
            );
          } else {
            assert(initialData.patientId, 'Available Patient ID');

            await goto(
              localizeRoute(
                route('/patients/approved/[patientId]/voiding-diary/[diaryId]/records', {
                  patientId: initialData.patientId,
                  diaryId: initialData.diaryId,
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

  const { enhance } = form;

  $: disabled = context === 'read';
</script>

<form class={columnsVariants({ number: 0, gap: 6 })} method="POST" use:enhance>
  <DatePickerField
    name="recorded_at"
    {disabled}
    {form}
    label={m.date()}
    {maximumDate}
    {minimumDate}
  />

  <TimePickerField name="recordedAtTime" {disabled} {form} label={m.time()} />

  <!-- TODO: move to paraglide messages -->
  <SelectField
    name="beverage_type"
    data={getBeverageTypeList()}
    {disabled}
    {form}
    label={'O jaký nápoj se jednalo?'}
  />

  <FormField
    name="fluid_intake"
    {disabled}
    {form}
    label={'Jaké bylo množství tekutin (ml)?'}
    type="number"
  />

  <Button {disabled} type="submit">
    {#if context === 'new'}
      {m.add()}
    {:else}
      {m.save()}
    {/if}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>

<TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
