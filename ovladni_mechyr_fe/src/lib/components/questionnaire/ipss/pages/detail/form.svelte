<script lang="ts">
  import type { StoresValues } from 'svelte/store';
  import type { IpssForm } from './types';
  import { slide } from 'svelte/transition';
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { persisted } from 'svelte-persisted-store';
  import { ipssFormSchema, type IpssFormSchemaTypes } from './form-schema';
  import { handleRequest } from '$lib/utils/request';
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import { shouldContinueFromIpssForm } from './index';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Questionnaire from '$lib/components/questionnaire';
  import * as Form from '$lib/components/form';

  export let initialData: {
    ipss?: IpssForm;
  } = {};
  export let context: 'read' | 'new' = 'new';
  export let userContext: 'doctor' | 'patient';
  export let continueLink: string | undefined = undefined;

  const persistedFormData = persisted<IpssFormSchemaTypes | null>('ipss-form-data', null);

  const defaultFormData = prepareSuperFormDefaultFormData<IpssFormSchemaTypes>({
    incomplete_emptying:
      initialData.ipss?.incomplete_emptying ??
      $persistedFormData?.incomplete_emptying ??
      DEFAULT_STRING_VALUE,
    frequency: initialData.ipss?.frequency ?? $persistedFormData?.frequency ?? DEFAULT_STRING_VALUE,
    intermittent_urination:
      initialData.ipss?.intermittent_urination ??
      $persistedFormData?.intermittent_urination ??
      DEFAULT_STRING_VALUE,
    urgency: initialData.ipss?.urgency ?? $persistedFormData?.urgency ?? DEFAULT_STRING_VALUE,
    weak_stream:
      initialData.ipss?.weak_stream ?? $persistedFormData?.weak_stream ?? DEFAULT_STRING_VALUE,
    straining: initialData.ipss?.straining ?? $persistedFormData?.straining ?? DEFAULT_STRING_VALUE,
    nocturnal_urination:
      initialData.ipss?.nocturnal_urination ??
      $persistedFormData?.nocturnal_urination ??
      DEFAULT_STRING_VALUE,
    quality_of_life:
      initialData.ipss?.quality_of_life ??
      $persistedFormData?.quality_of_life ??
      DEFAULT_STRING_VALUE,
  });

  const form = superForm(defaults(defaultFormData, zod(ipssFormSchema)), {
    SPA: true,
    resetForm: false,
    validators: zodClient(ipssFormSchema),
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
          await apiClient.POST('/api/v1/ipss_forms', { body: { ipss_form: form.data } });

          $persistedFormData = null;
          queryClient.invalidateQueries();
        },
        { onError: cancel, toastSuccessText: m.successfulIpssFormFill() }
      );
    },
  });

  const { enhance } = form;

  $: disabled = context == 'read';
  $: shouldContinue = shouldContinueFromIpssForm(Number(initialData.ipss?.total_score));
</script>

