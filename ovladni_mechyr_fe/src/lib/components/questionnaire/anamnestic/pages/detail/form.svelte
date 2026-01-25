<script lang="ts">
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import TextareaField from '$lib/components/forms/wrappers/TextareaField.svelte';
  import * as Questionnaire from '$lib/components/questionnaire';
  import * as Card from '$lib/components/ui/card';
  import { labelVariants } from '$lib/components/ui/label/label.svelte';
  import type { UserGender } from '$lib/components/user/types';
  import { setObjectValue } from '$lib/utils/object';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import { persisted } from 'svelte-persisted-store';
  import type { StoresValues } from 'svelte/store';
  import { slide } from 'svelte/transition';
  import { defaults, setError, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { anamnesticFormSchema, type AnamnesticFormSchemaTypes } from './form-schema';
  import type { AnamnesticForm } from './types';

  export let initialData: {
    anamnestic?: AnamnesticForm;
    gender: UserGender;
  };
  export let context: 'read' | 'new' = 'new';
  export let userContext: 'doctor' | 'patient';

  const persistedFormData = persisted<AnamnesticFormSchemaTypes | null>(
    'anamnestic-form-data',
    null
  );

  const defaultFormData = prepareSuperFormDefaultFormData<AnamnesticFormSchemaTypes>({
    gender: initialData.gender,
    age: initialData.anamnestic?.age ?? $persistedFormData?.age ?? DEFAULT_STRING_VALUE,
    height: initialData.anamnestic?.height ?? $persistedFormData?.height ?? DEFAULT_STRING_VALUE,
    weight: initialData.anamnestic?.weight ?? $persistedFormData?.weight ?? DEFAULT_STRING_VALUE,
    on_oab_medication_last_3_months:
      initialData.anamnestic?.on_oab_medication_last_3_months ??
      $persistedFormData?.on_oab_medication_last_3_months ??
      DEFAULT_STRING_VALUE,
    number_of_births:
      initialData.anamnestic?.number_of_births ??
      $persistedFormData?.number_of_births ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    post_menopausal:
      initialData.anamnestic?.post_menopausal ??
      $persistedFormData?.post_menopausal ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    prolapse_diagnosed:
      initialData.anamnestic?.prolapse_diagnosed ??
      $persistedFormData?.prolapse_diagnosed ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    hysterectomy:
      initialData.anamnestic?.hysterectomy ??
      $persistedFormData?.hysterectomy ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    cesarean_section:
      initialData.anamnestic?.cesarean_section ??
      $persistedFormData?.cesarean_section ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    previous_surgery_details:
      initialData.anamnestic?.previous_surgery_details ??
      $persistedFormData?.previous_surgery_details,
    recurrent_infections:
      initialData.anamnestic?.recurrent_infections ??
      $persistedFormData?.recurrent_infections ??
      DEFAULT_STRING_VALUE,
    neurological_surgery_history:
      initialData.anamnestic?.neurological_surgery_history ??
      $persistedFormData?.neurological_surgery_history ??
      (initialData.gender === 'female' ? DEFAULT_STRING_VALUE : undefined),
    cancer_treatment_history:
      initialData.anamnestic?.cancer_treatment_history ??
      $persistedFormData?.cancer_treatment_history ??
      DEFAULT_STRING_VALUE,
    cancer_type_details:
      initialData.anamnestic?.cancer_type_details ?? $persistedFormData?.cancer_type_details,
    drug_allergies:
      initialData.anamnestic?.drug_allergies ??
      $persistedFormData?.drug_allergies ??
      DEFAULT_STRING_VALUE,
    drug_allergies_details:
      initialData.anamnestic?.drug_allergies_details ?? $persistedFormData?.drug_allergies_details,
    glaucoma_or_eye_pressure_meds:
      initialData.anamnestic?.glaucoma_or_eye_pressure_meds ??
      $persistedFormData?.glaucoma_or_eye_pressure_meds ??
      DEFAULT_STRING_VALUE,
    cardiac_conditions:
      initialData.anamnestic?.cardiac_conditions ??
      $persistedFormData?.cardiac_conditions ??
      DEFAULT_STRING_VALUE,
    heart_attack:
      initialData.anamnestic?.heart_attack ??
      $persistedFormData?.heart_attack ??
      DEFAULT_STRING_VALUE,
    arrhythmia:
      initialData.anamnestic?.arrhythmia ?? $persistedFormData?.arrhythmia ?? DEFAULT_STRING_VALUE,
    stroke: initialData.anamnestic?.stroke ?? $persistedFormData?.stroke ?? DEFAULT_STRING_VALUE,
    digestive_problems:
      initialData.anamnestic?.digestive_problems ??
      $persistedFormData?.digestive_problems ??
      DEFAULT_STRING_VALUE,
    dry_mucous_membranes:
      initialData.anamnestic?.dry_mucous_membranes ??
      $persistedFormData?.dry_mucous_membranes ??
      DEFAULT_STRING_VALUE,
    current_medications:
      initialData.anamnestic?.current_medications ??
      $persistedFormData?.current_medications ??
      DEFAULT_STRING_VALUE,
    current_medications_details:
      initialData.anamnestic?.current_medications_details ??
      $persistedFormData?.current_medications_details,
    past_medications:
      initialData.anamnestic?.past_medications ??
      $persistedFormData?.past_medications ??
      DEFAULT_STRING_VALUE,
    past_medications_details:
      initialData.anamnestic?.past_medications_details ??
      $persistedFormData?.past_medications_details,
    back_problems: initialData.anamnestic?.back_problems ?? $persistedFormData?.back_problems,
    breast_cancer: initialData.anamnestic?.breast_cancer ?? $persistedFormData?.breast_cancer,
    cervical_cancer: initialData.anamnestic?.cervical_cancer ?? $persistedFormData?.cervical_cancer,
    depression: initialData.anamnestic?.depression ?? $persistedFormData?.depression,
    diabetes: initialData.anamnestic?.diabetes ?? $persistedFormData?.diabetes,
    endometrial_cancer:
      initialData.anamnestic?.endometrial_cancer ?? $persistedFormData?.endometrial_cancer,
    headaches: initialData.anamnestic?.headaches ?? $persistedFormData?.headaches,
    high_cholesterol:
      initialData.anamnestic?.high_cholesterol ?? $persistedFormData?.high_cholesterol,
    hip_osteoarthritis:
      initialData.anamnestic?.hip_osteoarthritis ?? $persistedFormData?.hip_osteoarthritis,
    hypertension: initialData.anamnestic?.hypertension ?? $persistedFormData?.hypertension,
    hypothyroidism: initialData.anamnestic?.hypothyroidism ?? $persistedFormData?.hypothyroidism,
    intestinal_cancer:
      initialData.anamnestic?.intestinal_cancer ?? $persistedFormData?.intestinal_cancer,
    knee_osteoarthritis:
      initialData.anamnestic?.knee_osteoarthritis ?? $persistedFormData?.knee_osteoarthritis,
    no_illness: initialData.anamnestic?.no_illness ?? $persistedFormData?.no_illness,
    other_cancer: initialData.anamnestic?.other_cancer ?? $persistedFormData?.other_cancer,
    other_psychiatric_conditions:
      initialData.anamnestic?.other_psychiatric_conditions ??
      $persistedFormData?.other_psychiatric_conditions,
    other_surgery: initialData.anamnestic?.other_surgery ?? $persistedFormData?.other_surgery,
    no_surgery: initialData.anamnestic?.no_surgery ?? $persistedFormData?.no_surgery,
    ovarian_cancer: initialData.anamnestic?.ovarian_cancer ?? $persistedFormData?.ovarian_cancer,
    reduced_immunity:
      initialData.anamnestic?.reduced_immunity ?? $persistedFormData?.reduced_immunity,
    surgery_for_benign_prostate_enlargement:
      initialData.anamnestic?.surgery_for_benign_prostate_enlargement ??
      $persistedFormData?.surgery_for_benign_prostate_enlargement,
    surgery_for_bladder_tumor:
      initialData.anamnestic?.surgery_for_bladder_tumor ??
      $persistedFormData?.surgery_for_bladder_tumor,
    surgery_for_prostate_cancer:
      initialData.anamnestic?.surgery_for_prostate_cancer ??
      $persistedFormData?.surgery_for_prostate_cancer,
    surgery_for_urethral_stricture:
      initialData.anamnestic?.surgery_for_urethral_stricture ??
      $persistedFormData?.surgery_for_urethral_stricture,
    surgery_for_urine_leakage:
      initialData.anamnestic?.surgery_for_urine_leakage ??
      $persistedFormData?.surgery_for_urine_leakage,
  });

  const form = superForm(defaults(defaultFormData, zod(anamnesticFormSchema)), {
    SPA: true,
    resetForm: false,
    validators: zodClient(anamnesticFormSchema),
    onChange(event) {
      for (const field of event.paths) {
        $persistedFormData ??= {} as NonNullable<StoresValues<typeof persistedFormData>>;

        // @ts-expect-error Discriminated Unions are not supported.
        setObjectValue($persistedFormData, field, event.get(field));
        $persistedFormData = $persistedFormData;
      }
    },
    async onUpdate({ form, cancel }) {
      if (!form.valid || context !== 'new') return;

      if (
        initialData.gender === 'male' &&
        !form.data.no_surgery &&
        !determineNoSurgeryDisabled(form.data)
      ) {
        return setError(form, 'no_surgery', m.fieldIsRequired());
      } else if (!form.data.no_illness && !determineNoIllnessDisabled(form.data)) {
        return setError(form, 'no_illness', m.fieldIsRequired());
      }

      await handleRequest(
        async () => {
          const { gender, ...restFormData } = form.data;

          await apiClient.POST('/api/v1/anamnestic_forms', {
            body: {
              anamnestic_form: {
                ...restFormData,
                ...{
                  ...(gender === 'female'
                    ? // Ignore male specific options.
                      {
                        surgery_for_benign_prostate_enlargement: undefined,
                        surgery_for_prostate_cancer: undefined,
                        surgery_for_bladder_tumor: undefined,
                        surgery_for_urethral_stricture: undefined,
                        surgery_for_urine_leakage: undefined,
                        other_surgery: undefined,
                        no_surgery: undefined,
                      }
                    : // Ignore female specific options.
                      {
                        number_of_births: undefined,
                        post_menopausal: undefined,
                        prolapse_diagnosed: undefined,
                        hysterectomy: undefined,
                        cesarean_section: undefined,
                        neurological_surgery_history: undefined,
                      }),
                },
                previous_surgery_details: restFormData.other_surgery
                  ? restFormData.previous_surgery_details
                  : undefined,
                cancer_type_details: restFormData.other_cancer
                  ? restFormData.cancer_type_details
                  : undefined,
                drug_allergies_details: restFormData.drug_allergies
                  ? restFormData.drug_allergies_details
                  : undefined,
                current_medications_details: restFormData.current_medications
                  ? restFormData.current_medications_details
                  : undefined,
                past_medications_details: restFormData.past_medications
                  ? restFormData.past_medications_details
                  : undefined,
              },
            },
          });

          $persistedFormData = null;
          queryClient.invalidateQueries();
        },
        { onError: cancel, toastSuccessText: m.successfulAnamnesticFormFill() }
      );
    },
  });

  const { enhance, form: formData } = form;

  $: disabled = context == 'read';
  $: surgeryDisabled = $formData.no_surgery === true;
  $: noSurgeryDisabled = determineNoSurgeryDisabled($formData);
  $: illnessDisabled = $formData.no_illness === true;
  $: noIllnessDisabled = determineNoIllnessDisabled($formData);

  function determineNoSurgeryDisabled(formDataValue: AnamnesticFormSchemaTypes) {
    const hasSurgery = [
      formDataValue.surgery_for_benign_prostate_enlargement,
      formDataValue.surgery_for_prostate_cancer,
      formDataValue.surgery_for_bladder_tumor,
      formDataValue.surgery_for_urethral_stricture,
      formDataValue.surgery_for_urine_leakage,
      formDataValue.other_surgery,
    ].some(Boolean);

    return hasSurgery;
  }

  function determineNoIllnessDisabled(formDataValue: AnamnesticFormSchemaTypes) {
    const hasIllness = [
      formDataValue.hypertension,
      formDataValue.hypothyroidism,
      formDataValue.high_cholesterol,
      formDataValue.diabetes,
      formDataValue.back_problems,
      formDataValue.depression,
      formDataValue.other_psychiatric_conditions,
      formDataValue.reduced_immunity,
      formDataValue.headaches,
      formDataValue.hip_osteoarthritis,
      formDataValue.knee_osteoarthritis,
    ].some(Boolean);

    return hasIllness;
  }
</script>

<form class={columnsVariants({ number: 0, gap: 6, useSpacing: true })} method="POST" use:enhance>
  <FormField name="age" {disabled} {form} label={m.age()} type="number" />

  <!-- TODO: move to paraglide messages -->
  <FormField name="height" {disabled} {form} label={'Výška (cm)'} type="number" />

  <FormField name="weight" {disabled} {form} label={'Váha (kg)'} type="number" />

  <RadioGroupField
    name="on_oab_medication_last_3_months"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Bral/a jste v posledních 3 měsících léky na hyperaktivní močový měchýř'}
  />

  {#if initialData.gender === 'female'}
    <FormField name="number_of_births" {disabled} {form} label={'Počet porodů'} type="number" />

    <RadioGroupField
      name="post_menopausal"
      coerceTo="boolean"
      data={[
        { value: 'true', label: m.yes() },
        { value: 'false', label: m.no() },
      ]}
      {disabled}
      {form}
      label={'Jste již po přechodu (v menopauze)?'}
    />

    <RadioGroupField
      name="prolapse_diagnosed"
      coerceTo="boolean"
      data={[
        { value: 'true', label: m.yes() },
        { value: 'false', label: m.no() },
      ]}
      {disabled}
      {form}
      label={'Byla u Vás stanovena diagnóza sestupu dělohy nebo poševních stěn?'}
    />

    <RadioGroupField
      name="hysterectomy"
      coerceTo="boolean"
      data={[
        { value: 'true', label: m.yes() },
        { value: 'false', label: m.no() },
      ]}
      {disabled}
      {form}
      label={'Proběhlo u Vás odstranění dělohy?'}
    />

    <RadioGroupField
      name="cesarean_section"
      coerceTo="string"
      data={[
        { value: 'true', label: m.yes() },
        { value: 'false', label: m.no() },
        { value: 'no_birth', label: 'V minulosti neproběhl žádný porod' },
      ]}
      {disabled}
      {form}
      label={'Pokud u Vás proběhl v minulosti porod či více porodů. Proběhl alespoň jeden z nich císařským řezem?'}
    />
  {/if}

  {#if initialData.gender === 'male'}
    <fieldset class={columnsVariants({ number: 1, gap: 2, useSpacing: true })}>
      <legend class={labelVariants()}>
        {'Prodělal jste předchozí operaci:'}&nbsp;<Form.RequiredIndicator />
      </legend>

      <FormField
        name="surgery_for_benign_prostate_enlargement"
        disabled={disabled || surgeryDisabled}
        {form}
        label={'Operaci pro nezhoubné zvětšení prostaty'}
        type="checkbox"
      />
      <FormField
        name="surgery_for_prostate_cancer"
        disabled={disabled || surgeryDisabled}
        {form}
        label={'Operaci pro rakovinu prostaty'}
        type="checkbox"
      />
      <FormField
        name="surgery_for_bladder_tumor"
        disabled={disabled || surgeryDisabled}
        {form}
        label={'Operaci pro nádor močového měchýře'}
        type="checkbox"
      />
      <FormField
        name="surgery_for_urethral_stricture"
        disabled={disabled || surgeryDisabled}
        {form}
        label={'Operaci pro zúženinu močové trubice'}
        type="checkbox"
      />
      <FormField
        name="surgery_for_urine_leakage"
        disabled={disabled || surgeryDisabled}
        {form}
        label={'Operaci úniku moči'}
        type="checkbox"
      />
      <FormField
        name="other_surgery"
        disabled={disabled || surgeryDisabled}
        {form}
        label={'Jiné'}
        type="checkbox"
      />
      <FormField
        name="no_surgery"
        disabled={disabled || noSurgeryDisabled}
        {form}
        label={'Žádné z uvedených'}
        type="checkbox"
      />
    </fieldset>

    {#if $formData.other_surgery}
      <div transition:slide>
        <TextareaField
          name="previous_surgery_details"
          {disabled}
          {form}
          label={'Specifikujte předchozí operaci'}
        />
      </div>
    {/if}
  {/if}

  <RadioGroupField
    name="recurrent_infections"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Trpíte opakovanými (alespoň 2x za rok) infekcemi močových cest (močového měchýře)?'}
  />

  {#if initialData.gender === 'female'}
    <RadioGroupField
      name="neurological_surgery_history"
      coerceTo="boolean"
      data={[
        { value: 'true', label: m.yes() },
        { value: 'false', label: m.no() },
      ]}
      {disabled}
      {form}
      label={'Podstoupil/a jste v minulosti operaci močové trubice nebo močového měchýře?'}
    />
  {/if}

  <fieldset class={columnsVariants({ number: 1, gap: 2, useSpacing: true })}>
    <legend class={labelVariants()}>
      {'Léčíte se pro některé z uvedených onemocnění?'}&nbsp;<Form.RequiredIndicator />
    </legend>

    <FormField
      name="hypertension"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Hypertenze (vysoký krevní tlak)'}
      type="checkbox"
    />
    <FormField
      name="hypothyroidism"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Snížená funkce štítné žlázy'}
      type="checkbox"
    />
    <FormField
      name="high_cholesterol"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Zvýšená hladina cholesterolu'}
      type="checkbox"
    />
    <FormField
      name="diabetes"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Cukrovka'}
      type="checkbox"
    />
    <FormField
      name="back_problems"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Problémy se zády'}
      type="checkbox"
    />
    <FormField
      name="depression"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Deprese'}
      type="checkbox"
    />
    <FormField
      name="other_psychiatric_conditions"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Jiná psychiatrická onemocnění'}
      type="checkbox"
    />
    <FormField
      name="reduced_immunity"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Snížená imunita'}
      type="checkbox"
    />
    <FormField
      name="headaches"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Bolesti hlavy'}
      type="checkbox"
    />
    <FormField
      name="hip_osteoarthritis"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Artróza kyčlí'}
      type="checkbox"
    />
    <FormField
      name="knee_osteoarthritis"
      disabled={disabled || illnessDisabled}
      {form}
      label={'Artróza kolen'}
      type="checkbox"
    />
    <FormField
      name="no_illness"
      disabled={disabled || noIllnessDisabled}
      {form}
      label={'Žádné z uvedených'}
      type="checkbox"
    />
  </fieldset>

  <RadioGroupField
    name="cancer_treatment_history"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Léčíte se nebo jste se léčil/a s onkologickým onemocněním?'}
  />

  {#if $formData.cancer_treatment_history}
    <div transition:slide>
      <fieldset class={columnsVariants({ number: 1, gap: 2, useSpacing: true })}>
        <legend class={labelVariants()}>
          {'Se kterým z uvedených onkologických onemocnění se léčíte nebo jste se léčil/a?'}
        </legend>

        <FormField
          name="cervical_cancer"
          {disabled}
          {form}
          label={'Rakovina děložního čípku'}
          type="checkbox"
        />
        <FormField
          name="endometrial_cancer"
          {disabled}
          {form}
          label={'Rakovina sliznice dělohy'}
          type="checkbox"
        />
        <FormField
          name="ovarian_cancer"
          {disabled}
          {form}
          label={'Rakovina vaječníků'}
          type="checkbox"
        />
        <FormField name="breast_cancer" {disabled} {form} label={'Rakovina prsu'} type="checkbox" />
        <FormField
          name="intestinal_cancer"
          {disabled}
          {form}
          label={'Rakovina střev'}
          type="checkbox"
        />
        <FormField
          name="other_cancer"
          {disabled}
          {form}
          label={'Jiná onkologická onemocnění'}
          type="checkbox"
        />
      </fieldset>
    </div>

    {#if $formData.other_cancer}
      <div transition:slide>
        <TextareaField
          name="cancer_type_details"
          {disabled}
          {form}
          label={'Uveďte onkologické onemocnění'}
        />
      </div>
    {/if}
  {/if}

  <RadioGroupField
    name="drug_allergies"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Alergie na léky'}
  />

  {#if $formData.drug_allergies}
    <div transition:slide>
      <TextareaField
        name="drug_allergies_details"
        {disabled}
        {form}
        label={'Specifikujte léky, na které jste alergický/á.'}
      />
    </div>
  {/if}

  <RadioGroupField
    name="glaucoma_or_eye_pressure_meds"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Trpíte zeleným zákalem (glaukomem) nebo používáte léky na nitrooční tlak?'}
  />

  <RadioGroupField
    name="cardiac_conditions"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Léčíte se se srdečním onemocněním?'}
  />

  <RadioGroupField
    name="heart_attack"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Prodělal/a jste infarkt?'}
  />

  <RadioGroupField
    name="arrhythmia"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Trpíte poruchou srdečního rytmu?'}
  />

  <RadioGroupField
    name="stroke"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Prodělal/a jste cévní mozkovou příhodu (mrtvice)?'}
  />

  <RadioGroupField
    name="digestive_problems"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Máte zažívací obtíže (zácpa, průjem)?'}
  />

  <RadioGroupField
    name="dry_mucous_membranes"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Trpíte na suchost sliznic (například sucho v ústech)?'}
  />

  <RadioGroupField
    name="current_medications"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Užíváte v současnosti nějaké léky?'}
  />

  {#if $formData.current_medications}
    <div transition:slide>
      <TextareaField
        name="current_medications_details"
        {disabled}
        {form}
        label={'Uveďte názvy léků, které v současnosti užíváte'}
      />
    </div>
  {/if}

  <RadioGroupField
    name="past_medications"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {disabled}
    {form}
    label={'Užíval/a jste v minulosti (před více než 3 měsíci) léky na hyperaktivní močový měchýř?'}
  />

  {#if $formData.past_medications}
    <div transition:slide>
      <TextareaField
        name="past_medications_details"
        {disabled}
        {form}
        label={'Uveďte název léku používaného pro léčbu hyperaktivního močového měchýře'}
      />
    </div>
  {/if}

  {#if userContext === 'patient'}
    <Button {disabled} type="submit">
      {m.save()}
    </Button>

    {#if disabled}
      <div transition:slide>
        <Card.Root>
          <Card.Content>
            <Questionnaire.Results.Explanations.Description>
              {'Nyní můžete pokračovat vytvořením mikčního deníku'}
            </Questionnaire.Results.Explanations.Description>
          </Card.Content>
        </Card.Root>
      </div>
    {/if}
  {/if}

  <Form.RequiredIndicatorInfo />
</form>
