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
  import {
    addMonths,
    endOfDay,
    isAfter,
    isBefore,
    parseISO,
    startOfDay,
    subMonths,
  } from 'date-fns';
  import { persisted } from 'svelte-persisted-store';
  import type { StoresValues } from 'svelte/store';
  import { slide } from 'svelte/transition';
  import { defaults, setError, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import {
    getDiagnosesList,
    getDosageUnitsList,
    getPrescribedMedicationsList,
    getReasonsTreatmentNotStartedList,
  } from './constants';
  import {
    initialAppointmentFormSchema,
    type InitialAppointmentFormSchemaTypes,
  } from './form-schema';
  import type { InitialAppointment, User } from './types';

  export let initialData: {
    initialAppointment?: InitialAppointment;
    user?: User;
    patientId: number;
  };
  export let context: 'edit' | 'read' | 'new' = 'new';

  const persistedFormData = persisted<InitialAppointmentFormSchemaTypes | null>(
    `initial-appointment-form-data-${initialData.patientId}`,
    null
  );

  const defaultFormData = prepareSuperFormDefaultFormData<InitialAppointmentFormSchemaTypes>({
    assessment_date:
      initialData.initialAppointment?.assessment_date ?? $persistedFormData?.assessment_date,
    diagnosis:
      initialData.initialAppointment?.diagnosis ??
      $persistedFormData?.diagnosis ??
      DEFAULT_STRING_VALUE,
    alternative_diagnosis:
      initialData.initialAppointment?.alternative_diagnosis ??
      $persistedFormData?.alternative_diagnosis,
    oab_treatment_criteria_met:
      initialData.initialAppointment?.oab_treatment_criteria_met ??
      $persistedFormData?.oab_treatment_criteria_met ??
      DEFAULT_STRING_VALUE,
    initiate_pharmacological_treatment:
      initialData.initialAppointment?.initiate_pharmacological_treatment ??
      $persistedFormData?.initiate_pharmacological_treatment ??
      DEFAULT_STRING_VALUE,
    prescribed_medication:
      initialData.initialAppointment?.prescribed_medication ??
      $persistedFormData?.prescribed_medication ??
      DEFAULT_STRING_VALUE,
    dosage:
      initialData.initialAppointment?.dosage ?? $persistedFormData?.dosage ?? DEFAULT_STRING_VALUE,
    dosage_unit:
      initialData.initialAppointment?.dosage_unit ?? $persistedFormData?.dosage_unit ?? 'mg',
    alternative_dosage_unit:
      initialData.initialAppointment?.alternative_dosage_unit ??
      $persistedFormData?.alternative_dosage_unit,
    reason_treatment_not_started:
      initialData.initialAppointment?.reason_treatment_not_started ??
      $persistedFormData?.reason_treatment_not_started ??
      DEFAULT_STRING_VALUE,
    alternative_treatment_details:
      initialData.initialAppointment?.alternative_treatment_details ??
      $persistedFormData?.alternative_treatment_details,
  });

  const now = new Date();
  const minimumDate = subMonths(now, 1);
  const maximumDate = initialData.user?.next_appointment
    ? parseISO(initialData.user?.next_appointment)
    : addMonths(now, 1);

  const form = superForm(defaults(defaultFormData, zod(initialAppointmentFormSchema)), {
    SPA: true,
    validators: zodClient(initialAppointmentFormSchema),
    onChange(event) {
      for (const field of event.paths) {
        $persistedFormData ??= {} as NonNullable<StoresValues<typeof persistedFormData>>;

        setObjectValue($persistedFormData, field, event.get(field));
        $persistedFormData = $persistedFormData;
      }
    },
    async onUpdate({ form, cancel }) {
      if (!form.valid || context !== 'new') return;

      const minimumDateFormatted = minimumDate.toLocaleDateString(languageTag());
      const maximumDateFormatted = maximumDate.toLocaleDateString(languageTag());

      const assessmentDate = new Date(form.data.assessment_date);

      if (isBefore(assessmentDate, startOfDay(minimumDate))) {
        return setError(
          form,
          'assessment_date',
          m.dateMustBeMin({ minDate: minimumDateFormatted })
        );
      } else if (isAfter(assessmentDate, endOfDay(maximumDate))) {
        return setError(
          form,
          'assessment_date',
          m.dateMustBeMax({ maxDate: maximumDateFormatted })
        );
      }

      await handleRequest(
        async () => {
          await apiClient.POST('/api/v1/appointment_initials', {
            body: {
              appointment_initial: {
                assessment_date: form.data.assessment_date,
                diagnosis: form.data.diagnosis,
                alternative_diagnosis:
                  form.data.diagnosis === 'other_diagnosis'
                    ? form.data.alternative_diagnosis
                    : undefined,
                ...{
                  ...(form.data.diagnosis === 'oab' ||
                  form.data.diagnosis === 'oab_wet' ||
                  form.data.diagnosis === 'oab_mixed_incontinence' ||
                  form.data.diagnosis === 'unable_to_assess'
                    ? {
                        oab_treatment_criteria_met: Boolean(form.data.oab_treatment_criteria_met),
                        initiate_pharmacological_treatment: Boolean(
                          form.data.initiate_pharmacological_treatment
                        ),
                        ...{
                          ...(form.data.initiate_pharmacological_treatment
                            ? {
                                prescribed_medication: form.data.prescribed_medication || undefined,
                                dosage: Number(form.data.dosage),
                                dosage_unit: form.data.dosage_unit || undefined,
                                alternative_dosage_unit:
                                  form.data.dosage_unit === 'other_unit'
                                    ? form.data.alternative_dosage_unit
                                    : undefined,
                              }
                            : {
                                reason_treatment_not_started:
                                  form.data.reason_treatment_not_started || undefined,
                                alternative_treatment_details:
                                  form.data.reason_treatment_not_started === 'other_treatment'
                                    ? form.data.alternative_treatment_details
                                    : undefined,
                              }),
                        },
                      }
                    : {}),
                },
                user_id: initialData.patientId,
              },
            },
          });

          $persistedFormData = null;

          queryClient.invalidateQueries({ queryKey: queries.users._def });
          queryClient.invalidateQueries({ queryKey: queries.patients._def });
          queryClient.invalidateQueries({ queryKey: queries.initialAppointments._def });

          await goto(
            localizeRoute(
              route('/patients/approved/[patientId]', { patientId: initialData.patientId })
            )
          );
        },
        { onError: cancel, toastSuccessText: m.successfulRemotePatientDiagnosticsFill() }
      );
    },
  });

  const { enhance, form: formData } = form;

  $: disabled = context == 'read';
</script>

<form class={columnsVariants({ number: 0, gap: 6, useSpacing: true })} method="POST" use:enhance>
  <!-- TODO: move to paraglide messages -->
  <DatePickerField
    name="assessment_date"
    {disabled}
    {form}
    label={'Datum hodnocení'}
    {maximumDate}
    {minimumDate}
  />

  <SelectField name="diagnosis" data={getDiagnosesList()} {disabled} {form} label={'Diagnóza'} />

  {#if $formData.diagnosis === 'other_diagnosis'}
    <div transition:slide>
      <TextareaField
        name="alternative_diagnosis"
        {disabled}
        {form}
        label={'Uveďte jinou diagnózu'}
      />
    </div>
  {:else if $formData.diagnosis === 'oab' || $formData.diagnosis === 'oab_wet' || $formData.diagnosis === 'oab_mixed_incontinence' || $formData.diagnosis === 'unable_to_assess'}
    <div transition:slide>
      <RadioGroupField
        name="oab_treatment_criteria_met"
        coerceTo="boolean"
        data={[
          { value: 'true', label: m.yes() },
          { value: 'false', label: m.no() },
        ]}
        {disabled}
        {form}
        label={'Pacient splňuje kritéria pro léčbu OAB'}
      />
    </div>

    <div transition:slide>
      <RadioGroupField
        name="initiate_pharmacological_treatment"
        coerceTo="boolean"
        data={[
          { value: 'true', label: m.yes() },
          { value: 'false', label: m.no() },
        ]}
        {disabled}
        {form}
        label={'Zahájil byste na základě těchto údajů farmakologickou léčbu?'}
      />
    </div>

    {#if $formData.initiate_pharmacological_treatment}
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
      </div>

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
    {:else if $formData.initiate_pharmacological_treatment === false}
      <div transition:slide>
        <SelectField
          name="reason_treatment_not_started"
          data={getReasonsTreatmentNotStartedList()}
          {disabled}
          {form}
          label={'Uveďte důvod nezahájení léčby'}
          on:select={({ detail: { value } }) => {
            if (value === undefined) {
              $formData.reason_treatment_not_started = '';
            }
          }}
        />
      </div>

      {#if $formData.reason_treatment_not_started === 'other_treatment'}
        <div transition:slide>
          <FormField
            name="alternative_treatment_details"
            {disabled}
            {form}
            label={'Uveďte jinou léčbu'}
            type="text"
          />
        </div>
      {/if}
    {/if}
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
