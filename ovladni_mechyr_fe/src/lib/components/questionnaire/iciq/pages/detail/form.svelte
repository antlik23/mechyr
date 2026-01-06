<script lang="ts">
  import type { StoresValues } from 'svelte/store';
  import type { IciqForm } from './types';
  import { slide } from 'svelte/transition';
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { persisted } from 'svelte-persisted-store';
  import { iciqFormSchema, leakageSeverity, type IciqFormSchemaTypes } from './form-schema';
  import { setObjectValue } from '$lib/utils/object';
  import { handleRequest } from '$lib/utils/request';
  import { apiClient } from '$lib/api/api';
  import { shouldContinueFromIciqForm } from './index';
  import { queryClient } from '$lib/api/queries';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import { labelVariants } from '$lib/components/ui/label/label.svelte';
  import * as Questionnaire from '$lib/components/questionnaire';
  import * as Form from '$lib/components/form';
  import SliderField from '$lib/components/forms/wrappers/SliderField.svelte';

  export let initialData: {
    iciq?: IciqForm;
  } = {};
  export let context: 'read' | 'new' = 'new';
  export let userContext: 'doctor' | 'patient';
  export let continueLink: string | undefined = undefined;

  const persistedFormData = persisted<IciqFormSchemaTypes | null>('iciq-form-data', null);

  const defaultFormData = prepareSuperFormDefaultFormData<IciqFormSchemaTypes>({
    leakage_frequency:
      initialData.iciq?.leakage_frequency ??
      $persistedFormData?.leakage_frequency ??
      DEFAULT_STRING_VALUE,
    leakage_assessment:
      initialData.iciq?.leakage_assessment ??
      $persistedFormData?.leakage_assessment ??
      DEFAULT_STRING_VALUE,
    leakage_severity:
      initialData.iciq?.leakage_severity ??
      $persistedFormData?.leakage_severity ??
      DEFAULT_STRING_VALUE,
    never_leaks: initialData.iciq?.never_leaks ?? $persistedFormData?.never_leaks,
    leaks_before_reaching_toilet:
      initialData.iciq?.leaks_before_reaching_toilet ??
      $persistedFormData?.leaks_before_reaching_toilet,
    leaks_when_coughing_or_sneezing:
      initialData.iciq?.leaks_when_coughing_or_sneezing ??
      $persistedFormData?.leaks_when_coughing_or_sneezing,
    leaks_during_sleep:
      initialData.iciq?.leaks_during_sleep ?? $persistedFormData?.leaks_during_sleep,
    leaks_during_physical_activity:
      initialData.iciq?.leaks_during_physical_activity ??
      $persistedFormData?.leaks_during_physical_activity,
    leaks_after_urinating_and_dressing:
      initialData.iciq?.leaks_after_urinating_and_dressing ??
      $persistedFormData?.leaks_after_urinating_and_dressing,
    leaks_for_unknown_reasons:
      initialData.iciq?.leaks_for_unknown_reasons ?? $persistedFormData?.leaks_for_unknown_reasons,
    constant_leakage: initialData.iciq?.constant_leakage ?? $persistedFormData?.constant_leakage,
  });

  const form = superForm(defaults(defaultFormData, zod(iciqFormSchema)), {
    SPA: true,
    resetForm: false,
    validators: zodClient(iciqFormSchema),
    onChange(event) {
      for (const field of event.paths) {
        $persistedFormData ??= {} as NonNullable<StoresValues<typeof persistedFormData>>;

        setObjectValue($persistedFormData, field, event.get(field));
        $persistedFormData = $persistedFormData;
      }
    },
    async onUpdate({ form, cancel }) {
      if (!form.valid || context !== 'new') return;

      await handleRequest(
        async () => {
          await apiClient.POST('/api/v1/iciq_forms', { body: { iciq_form: form.data } });

          $persistedFormData = null;
          queryClient.invalidateQueries();
        },
        { onError: cancel, toastSuccessText: m.successfulIciqFormFill() }
      );
    },
  });

  const { enhance } = form;

  $: disabled = context == 'read';
  $: shouldContinue = shouldContinueFromIciqForm(Number(initialData.iciq?.total_score));