<form class={columnsVariants({ number: 1, gap: 6 })} method="POST" use:enhance>
  <RadioGroupField
    name="incomplete_emptying"
    coerceTo="number"
    data={[
      { value: '0', label: m.notAtAll() },
      { value: '1', label: m.aboutOneInFiveCases() },
      { value: '2', label: m.inLessThanHalfOfTheCases() },
      { value: '3', label: m.aboutHalfOfTheTime() },
      { value: '4', label: m.inMoreThanHalfOfTheCases() },
      { value: '5', label: m.almostAlways() },
    ]}
    {disabled}
    {form}
    label={[
      m.incompleteEmptying(),
      m.howOftenDuringTheLastMonthDidYouFeelLikeYourBladderWasNotEmptyAfterUrinating(),
    ].join(' ')}
  />

  <RadioGroupField
    name="frequency"
    coerceTo="number"
    data={[
      { value: '0', label: m.notAtAll() },
      { value: '1', label: m.aboutOneInFiveCases() },
      { value: '2', label: m.inLessThanHalfOfTheCases() },
      { value: '3', label: m.aboutHalfOfTheTime() },
      { value: '4', label: m.inMoreThanHalfOfTheCases() },
      { value: '5', label: m.almostAlways() },
    ]}
    {disabled}
    {form}
    label={[
      m.frequency(),
      m.duringTheLastMonthHowOftenDidYouHaveToUrinateAgainSoonerThanTwoHoursAfterThePreviousUrination(),
    ].join(' ')}
  />

  <RadioGroupField
    name="intermittent_urination"
    coerceTo="number"
    data={[
      { value: '0', label: m.notAtAll() },
      { value: '1', label: m.aboutOneInFiveCases() },
      { value: '2', label: m.inLessThanHalfOfTheCases() },
      { value: '3', label: m.aboutHalfOfTheTime() },
      { value: '4', label: m.inMoreThanHalfOfTheCases() },
      { value: '5', label: m.almostAlways() },
    ]}
    {disabled}
    {form}
    label={[
      m.intermittentUrination(),
      m.howOftenDuringThePastMonthHaveYouNoticedThatUrinationHasStoppedAndStartedAgainSeveralTimes(),
    ].join(' ')}
  />

  <RadioGroupField
    name="urgency"
    coerceTo="number"
    data={[
      { value: '0', label: m.notAtAll() },
      { value: '1', label: m.aboutOneInFiveCases() },
      { value: '2', label: m.inLessThanHalfOfTheCases() },
      { value: '3', label: m.aboutHalfOfTheTime() },
      { value: '4', label: m.inMoreThanHalfOfTheCases() },
      { value: '5', label: m.almostAlways() },
    ]}
    {disabled}
    {form}
    label={[
      m.urgency(),
      m.howOftenDuringTheLastMonthHaveYouDelayedUrinationJustBecauseOfDifficulty(),
    ].join(' ')}
  />

  <RadioGroupField
    name="weak_stream"
    coerceTo="number"
    data={[
      { value: '0', label: m.notAtAll() },
      { value: '1', label: m.aboutOneInFiveCases() },
      { value: '2', label: m.inLessThanHalfOfTheCases() },
      { value: '3', label: m.aboutHalfOfTheTime() },
      { value: '4', label: m.inMoreThanHalfOfTheCases() },
      { value: '5', label: m.almostAlways() },
    ]}
    {disabled}
    {form}
    label={[
      m.weakeningOfUrineFlow(),
      m.howOftenDuringTheLastMonthHaveYouHadAWeakStreamOfUrine(),
    ].join(' ')}
  />

  <RadioGroupField
    name="straining"
    coerceTo="number"
    data={[
      { value: '0', label: m.notAtAll() },
      { value: '1', label: m.aboutOneInFiveCases() },
      { value: '2', label: m.inLessThanHalfOfTheCases() },
      { value: '3', label: m.aboutHalfOfTheTime() },
      { value: '4', label: m.inMoreThanHalfOfTheCases() },
      { value: '5', label: m.almostAlways() },
    ]}
    {disabled}
    {form}
    label={`${m.pressureToUrinate()} ${m.howOftenInTheLastMonthDidYouHaveToPushToUrinate()}`}
  />

  <RadioGroupField
    name="nocturnal_urination"
    coerceTo="number"
    data={[
      { value: '0', label: m.never() },
      { value: '1', label: m.timesAmount({ amount: 1 }) },
      { value: '2', label: m.timesAmount({ amount: 2 }) },
      { value: '3', label: m.timesAmount({ amount: 3 }) },
      { value: '4', label: m.timesAmount({ amount: 4 }) },
      { value: '5', label: m.timesAmountOrMore({ amount: 5 }) },
    ]}
    {disabled}
    {form}
    label={[
      m.nocturnalUrination(),
      m.howOftenDuringTheLastMonthDidYouHaveToGetUpAtNightToUrinateWithDescription(),
    ].join(' ')}
  />

  <RadioGroupField
    name="quality_of_life"
    coerceTo="number"
    data={[
      { value: '0', label: m.great() },
      { value: '1', label: m.good() },
      { value: '2', label: m.mostlyGood() },
      { value: '3', label: m.alternately() },
      { value: '4', label: m.mostlyWrong() },
      { value: '5', label: m.poorly() },
      { value: '6', label: m.unbearably() },
    ]}
    {disabled}
    {form}
    label={[
      m.assessmentOfQualityOfLifeDueToVoidingDifficulties(),
      m.howWouldYouFeelIfYouHadTheSameDifficultyUrinatingInTheFutureAsYouDoNow(),
    ].join(' ')}
  />

  {#if initialData.ipss?.total_score !== undefined && initialData.ipss.completion_timestamp}
    <div transition:slide>
      <Questionnaire.UiWrappers.ResultsCardWithQualityIndex
        completedDate={initialData.ipss.completion_timestamp}
        points={initialData.ipss.total_score}
        qualityIndex={initialData.ipss.life_quality_index}
      >
        {#if shouldContinue}
          <Questionnaire.Results.Explanations.Title>
            {m.orLessPoints({ pointsAmount: 7 })}:
          </Questionnaire.Results.Explanations.Title>

          <!-- TODO: move to paraglide messages -->
          <Questionnaire.Results.Explanations.Description>
            {'Výsledek IPSS nesvědčí pro prostatické potíže. Může však jít o jiné onemocnění prostaty, které je potřeba léčit. V případě jakýchkoliv obtíží nebo pochybností je doporučeno kontaktovat lékaře. Prosíme, pokračujte ve vyplňování dalších formulářů'}
          </Questionnaire.Results.Explanations.Description>
        {:else}
          <Questionnaire.Results.Explanations.Title>
            {m.orMorePoints({ pointsAmount: 8 })}:
          </Questionnaire.Results.Explanations.Title>

          <Questionnaire.Results.Explanations.Description>
            {'Výsledek IPSS svědčí pro podezření na prostatické potíže. Kontaktujte prosím urologa.'}

            <p slot="error">
              Bohužel nesplňujete kritéria pro pokračování v projektu. Tímto Vaše účast v projektu
              končí, děkujeme.
            </p>
          </Questionnaire.Results.Explanations.Description>
        {/if}
      </Questionnaire.UiWrappers.ResultsCardWithQualityIndex>
    </div>
  {/if}

  {#if context === 'new'}
    <Button type="submit">
      {m.save()}
    </Button>
  {:else if context === 'read' && shouldContinue && userContext === 'patient'}
    <p transition:slide>
      {'Pro potvrzení diagnózy lékařem je potřeba vyplnit všechny údaje v následujícím anamnestickém dotazníku a mikční deník. Poté je možné se objednat k lékaři, který zhodnotí Vaši diagnózu na základě Vámi uvedených údajů.'}
    </p>

    <Button href={continueLink}>
      {m.doYouWishToSeeADoctor()}
    </Button>
  {/if}

  <Form.RequiredIndicatorInfo />
</form>
