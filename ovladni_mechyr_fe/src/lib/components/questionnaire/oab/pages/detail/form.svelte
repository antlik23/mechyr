<script lang="ts">
  import type { StoresValues } from 'svelte/store';
  import type { OabForm } from './types';
  import type { UserGender } from '$lib/components/user/types';
  import { slide } from 'svelte/transition';
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { persisted } from 'svelte-persisted-store';
  import { oabFormSchema, type OabFormSchemaTypes } from './form-schema';
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import { handleRequest } from '$lib/utils/request';
  import { shouldContinueFromOabForm } from './index';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import * as Questionnaire from '$lib/components/questionnaire';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';

  export let initialData: {
    oab?: OabForm;
    gender: UserGender;
  };
  export let context: 'read' | 'new' = 'new';
  export let userContext: 'doctor' | 'patient';
  export let continueLink: string | undefined = undefined;

  const persistedFormData = persisted<OabFormSchemaTypes | null>('oab-form-data', null);

  const defaultFormData = prepareSuperFormDefaultFormData<OabFormSchemaTypes>({
    daytime_urination_frequency:
      initialData.oab?.daytime_urination_frequency ??
      $persistedFormData?.daytime_urination_frequency ??
      DEFAULT_STRING_VALUE,
    unpleasant_urination_urge:
      initialData.oab?.unpleasant_urination_urge ??
      $persistedFormData?.unpleasant_urination_urge ??
      DEFAULT_STRING_VALUE,
    sudden_urination_urge:
      initialData.oab?.sudden_urination_urge ??
      $persistedFormData?.sudden_urination_urge ??
      DEFAULT_STRING_VALUE,
    occasional_leak:
      initialData.oab?.occasional_leak ??
      $persistedFormData?.occasional_leak ??
      DEFAULT_STRING_VALUE,
    nighttime_urination:
      initialData.oab?.nighttime_urination ??
      $persistedFormData?.nighttime_urination ??
      DEFAULT_STRING_VALUE,
    waking_up_to_urinate:
      initialData.oab?.waking_up_to_urinate ??
      $persistedFormData?.waking_up_to_urinate ??
      DEFAULT_STRING_VALUE,
    uncontrollable_urge:
      initialData.oab?.uncontrollable_urge ??
      $persistedFormData?.uncontrollable_urge ??
      DEFAULT_STRING_VALUE,
    leak_due_to_intense_urge:
      initialData.oab?.leak_due_to_intense_urge ??
      $persistedFormData?.leak_due_to_intense_urge ??
      DEFAULT_STRING_VALUE,
  });

  const form = superForm(defaults(defaultFormData, zod(oabFormSchema)), {
    SPA: true,
    resetForm: false,
    validators: zodClient(oabFormSchema),
    onChange(event) {
      for (const field of event.paths) {
        $persistedFormData ??= {} as NonNullable<StoresValues<typeof persistedFormData>>;

        $persistedFormData[field] = event.get(field);
      }
    },
    async onUpdate({ form, cancel }) {
      if (!form.valid || context !== 'new') return;

      await handleRequest(
        async () => {
          await apiClient.POST('/api/v1/oab_forms', { body: { oab_form: form.data } });

          $persistedFormData = null;
          queryClient.invalidateQueries();
        },
        { onError: cancel, toastSuccessText: m.successfulOabFormFill() }
      );
    },
  });

  const { enhance } = form;

  $: disabled = context == 'read';
  $: shouldContinue = shouldContinueFromOabForm(Number(initialData.oab?.total_score));
</script>

<form class={columnsVariants({ number: 0, gap: 6 })} method="POST" use:enhance>
  <RadioGroupField
    name="daytime_urination_frequency"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.frequentUrinationDuringDay()}
  />

  <RadioGroupField
    name="unpleasant_urination_urge"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.unpleasantUrgeToUrinate()}
  />

  <RadioGroupField
    name="sudden_urination_urge"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.suddenUrgeToUrinateWithoutWarning()}
  />

  <RadioGroupField
    name="occasional_leak"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.occasionalSmallUrineLeakage()}
  />

  <RadioGroupField
    name="nighttime_urination"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.urinationDuringNight()}
  />

  <RadioGroupField
    name="waking_up_to_urinate"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.wakingUpAtNightToUrinate()}
  />

  <RadioGroupField
    name="uncontrollable_urge"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.uncontrollableUrgeToUrinate()}
  />

  <RadioGroupField
    name="leak_due_to_intense_urge"
    coerceTo="number"
    data={[
      { value: '0', label: m.atAll() },
      { value: '1', label: m.veryLittle() },
      { value: '2', label: m.aLittleMore() },
      { value: '3', label: m.prettyMuchYes() },
      { value: '4', label: m.aLot() },
      { value: '5', label: m.reallyALot() },
    ]}
    {disabled}
    {form}
    label={m.urineLeakageAfterIntenseUnpleasantUrgeToUrinate()}
  />

  {#if initialData.oab?.total_score !== undefined && initialData.oab?.completion_timestamp}
    <div transition:slide>
      <Questionnaire.UiWrappers.ResultsCard
        completedDate={initialData.oab.completion_timestamp}
        points={initialData.oab.total_score}
      >
        {#if shouldContinue}
          <Questionnaire.Results.Explanations.Title>
            {m.orMorePoints({ pointsAmount: 8 })}:
          </Questionnaire.Results.Explanations.Title>

          <Questionnaire.Results.Explanations.Description>
            {m.yourScoreMayMeanYouHaveAConditionCalledOveractiveBladderOab()}

            {#if initialData.gender === 'male'}
              <!-- TODO: move to paraglide messages -->
              {'Pro tento problém existuje účinná terapie, je tedy vhodné Váš zdravotní stav konzultovat s lékařem (urologem), proto prosíme pokračujte ve vyplňování dalších formulářů.'}
            {:else}
              {m.thereIsAnEffectiveTherapyForThisProblemSoItIsAdvisableToConsultADoctorUrologistOrUrogynecologistRegardingYourHealthConditionSoPleaseContinueToFillOutTheOtherForms()}
            {/if}
          </Questionnaire.Results.Explanations.Description>
        {:else}
          <Questionnaire.Results.Explanations.Title>
            {m.orLessPoints({ pointsAmount: 7 })}:
          </Questionnaire.Results.Explanations.Title>

          <Questionnaire.Results.Explanations.Description>
            {m.yourScoreMeansYouDonTHaveAConditionCalledOveractiveBladderOab()}

            {#if initialData.gender === 'male'}
              {'V případě jakýchkoliv pochybností o Vašem stavu je jistě možné konzultovat Váš zdravotní stav s lékařem (urologem).'}
            {:else}
              {m.inCaseOfAnyDoubtsAboutYourConditionItIsCertainlyPossibleToConsultYourMedicalConditionWithADoctorUrologistOrUrogynecologist()}
            {/if}

            <p slot="error">
              Bohužel nesplňujete kritéria pro pokračování v projektu. Tímto Vaše účast v projektu
              končí, děkujeme.
            </p>
          </Questionnaire.Results.Explanations.Description>
        {/if}
      </Questionnaire.UiWrappers.ResultsCard>
    </div>
  {/if}

  {#if context === 'new'}
    <Button type="submit">
      {m.save()}
    </Button>
  {:else if context === 'read' && userContext === 'patient'}
    <Button
      disabled={!shouldContinue}
      href={shouldContinue && continueLink ? continueLink : undefined}
    >
      {m.Continue()}
    </Button>
  {/if}

  <Form.RequiredIndicatorInfo />
</form>