</script>

<form class={columnsVariants({ number: 1, gap: 6 })} method="POST" use:enhance>
  <RadioGroupField
    name="leakage_frequency"
    coerceTo="number"
    data={[
      { value: '0', label: m.never() },
      { value: '1', label: m.aboutOnceAWeekOrLessOften() },
      { value: '2', label: m.twoOrThreeTimesAWeek() },
      { value: '3', label: m.aboutOnceADay() },
      { value: '4', label: m.severalTimesADay() },
      { value: '5', label: m.steadily() },
    ]}
    {disabled}
    {form}
    label={m.howOftenDoYouLeakUrine()}
  />

  <RadioGroupField
    name="leakage_assessment"
    coerceTo="number"
    data={[
      { value: '0', label: m.none() },
      { value: '1', label: m.smallAmount() },
      { value: '2', label: m.moderateAmount() },
      { value: '3', label: m.largeAmount() },
    ]}
    {disabled}
    {form}
    label={[
      m.weWouldLikeToKnowHowMuchUrineYouLeakInYourOpinion(),
      m.howMuchUrineDoYouUsuallyLeakWithOrWithoutProtectiveEquipment(),
    ].join(' ')}
  />

  <SliderField
    name="leakage_severity"
    {disabled}
    {form}
    label={[
      m.toWhatExtentDoesLeakageOfUrineUsuallyBotherYouInYourDailyLife(),
      m.pleaseChooseANumberBetweenWithDescription({
        minAmount: leakageSeverity.min,
        minAmountLabel: m.notAtAll().toLowerCase(),
        maxAmount: leakageSeverity.max,
        maxAmountLabel: m.very().toLowerCase(),
      }),
    ].join(' ')}
    max={leakageSeverity.max}
    min={leakageSeverity.min}
    step={1}
  />

  <fieldset class={columnsVariants({ number: 1, gap: 2, useSpacing: true })}>
    <legend class={labelVariants()}>
      {m.whenDoesItHappenThatUrineLeaks()}
      {m.pleaseTickAllBoxesThatApplyToYou()}
    </legend>

    <FormField
      name="never_leaks"
      {disabled}
      {form}
      label={`${m.never()} - ${m.urineDoesNotLeakOnItsOwn().toLowerCase()}`}
      type="checkbox"
    />
    <FormField
      name="leaks_before_reaching_toilet"
      {disabled}
      {form}
      label={m.leaksBeforeIHaveTimeToGetToTheToilet()}
      type="checkbox"
    />
    <FormField
      name="leaks_when_coughing_or_sneezing"
      {disabled}
      {form}
      label={m.leaksWhenCoughingOrSneezing()}
      type="checkbox"
    />
    <FormField
      name="leaks_during_sleep"
      {disabled}
      {form}
      label={m.leaksInMySleep()}
      type="checkbox"
    />
    <FormField
      name="leaks_during_physical_activity"
      {disabled}
      {form}
      label={m.leaksDuringPhysicalActivityOrExercise()}
      type="checkbox"
    />
    <FormField
      name="leaks_after_urinating_and_dressing"
      {disabled}
      {form}
      label={m.leaksAfterIPeedAndGotDressed()}
      type="checkbox"
    />
    <FormField
      name="leaks_for_unknown_reasons"
      {disabled}
      {form}
      label={m.leaksForUnknownReasons()}
      type="checkbox"
    />
    <FormField
      name="constant_leakage"
      {disabled}
      {form}
      label={m.leaksSteadily()}
      type="checkbox"
    />
  </fieldset>

  {#if initialData.iciq?.total_score !== undefined && initialData.iciq?.completion_timestamp}
    <div transition:slide>
      <Questionnaire.UiWrappers.ResultsCard
        completedDate={initialData.iciq.completion_timestamp}
        points={initialData.iciq.total_score}
      />
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
