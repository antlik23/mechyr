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
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { getDateString, getTimeString } from '$lib/utils/dates';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { addDays, isAfter, isBefore } from 'date-fns';
  import { writable } from 'svelte/store';
  import { slide } from 'svelte/transition';
  import { defaults, setError, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { assert, type Equals } from 'tsafe';
  import { URINE_LEAKAGE_TYPE } from './constants';
  import {
    voidingDiaryRecordOutputFormSchema,
    type VoidingDiaryRecordOutputFormSchemaTypes,
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

  const defaultFormData = prepareSuperFormDefaultFormData<VoidingDiaryRecordOutputFormSchemaTypes>({
    recorded_at: initialData.voidingDiaryRecord?.recorded_at
      ? getDateString(initialData.voidingDiaryRecord.recorded_at)
      : undefined,
    recordedAtTime: initialData.voidingDiaryRecord?.recorded_at
      ? getTimeString(initialData.voidingDiaryRecord.recorded_at)
      : undefined,
    slept_before_and_after:
      initialData.voidingDiaryRecord?.slept_before_and_after ?? DEFAULT_STRING_VALUE,
    urine_leakage: initialData.voidingDiaryRecord?.urine_leakage ?? DEFAULT_STRING_VALUE,
    urine_leakage_type: initialData.voidingDiaryRecord?.urine_leakage_type ?? DEFAULT_STRING_VALUE,
    urge_strength: initialData.voidingDiaryRecord?.urge_strength ?? DEFAULT_STRING_VALUE,
    urine_volume: initialData.voidingDiaryRecord?.urine_volume ?? DEFAULT_STRING_VALUE,
  });

  const minimumDate = new Date(initialData.voidingDiary.diary_start_date);
  const maximumDate = addDays(minimumDate, initialData.voidingDiary.diary_duration_days);

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(voidingDiaryRecordOutputFormSchema)), {
    SPA: true,
    validators: zodClient(voidingDiaryRecordOutputFormSchema),
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
      } else if (
        isBetweenBedTimeAndWakeUpTime &&
        typeof form.data.slept_before_and_after === 'string'
      ) {
        return setError(form, 'slept_before_and_after', m.fieldIsRequired());
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
                body: {
                  voiding_record: {
                    ...restFormData,
                    recorded_at,
                    urine_leakage_type: form.data.urine_leakage
                      ? form.data.urine_leakage_type
                      : undefined,
                    slept_before_and_after: isBetweenBedTimeAndWakeUpTime
                      ? Boolean(form.data.slept_before_and_after)
                      : undefined,
                  },
                },
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
                  body: {
                    voiding_record: {
                      ...restFormData,
                      recorded_at,
                      urine_leakage_type: form.data.urine_leakage
                        ? form.data.urine_leakage_type
                        : undefined,
                      slept_before_and_after: isBetweenBedTimeAndWakeUpTime
                        ? Boolean(form.data.slept_before_and_after)
                        : undefined,
                    },
                  },
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

  const { enhance, form: formData } = form;

  $: disabled = context === 'read';
  $: isBetweenBedTimeAndWakeUpTime = determineIsBetweenBedTimeAndWakeUpTime($formData);

  function determineIsBetweenBedTimeAndWakeUpTime(
    formDataValue: VoidingDiaryRecordOutputFormSchemaTypes
  ) {
    if (!formDataValue.recorded_at || !formDataValue.recordedAtTime) {
      return false;
    }

    const bedTimeDayOne = initialData.voidingDiary.bedtime_day_one ?? '22:00';
    const wakeUpTimeDayOne = initialData.voidingDiary.wake_up_time_day_one ?? '05:00';

    const firstDayBedTimeDate = new Date(
      `${initialData.voidingDiary.diary_start_date}T${bedTimeDayOne}`
    );
    const firstDayWakeUpTimeDate = new Date(
      `${initialData.voidingDiary.diary_start_date}T${wakeUpTimeDayOne}`
    );
    const dateSubmitted = new Date(`${formDataValue.recorded_at}T${formDataValue.recordedAtTime}`);

    if (initialData.voidingDiary.diary_duration_days === 1) {
      return !isBefore(dateSubmitted, firstDayBedTimeDate);
    } else {
      const bedTimeDayTwo = initialData.voidingDiary.bedtime_day_two ?? '22:00';

      const secondDayBedTimeDate = new Date(
        `${initialData.voidingDiary.diary_start_date}T${bedTimeDayTwo}`
      );

      if (
        isAfter(dateSubmitted, firstDayBedTimeDate) &&
        isBefore(dateSubmitted, addDays(firstDayWakeUpTimeDate, 1))
      ) {
        return true;
      }

      return !isBefore(dateSubmitted, addDays(secondDayBedTimeDate, 1));
    }
  }
</script>

<form class={columnsVariants({ number: 0, gap: 6, useSpacing: true })} method="POST" use:enhance>
  <DatePickerField
    name="recorded_at"
    {disabled}
    {form}
    label={m.date()}
    {maximumDate}
    {minimumDate}
  />

  <TimePickerField name="recordedAtTime" {disabled} {form} label={m.time()} />

  {#if isBetweenBedTimeAndWakeUpTime}
    <!-- TODO: move to paraglide messages -->
    <div transition:slide>
      <RadioGroupField
        name="slept_before_and_after"
        coerceTo="boolean"
        data={[
          { value: 'true', label: m.yes() },
          { value: 'false', label: m.no() },
        ]}
        {disabled}
        {form}
        label={'Spal/a jste před a zároveň po močení?'}
      />
    </div>
  {/if}

  <RadioGroupField
    name="urine_leakage"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Došlo k úniku moči?'}
  />

  {#if $formData.urine_leakage}
    <div transition:slide>
      <RadioGroupField
        name="urine_leakage_type"
        coerceTo="boolean"
        data={[
          {
            value: URINE_LEAKAGE_TYPE['0'],
            label:
              'Stresová - Únik zpravidla malého množství moči při fyzické aktivitě (kašel, kýchnutí, smích, běh, skákání apod.).',
          },
          {
            value: URINE_LEAKAGE_TYPE['1'],
            label:
              'Urgentní - Byl únik moči spojený s nutkáním na močení? Proběhl únik ve spánku nebo z neznámých důvodů?',
          },
        ]}
        {disabled}
        {form}
        label={'O jaký typ inkontinence se jednalo?'}
      />
    </div>
  {/if}

  <RadioGroupField
    name="urge_strength"
    coerceTo="number"
    data={[
      {
        value: '0',
        label:
          'Žádné nucení - necítil/a jsem potřebu vyprázdnit močový měchýř, ale vymočil/a jsem se z jiných důvodů',
      },
      {
        value: '1',
        label:
          'Mírné nucení - mohl/a jsem močení oddálit tak dlouho, jak bylo nutné bez obav z pomočení',
      },
      {
        value: '2',
        label: 'Středně silné - mohl/a jsem močení na krátkou chvíli oddálit bez obav z pomočení',
      },
      {
        value: '3',
        label:
          'Silné nucení - močení jsem nemohl/a oddálit, musel/a jsem spěchat na toaletu, abych se nepomočil/a',
      },
      { value: '4', label: 'Urgentní únik - pomočil/a jsem se před příchodem na toaletu' },
    ]}
    {disabled}
    {form}
    label={'Jak silné bylo nucení k močení?'}
  />

  <FormField
    name="urine_volume"
    {disabled}
    {form}
    label={'Jaké bylo množství moči (ml)?'}
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
