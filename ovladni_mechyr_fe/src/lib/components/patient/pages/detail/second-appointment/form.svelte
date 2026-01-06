<script lang="ts">
  import { goto } from '$app/navigation';
  import { apiClient } from '$lib/api/api';
  import { queries, queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';
  import DatePickerField from '$lib/components/form/form-fields/DatePickerField.svelte';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import SelectField from '$lib/components/forms/wrappers/SelectField.svelte';
  import TextareaField from '$lib/components/forms/wrappers/TextareaField.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { setObjectValue } from '$lib/utils/object';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { addMonths, format, isBefore } from 'date-fns';
  import { persisted } from 'svelte-persisted-store';
  import type { StoresValues } from 'svelte/store';
  import { slide } from 'svelte/transition';
  import { defaults, setError, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { getDosageUnitsList } from '../initial-appointment/constants';
  import {
    getCurrentTreatmentsList,
    getDiscontinuationReasonsList,
    getPrescribedMedicationsList,
  } from './constants';
  import {
    secondAppointmentFormSchema,
    type SecondAppointmentFormSchemaTypes,
  } from './form-schema';
  import type { FirstAppointment, SecondAppointment } from './types';

  export let initialData: {
    secondAppointment?: SecondAppointment;
    firstAppointment: FirstAppointment;
    patientId: number;
  };
  export let context: 'edit' | 'read' | 'new' = 'new';

  const persistedFormData = persisted<SecondAppointmentFormSchemaTypes | null>(
    `second-appointment-form-data-${initialData.patientId}`,
    null
  );

  const defaultFormData = prepareSuperFormDefaultFormData<SecondAppointmentFormSchemaTypes>({
    attended_appointment:
      initialData.secondAppointment?.attended_appointment ??
      $persistedFormData?.attended_appointment ??
      DEFAULT_STRING_VALUE,
    appointment_date:
      $persistedFormData?.appointment_date ??
      initialData.secondAppointment?.appointment_date ??
      (initialData.firstAppointment?.appointment_date
        ? format(
            addMonths(new Date(initialData.firstAppointment.appointment_date), 3),
            'yyyy-MM-dd'
          )
        : DEFAULT_STRING_VALUE),
    visual_analog_scale:
      initialData.secondAppointment?.visual_analog_scale ??
      $persistedFormData?.visual_analog_scale ??
      DEFAULT_STRING_VALUE,
    continuing_treatment:
      initialData.secondAppointment?.continuing_treatment ??
      $persistedFormData?.continuing_treatment ??
      DEFAULT_STRING_VALUE,
    discontinuation_reason:
      initialData.secondAppointment?.discontinuation_reason ??
      $persistedFormData?.discontinuation_reason ??
      DEFAULT_STRING_VALUE,
    alternative_reason:
      initialData.secondAppointment?.alternative_reason ?? $persistedFormData?.alternative_reason,
    current_treatment:
      initialData.secondAppointment?.current_treatment ??
      $persistedFormData?.current_treatment ??
      DEFAULT_STRING_VALUE,
    prescribed_medication:
      initialData.secondAppointment?.prescribed_medication ??
      $persistedFormData?.prescribed_medication ??
      DEFAULT_STRING_VALUE,
    dosage:
      initialData.secondAppointment?.dosage ?? $persistedFormData?.dosage ?? DEFAULT_STRING_VALUE,
    dosage_unit:
      initialData.secondAppointment?.dosage_unit ?? $persistedFormData?.dosage_unit ?? 'mg',
    alternative_dosage_unit:
      initialData.secondAppointment?.alternative_dosage_unit ??
      $persistedFormData?.alternative_dosage_unit,
    multiple_medications:
      initialData.secondAppointment?.multiple_medications ??
      $persistedFormData?.multiple_medications,
    multiple_medications_dosage:
      initialData.secondAppointment?.multiple_medications_dosage ??
      $persistedFormData?.multiple_medications_dosage,
    notes: initialData.secondAppointment?.notes ?? $persistedFormData?.notes,
  });

  const minimumDate = addMonths(new Date(initialData.firstAppointment.appointment_date), 2);

  const form = superForm(defaults(defaultFormData, zod(secondAppointmentFormSchema)), {
    SPA: true,
    validators: zodClient(secondAppointmentFormSchema),
    onChange(event) {
      for (const field of event.paths) {
        $persistedFormData ??= {} as NonNullable<StoresValues<typeof persistedFormData>>;

        setObjectValue($persistedFormData, field, event.get(field));
        $persistedFormData = $persistedFormData;
      }
    },
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      const minimumDateFormatted = minimumDate.toLocaleDateString(languageTag());
      const appointmentDate = new Date(form.data.appointment_date);

      if (isBefore(appointmentDate, minimumDate)) {
        return setError(
          form,
          'appointment_date',
          m.dateMustBeMin({ minDate: minimumDateFormatted })
        );
      }

      await handleRequest(
        async () => {
          switch (context) {
            case 'new':
              await apiClient.POST('/api/v1/appointment_seconds', {
                body: {
                  appointment_second: {
                    attended_appointment: form.data.attended_appointment,
                    ...{
                      ...(form.data.attended_appointment
                        ? {
                            appointment_date: form.data.appointment_date,
                            visual_analog_scale: Number(form.data.visual_analog_scale),
                            continuing_treatment: form.data.continuing_treatment || undefined,
                            ...{
                              ...(form.data.continuing_treatment === 'false'
                                ? {
                                    discontinuation_reason:
                                      form.data.discontinuation_reason || undefined,
                                    alternative_reason:
                                      form.data.discontinuation_reason === 'other_reason'
                                        ? form.data.alternative_reason
                                        : undefined,
                                  }
                                : {
                                    current_treatment: form.data.current_treatment || undefined,
                                    ...{
                                      ...(form.data.current_treatment === 'change_of_medication'
                                        ? {
                                            ...{
                                              ...(form.data.prescribed_medication ===
                                              'multiple_medication'
                                                ? {
                                                    multiple_medications:
                                                      form.data.multiple_medications,
                                                    multiple_medications_dosage:
                                                      form.data.multiple_medications_dosage,
                                                  }
                                                : {
                                                    prescribed_medication:
                                                      form.data.prescribed_medication || undefined,
                                                    dosage: Number(form.data.dosage),
                                                    dosage_unit: form.data.dosage_unit || undefined,
                                                    alternative_dosage_unit:
                                                      form.data.dosage_unit === 'other_unit'
                                                        ? form.data.alternative_dosage_unit
                                                        : undefined,
                                                  }),
                                            },
                                          }
                                        : {}),
                                    },
                                  }),
                            },
                          }
                        : {}),
                    },
                    user_id: initialData.patientId,
                    notes: form.data.notes,
                  },
                },
              });

              $persistedFormData = null;

              queryClient.invalidateQueries({ queryKey: queries.users._def });
              queryClient.invalidateQueries({ queryKey: queries.patients._def });
              queryClient.invalidateQueries({ queryKey: queries.secondAppointments._def });

              await goto(
                localizeRoute(
                  route('/patients/approved/[patientId]', { patientId: initialData.patientId })
                )
              );
              break;
            case 'edit': {
              if (!initialData.secondAppointment) return;
              const isAttended = form.data.attended_appointment;
              const continuingRaw = form.data.continuing_treatment;
              const allowedContinuingValues = ['true', 'false', 'without_oab'] as const;

              const isContinuing = allowedContinuingValues.includes(
                continuingRaw as (typeof allowedContinuingValues)[number]
              )
                ? (continuingRaw as (typeof allowedContinuingValues)[number])
                : null;
              const isChangingMedication = form.data.current_treatment === 'change_of_medication';
              const isMultipleMedication =
                form.data.prescribed_medication === 'multiple_medication';

              await apiClient.PUT('/api/v1/appointment_seconds/{id}', {
                params: { path: { id: initialData.secondAppointment.id } },
                body: {
                  appointment_second: {
                    attended_appointment: isAttended,
                    appointment_date: isAttended ? form.data.appointment_date : null,
                    visual_analog_scale: isAttended ? Number(form.data.visual_analog_scale) : null,
                    continuing_treatment: isAttended ? isContinuing : null,
                    discontinuation_reason:
                      isAttended && isContinuing === 'false'
                        ? form.data.discontinuation_reason || null
                        : null,
                    alternative_reason:
                      isAttended &&
                      isContinuing === 'false' &&
                      form.data.discontinuation_reason === 'other_reason'
                        ? form.data.alternative_reason || null
                        : null,

                    current_treatment:
                      isAttended && isContinuing !== 'false'
                        ? form.data.current_treatment || null
                        : null,
                    prescribed_medication:
                      isAttended && isContinuing !== 'false' && isChangingMedication
                        ? form.data.prescribed_medication || null
                        : null,
                    dosage:
                      isAttended &&
                      isContinuing !== 'false' &&
                      isChangingMedication &&
                      !isMultipleMedication
                        ? Number(form.data.dosage)
                        : null,
                    dosage_unit:
                      isAttended &&
                      isContinuing !== 'false' &&
                      isChangingMedication &&
                      !isMultipleMedication
                        ? form.data.dosage_unit || null
                        : null,
                    alternative_dosage_unit:
                      isAttended &&
                      isContinuing !== 'false' &&
                      isChangingMedication &&
                      form.data.dosage_unit === 'other_unit' &&
                      !isMultipleMedication
                        ? form.data.alternative_dosage_unit || null
                        : null,
                    multiple_medications:
                      isAttended &&
                      isContinuing !== 'false' &&
                      isChangingMedication &&
                      isMultipleMedication
                        ? form.data.multiple_medications || null
                        : null,
                    multiple_medications_dosage:
                      isAttended &&
                      isContinuing !== 'false' &&
                      isChangingMedication &&
                      isMultipleMedication
                        ? form.data.multiple_medications_dosage || null
                        : null,
                    notes: form.data.notes,
                  },
                },
              });

              $persistedFormData = null;

              queryClient.invalidateQueries({ queryKey: queries.users._def });
              queryClient.invalidateQueries({ queryKey: queries.patients._def });
              queryClient.invalidateQueries({ queryKey: queries.secondAppointments._def });

              await goto(
                localizeRoute(
                  route('/patients/approved/[patientId]', { patientId: initialData.patientId })
                )
              );
              break;
            }
          }
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulFollowUpVisitAfterXMonthsFill({ monthsAmount: 3 }),
        }
      );
    },
  });

  const { enhance, form: formData } = form;

  $: disabled = context == 'read';
</script>

<form class={columnsVariants({ number: 0, gap: 6, useSpacing: true })} method="POST" use:enhance>
  <!-- TODO: move to paraglide messages -->
  <RadioGroupField
    name="attended_appointment"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Pacient se dostavil k lékaři'}
  />

  {#if $formData.attended_appointment}
    <div transition:slide>
      <DatePickerField
        name="appointment_date"
        {disabled}
        {form}
        label={'Datum návštěvy'}
        {minimumDate}
      />
    </div>

    <div transition:slide>
      <FormField
        name="visual_analog_scale"
        {disabled}
        {form}
        label={'Vizuální analogová škála (VAS) obtíží s močovým měchýřem'}
        type="number"
      />
    </div>

    <div transition:slide>
      <RadioGroupField
        name="continuing_treatment"
        coerceTo="string"
        data={[
          { value: 'true', label: m.yes() },
          { value: 'false', label: m.no() },
          {
            value: 'without_oab',
            label: ' Při první návštěvě nebyla stanovena farmakologická léčba OAB',
          },
        ]}
        {disabled}
        {form}
        label={'Pacient pokračuje v léčbě'}
      />
    </div>

    {#if $formData.continuing_treatment === 'false'}
      <div transition:slide>
        <SelectField
          name="discontinuation_reason"
          data={getDiscontinuationReasonsList()}
          {disabled}
          {form}
          label={'Uveďte důvod'}
          on:select={({ detail: { value } }) => {
            if (value === undefined) {
              $formData.discontinuation_reason = '';
            }
          }}
        />
      </div>

      {#if $formData.discontinuation_reason === 'other_reason'}
        <div transition:slide>
          <TextareaField name="alternative_reason" {disabled} {form} label={'Uveďte jiný důvod'} />
        </div>
      {/if}
    {:else if $formData.continuing_treatment === 'true'}
      <div transition:slide>
        <SelectField
          name="current_treatment"
          data={getCurrentTreatmentsList()}
          {disabled}
          {form}
          label={'Aktuální léčba'}
          on:select={({ detail: { value } }) => {
            if (value === undefined) {
              $formData.current_treatment = '';
            }
          }}
        />
      </div>

      {#if $formData.current_treatment === 'change_of_medication'}
        <div transition:slide>
          <SelectField
            name="prescribed_medication"
            data={getPrescribedMedicationsList()}
            {disabled}
            {form}
            label={'Vyberte lék'}
            on:select={({ detail: { value } }) => {
              if (value === undefined) {
                $formData.prescribed_medication = '';
              }
            }}
          />
        </div>

        {#if $formData.prescribed_medication === 'multiple_medication'}
          <div transition:slide>
            <FormField
              name="multiple_medications"
              {disabled}
              {form}
              label={'Specifikujte, o jakou kombinaci léků se jedná'}
              type="text"
            />
          </div>

          <div transition:slide>
            <FormField
              name="multiple_medications_dosage"
              {disabled}
              {form}
              label={'Specifikujte dávkování léků vč. jejich jednotky'}
              type="text"
            />
          </div>
        {/if}

        {#if $formData.prescribed_medication !== 'multiple_medication'}
          <div transition:slide>
            <FormField name="dosage" {disabled} {form} label={'Dávkování'} type="number" />
          </div>

          <div transition:slide>
            <SelectField
              name="dosage_unit"
              data={getDosageUnitsList()}
              {disabled}
              {form}
              label={'Jednotka dávkování léku'}
              on:select={({ detail: { value } }) => {
                if (value === undefined) {
                  $formData.dosage_unit = '';
                }
              }}
            />

            {#if $formData.dosage_unit === 'other_unit'}
              <div transition:slide>
                <FormField
                  name="alternative_dosage_unit"
                  {disabled}
                  {form}
                  label={'Uveďte jednotku udávané dávky léku'}
                  type="text"
                />
              </div>
            {/if}
          </div>
        {/if}
      {/if}
    {/if}
  {/if}

  <TextareaField name="notes" {disabled} {form} label={'Poznámky'} />

  <Button {disabled} type="submit">
    {#if context === 'new'}
      {m.create()}
    {:else}
      {m.save()}
    {/if}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>
