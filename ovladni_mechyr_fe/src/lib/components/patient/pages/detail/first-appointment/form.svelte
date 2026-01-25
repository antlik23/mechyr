<script lang="ts">
  import { goto } from '$app/navigation';
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';
  import DatePickerField from '$lib/components/form/form-fields/DatePickerField.svelte';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import SelectField from '$lib/components/forms/wrappers/SelectField.svelte';
  import TextareaField from '$lib/components/forms/wrappers/TextareaField.svelte';
  import { labelVariants } from '$lib/components/ui/label/label.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { setObjectValue } from '$lib/utils/object';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { addMonths, isBefore, startOfDay } from 'date-fns';
  import { persisted } from 'svelte-persisted-store';
  import type { StoresValues } from 'svelte/store';
  import { slide } from 'svelte/transition';
  import { defaults, setError, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import {
    getDiagnosesList,
    getDosageUnitsList,
    getPrescribedMedicationsList,
  } from '../initial-appointment/constants';
  import { getReasonsTreatmentNotStartedList } from './constants';
  import { firstAppointmentFormSchema, type FirstAppointmentFormSchemaTypes } from './form-schema';
  import type { FirstAppointment, InitialAppointment } from './types';
  import type { UserGenderWithOther } from '$lib/components/user/types';

  export let initialData: {
    firstAppointment?: FirstAppointment;
    initialAppointment: InitialAppointment;
    patientId: number;
    gender: UserGenderWithOther | null | undefined;
  };
  export let context: 'edit' | 'read' | 'new' = 'new';

  const persistedFormData = persisted<FirstAppointmentFormSchemaTypes | null>(
    `first-appointment-form-data-${initialData.patientId}`,
    null
  );

  const defaultFormData = prepareSuperFormDefaultFormData<FirstAppointmentFormSchemaTypes>({
    gender: initialData.gender,
    appointment_date:
      $persistedFormData?.appointment_date ??
      (initialData.firstAppointment?.appointment_date ||
        initialData.initialAppointment?.assessment_date),
    consent_signed:
      initialData.firstAppointment?.consent_signed ??
      $persistedFormData?.consent_signed ??
      DEFAULT_STRING_VALUE,
    meets_project_criteria:
      initialData.firstAppointment?.meets_project_criteria ??
      $persistedFormData?.meets_project_criteria ??
      DEFAULT_STRING_VALUE,
    blood_in_urine:
      initialData.firstAppointment?.blood_in_urine ?? $persistedFormData?.blood_in_urine,
    protein_in_urine:
      initialData.firstAppointment?.protein_in_urine ?? $persistedFormData?.protein_in_urine,
    sugar_in_urine:
      initialData.firstAppointment?.sugar_in_urine ?? $persistedFormData?.sugar_in_urine,
    post_void_residual_over_100_ml:
      initialData.firstAppointment?.post_void_residual_over_100_ml ??
      $persistedFormData?.post_void_residual_over_100_ml,
    clinical_assessment_completed:
      initialData.firstAppointment?.clinical_assessment_completed ??
      $persistedFormData?.clinical_assessment_completed ??
      DEFAULT_STRING_VALUE,
    prolapse_present:
      initialData.firstAppointment?.prolapse_present ??
      $persistedFormData?.prolapse_present ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    stress_test_done:
      initialData.firstAppointment?.stress_test_done ??
      $persistedFormData?.stress_test_done ??
      DEFAULT_STRING_VALUE,
    stress_test_result:
      initialData.firstAppointment?.stress_test_result ??
      $persistedFormData?.stress_test_result ??
      DEFAULT_STRING_VALUE,
    uti_excluded:
      initialData.firstAppointment?.uti_excluded ??
      $persistedFormData?.uti_excluded ??
      DEFAULT_STRING_VALUE,
    bladder_discomfort_vas:
      initialData.firstAppointment?.bladder_discomfort_vas ??
      $persistedFormData?.bladder_discomfort_vas ??
      DEFAULT_STRING_VALUE,
    diagnosis:
      initialData.firstAppointment?.diagnosis ??
      $persistedFormData?.diagnosis ??
      DEFAULT_STRING_VALUE,
    alternative_diagnosis:
      initialData.firstAppointment?.alternative_diagnosis ??
      $persistedFormData?.alternative_diagnosis,
    oab_treatment_criteria_met:
      initialData.firstAppointment?.oab_treatment_criteria_met ??
      $persistedFormData?.oab_treatment_criteria_met ??
      DEFAULT_STRING_VALUE,
    prescribed_medication:
      initialData.firstAppointment?.prescribed_medication ??
      $persistedFormData?.prescribed_medication ??
      DEFAULT_STRING_VALUE,
    dosage:
      initialData.firstAppointment?.dosage ?? $persistedFormData?.dosage ?? DEFAULT_STRING_VALUE,
    dosage_unit:
      initialData.firstAppointment?.dosage_unit ?? $persistedFormData?.dosage_unit ?? 'mg',
    alternative_dosage_unit:
      initialData.firstAppointment?.alternative_dosage_unit ??
      $persistedFormData?.alternative_dosage_unit,
    reason_treatment_not_started:
      initialData.firstAppointment?.reason_treatment_not_started ??
      $persistedFormData?.reason_treatment_not_started ??
      DEFAULT_STRING_VALUE,
    alternative_treatment_details:
      initialData.firstAppointment?.alternative_treatment_details ??
      $persistedFormData?.alternative_treatment_details,
    treatment_contraindications:
      initialData.firstAppointment?.treatment_contraindications ??
      $persistedFormData?.treatment_contraindications,
    follow_up_date:
      initialData.firstAppointment?.follow_up_date ?? $persistedFormData?.follow_up_date,
    notes: initialData.firstAppointment?.notes ?? $persistedFormData?.notes,
  });

  const appointmentMinimumDate = new Date(initialData.initialAppointment.assessment_date);

  const form = superForm(defaults(defaultFormData, zod(firstAppointmentFormSchema)), {
    SPA: true,
    validators: zodClient(firstAppointmentFormSchema),
    onChange(event) {
      for (const field of event.paths) {
        $persistedFormData ??= {} as NonNullable<StoresValues<typeof persistedFormData>>;

        setObjectValue($persistedFormData, field, event.get(field));
        $persistedFormData = $persistedFormData;
      }
    },
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      const minimumDateFormatted = appointmentMinimumDate.toLocaleDateString(languageTag());
      const appointmentDate = new Date(form.data.appointment_date);

      const followUpMinimumDate = startOfDay(addMonths(appointmentDate, 3));
      const followUpMinimumDateFormatted = followUpMinimumDate?.toLocaleDateString(languageTag());
      const followUpDate = startOfDay(new Date(form.data.follow_up_date));

      if (isBefore(appointmentDate, appointmentMinimumDate)) {
        return setError(
          form,
          'appointment_date',
          m.dateMustBeMin({ minDate: minimumDateFormatted })
        );
      } else if (isBefore(followUpDate, followUpMinimumDate)) {
        return setError(
          form,
          'follow_up_date',
          m.dateMustBeMin({ minDate: followUpMinimumDateFormatted })
        );
      }

      await handleRequest(
        async () => {
          switch (context) {
            case 'new':
              await apiClient.POST('/api/v1/appointment_firsts', {
                body: {
                  appointment_first: {
                    appointment_date: form.data.appointment_date,
                    consent_signed: form.data.consent_signed,
                    ...{
                      ...(form.data.consent_signed
                        ? {
                            meets_project_criteria: Boolean(form.data.meets_project_criteria),
                            ...{
                              ...(form.data.meets_project_criteria
                                ? {
                                    blood_in_urine: Boolean(form.data.blood_in_urine),
                                    protein_in_urine: Boolean(form.data.protein_in_urine),
                                    sugar_in_urine: Boolean(form.data.sugar_in_urine),
                                    post_void_residual_over_100_ml: Boolean(
                                      form.data.post_void_residual_over_100_ml
                                    ),
                                    clinical_assessment_completed: Boolean(
                                      form.data.clinical_assessment_completed
                                    ),
                                    ...(initialData.gender === 'female'
                                      ? {
                                          prolapse_present: form.data.clinical_assessment_completed
                                            ? Boolean(form.data.prolapse_present)
                                            : undefined,
                                        }
                                      : { prolapse_present: undefined }),
                                    stress_test_done: Boolean(form.data.stress_test_done),
                                    stress_test_result: form.data.stress_test_done
                                      ? Boolean(form.data.stress_test_result)
                                      : undefined,
                                    uti_excluded: Boolean(form.data.uti_excluded),
                                    bladder_discomfort_vas: Number(
                                      form.data.bladder_discomfort_vas
                                    ),
                                    diagnosis: form.data.diagnosis || undefined,
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
                                            oab_treatment_criteria_met: Boolean(
                                              form.data.oab_treatment_criteria_met
                                            ),
                                            ...{
                                              ...(form.data.oab_treatment_criteria_met
                                                ? {
                                                    prescribed_medication:
                                                      form.data.prescribed_medication || undefined,
                                                    dosage: Number(form.data.dosage),
                                                    dosage_unit: form.data.dosage_unit || undefined,
                                                    alternative_dosage_unit:
                                                      form.data.dosage_unit === 'other_unit'
                                                        ? form.data.alternative_dosage_unit
                                                        : undefined,
                                                  }
                                                : {
                                                    reason_treatment_not_started:
                                                      form.data.reason_treatment_not_started ||
                                                      undefined,
                                                    alternative_treatment_details:
                                                      form.data.reason_treatment_not_started ===
                                                      'other_treatment'
                                                        ? form.data.alternative_treatment_details
                                                        : undefined,
                                                    treatment_contraindications:
                                                      form.data.reason_treatment_not_started ===
                                                      'contraindications_to_treatment'
                                                        ? form.data.treatment_contraindications
                                                        : undefined,
                                                  }),
                                            },
                                            follow_up_date: form.data.follow_up_date,
                                          }
                                        : {}),
                                    },
                                  }
                                : {}),
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

              queryClient.invalidateQueries();

              await goto(
                localizeRoute(
                  route('/patients/approved/[patientId]', { patientId: initialData.patientId })
                )
              );
              break;
            case 'edit': {
              if (!initialData.firstAppointment) return;
              await apiClient.PUT('/api/v1/appointment_firsts/{id}', {
                params: { path: { id: initialData.firstAppointment.id } },
                body: {
                  appointment_first: {
                    appointment_date: form.data.appointment_date ?? null,
                    consent_signed: form.data.consent_signed ?? null,
                    meets_project_criteria:
                      form.data.consent_signed !== false
                        ? Boolean(form.data.meets_project_criteria)
                        : null,
                    blood_in_urine:
                      form.data.consent_signed !== false && form.data.meets_project_criteria
                        ? Boolean(form.data.blood_in_urine)
                        : null,
                    protein_in_urine:
                      form.data.consent_signed !== false && form.data.meets_project_criteria
                        ? Boolean(form.data.protein_in_urine)
                        : null,
                    sugar_in_urine:
                      form.data.consent_signed !== false && form.data.meets_project_criteria
                        ? Boolean(form.data.sugar_in_urine)
                        : null,
                    post_void_residual_over_100_ml:
                      form.data.consent_signed !== false && form.data.meets_project_criteria
                        ? Boolean(form.data.post_void_residual_over_100_ml)
                        : null,
                    clinical_assessment_completed:
                      form.data.consent_signed && form.data.meets_project_criteria
                        ? Boolean(form.data.clinical_assessment_completed)
                        : null,
                    ...(initialData.gender === 'female'
                      ? {
                          prolapse_present:
                            form.data.consent_signed &&
                            form.data.meets_project_criteria &&
                            form.data.clinical_assessment_completed
                              ? Boolean(form.data.prolapse_present)
                              : null,
                        }
                      : { prolapse_present: undefined }),

                    stress_test_done:
                      form.data.consent_signed && form.data.meets_project_criteria
                        ? Boolean(form.data.stress_test_done)
                        : null,
                    stress_test_result:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      form.data.stress_test_done
                        ? Boolean(form.data.stress_test_result)
                        : null,
                    uti_excluded:
                      form.data.consent_signed && form.data.meets_project_criteria
                        ? Boolean(form.data.uti_excluded)
                        : null,
                    bladder_discomfort_vas:
                      form.data.consent_signed && form.data.meets_project_criteria
                        ? form.data.bladder_discomfort_vas !== ''
                          ? Number(form.data.bladder_discomfort_vas)
                          : null
                        : null,
                    diagnosis:
                      form.data.consent_signed && form.data.meets_project_criteria
                        ? form.data.diagnosis || undefined
                        : null,
                    alternative_diagnosis:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      form.data.diagnosis === 'other_diagnosis'
                        ? (form.data.alternative_diagnosis ?? null)
                        : null,
                    oab_treatment_criteria_met:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      ['oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess'].includes(
                        form.data.diagnosis
                      )
                        ? Boolean(form.data.oab_treatment_criteria_met)
                        : null,
                    prescribed_medication:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      form.data.oab_treatment_criteria_met
                        ? form.data.prescribed_medication || undefined
                        : null,
                    dosage:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      form.data.oab_treatment_criteria_met
                        ? form.data.dosage !== ''
                          ? Number(form.data.dosage)
                          : null
                        : null,
                    dosage_unit:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      form.data.oab_treatment_criteria_met
                        ? form.data.dosage_unit || undefined
                        : null,
                    alternative_dosage_unit:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      form.data.oab_treatment_criteria_met &&
                      form.data.dosage_unit === 'other_unit'
                        ? (form.data.alternative_dosage_unit ?? null)
                        : null,
                    reason_treatment_not_started:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      !form.data.oab_treatment_criteria_met
                        ? form.data.reason_treatment_not_started || undefined
                        : null,
                    alternative_treatment_details:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      !form.data.oab_treatment_criteria_met &&
                      form.data.reason_treatment_not_started === 'other_treatment'
                        ? (form.data.alternative_treatment_details ?? null)
                        : null,
                    treatment_contraindications:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      !form.data.oab_treatment_criteria_met &&
                      form.data.reason_treatment_not_started === 'contraindications_to_treatment'
                        ? (form.data.treatment_contraindications ?? null)
                        : null,
                    follow_up_date:
                      form.data.consent_signed &&
                      form.data.meets_project_criteria &&
                      ['oab', 'oab_wet', 'oab_mixed_incontinence', 'unable_to_assess'].includes(
                        form.data.diagnosis
                      )
                        ? (form.data.follow_up_date ?? null)
                        : null,
                    notes: form.data.notes,
                  },
                },
              });

              $persistedFormData = null;

              queryClient.invalidateQueries();

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
          toastSuccessText: m.successfulPersonalVisitDiagnosticsFill(),
        }
      );
    },
  });

  const { enhance, form: formData } = form;

  $: followUpMinimumDate = $formData.appointment_date
    ? startOfDay(addMonths(new Date($formData.appointment_date), 3))
    : undefined;

  $: disabled = context == 'read';
</script>

<form class={columnsVariants({ number: 0, gap: 6, useSpacing: true })} method="POST" use:enhance>
  <!-- TODO: move to paraglide messages -->
  <DatePickerField
    name="appointment_date"
    {disabled}
    {form}
    label={'Datum návštěvy'}
    minimumDate={appointmentMinimumDate}
  />

  <RadioGroupField
    name="consent_signed"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Podepsán Souhlas se zapojením do projektu a Souhlas se zpracováním osobních údajů'}
  />

  {#if $formData.consent_signed}
    <div transition:slide>
      <RadioGroupField
        name="meets_project_criteria"
        coerceTo="boolean"
        data={[
          { value: 'true', label: m.yes() },
          { value: 'false', label: m.no() },
        ]}
        {disabled}
        {form}
        label={'Pacient splňuje inkluzní kritéria projektu'}
      />
    </div>

    {#if $formData.meets_project_criteria}
      <div transition:slide>
        <fieldset class={columnsVariants({ number: 1, gap: 2, useSpacing: true })}>
          <legend class={labelVariants()}> Vstupní vyšetření </legend>

          <FormField
            name="post_void_residual_over_100_ml"
            {form}
            label={'Postmikční reziduum nad 100 ml'}
            type="checkbox"
          />
          <FormField name="blood_in_urine" {form} label={'Krev v moči'} type="checkbox" />
          <FormField name="protein_in_urine" {form} label={'Bílkovina v moči'} type="checkbox" />
          <FormField name="sugar_in_urine" {form} label={'Cukr v moči'} type="checkbox" />
        </fieldset>
      </div>

      <div transition:slide>
        <RadioGroupField
          name="clinical_assessment_completed"
          coerceTo="boolean"
          data={[
            { value: 'true', label: m.yes() },
            { value: 'false', label: m.no() },
          ]}
          {disabled}
          {form}
          label={'Bylo provedeno klinické vyšetření k vyloučení sestupu, který by byl kontraindikací k léčbě OAB'}
        />
      </div>

      {#if $formData.clinical_assessment_completed && initialData.gender === 'female'}
        <div transition:slide>
          <RadioGroupField
            name="prolapse_present"
            coerceTo="boolean"
            data={[
              { value: 'true', label: m.yes() },
              { value: 'false', label: m.no() },
            ]}
            {disabled}
            {form}
            label={'Sestup přítomen'}
          />
        </div>
      {/if}

      <div transition:slide>
        <RadioGroupField
          name="stress_test_done"
          coerceTo="boolean"
          data={[
            { value: 'true', label: m.yes() },
            { value: 'false', label: m.no() },
          ]}
          {disabled}
          {form}
          label={'Byl proveden Stres test'}
        />
      </div>

      {#if $formData.stress_test_done}
        <div transition:slide>
          <RadioGroupField
            name="stress_test_result"
            coerceTo="boolean"
            data={[
              { value: 'true', label: 'Pozitivní' },
              { value: 'false', label: 'Negativní' },
            ]}
            {disabled}
            {form}
            label={'Stres test'}
          />
        </div>
      {/if}

      <div transition:slide>
        <RadioGroupField
          name="uti_excluded"
          coerceTo="boolean"
          data={[
            { value: 'true', label: m.yes() },
            { value: 'false', label: m.no() },
          ]}
          {disabled}
          {form}
          label={'Vyloučení infekce močových cest (papírek) - negativní'}
        />
      </div>

      <div transition:slide>
        <FormField
          name="bladder_discomfort_vas"
          {disabled}
          {form}
          label={'Vizuální analogová škála (VAS) obtíží s močovým měchýřem'}
          type="number"
        />
      </div>

      <div transition:slide>
        <SelectField
          name="diagnosis"
          data={getDiagnosesList()}
          {disabled}
          {form}
          label={'Diagnóza'}
          on:select={({ detail: { value } }) => {
            if (value === undefined) {
              $formData.diagnosis = '';
            }
          }}
        />
      </div>

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
            label={'Pacient splňuje kritéria pro farmakologickou léčbu OAB (zároveň není kontraindikace k léčbě)'}
          />
        </div>

        {#if $formData.oab_treatment_criteria_met}
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
        {:else if $formData.oab_treatment_criteria_met === false}
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
          {:else if $formData.reason_treatment_not_started === 'contraindications_to_treatment'}
            <div transition:slide>
              <FormField
                name="treatment_contraindications"
                {disabled}
                {form}
                label={'Uveďte kontraindikaci k léčbě'}
                type="text"
              />
            </div>
          {/if}
        {/if}

        <DatePickerField
          name="follow_up_date"
          {disabled}
          {form}
          label={'Stanovený termín další kontroly pacienta za 3 měsíce'}
          minimumDate={followUpMinimumDate}
        />
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
