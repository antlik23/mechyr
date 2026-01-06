<script lang="ts">
  import DoctorImg from '$lib/assets/images/doktorka.png?url';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Alert from '$lib/components/ui/alert';
  import * as Card from '$lib/components/ui/card';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { CopyIcon } from 'lucide-svelte';
  import { onMount, type ComponentProps } from 'svelte';
  import { clipboard as createClipboard } from 'svelte-legos';
  import { toast } from 'svelte-sonner';
  import { objectEntries } from 'tsafe';
  import type { Except } from 'type-fest';
  import Form from './form.svelte';
  import type {
    DetailQueryResponseProperties,
    IciqQueryResponseProperties,
    IpssQueryResponseProperties,
    QueryResponseProperties,
  } from './types';

  export let response: QueryResponseProperties | DetailQueryResponseProperties;
  export let iciqResponse: IciqQueryResponseProperties | undefined = undefined;
  export let ipssResponse: IpssQueryResponseProperties | undefined = undefined;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'] | undefined = undefined;
  export let userContext: ComponentProps<Form>['userContext'] = 'patient';
  export let formGender: ComponentProps<Form>['initialData']['gender'];

  const clipboard = createClipboard();

  $: anamnestic = determineAnamnestic(response.data);

  let context: ComponentProps<Form>['context'];
  $: context = !response.data ? undefined : !anamnestic ? 'new' : 'read';

  $: allowedToCreate = determineAllowedToCreate(formGender, iciqResponse?.data, ipssResponse?.data);

  function determineAnamnestic(responseData: (typeof response)['data']) {
    if (!responseData) return;

    if ('pagination' in responseData) {
      return responseData.anamnestic_forms.at(0);
    }

    return responseData.anamnestic_form;
  }

  function determineAllowedToCreate(
    formGenderValue: typeof formGender,
    iciqResponseData: IciqQueryResponseProperties['data'],
    ipssResponseData: IpssQueryResponseProperties['data']
  ) {
    if (!iciqResponseData || !ipssResponseData) return;

    const iciq = iciqResponseData.iciq_forms.at(0);
    const ipss = ipssResponseData.ipss_forms.at(0);

    if (formGenderValue === 'female') {
      return iciq?.allowed_to_create_anamnestic_form ?? false;
    }

    return ipss?.allowed_to_create_anamnestic_form ?? false;
  }

  // TODO: move to paraglide messages
  function handleCopyClick() {
    if (!$clipboard.isSupported) {
      toast.error('Váš prohlížeč nepodporuje kopírování');
      return;
    }

    if (!response.data || 'pagination' in response.data) return;

    const convertBooleanToText = (value: boolean) => [m.no(), m.yes()][Number(value)];

    const anamnesticFormData = response.data?.anamnestic_form;

    const ignoredKeys = [
      'id',
      'patient_id',
      'patient_public_id',
      'completion_timestamp',
      'gender',
      'completed',
    ] satisfies (keyof typeof anamnesticFormData)[];
    const dataToCopy: (string | number)[][] = [];

    const anamnesticFormDataTexts: Record<
      Partial<keyof Except<typeof anamnesticFormData, (typeof ignoredKeys)[number]>>,
      string
    > = {
      age: m.age(),
      height: 'Výška (cm)',
      weight: 'Váha (kg)',
      on_oab_medication_last_3_months:
        'Bral/a jste v posledních 3 měsících léky na hyperaktivní močový měchýř',
      number_of_births: 'Počet porodů',
      post_menopausal: 'Jste již po přechodu (v menopauze)?',
      prolapse_diagnosed: 'Byla u Vás stanovena diagnóza sestupu dělohy nebo poševních stěn?',
      hysterectomy: 'Proběhlo u Vás odstranění dělohy?',
      cesarean_section:
        'Pokud u Vás proběhl v minulosti porod či více porodů. Proběhl alespoň jeden z nich císařským řezem?',
      surgery_for_benign_prostate_enlargement: 'Operaci pro nezhoubné zvětšení prostaty',
      surgery_for_prostate_cancer: 'Operaci pro rakovinu prostaty',
      surgery_for_bladder_tumor: 'Operaci pro nádor močového měchýře',
      surgery_for_urethral_stricture: 'Operaci pro zúženinu močové trubice',
      surgery_for_urine_leakage: 'Operaci úniku moči',
      other_surgery: 'Jiné',
      previous_surgery_details: 'Specifikujte předchozí operaci',
      recurrent_infections:
        'Trpíte opakovanými (alespoň 2x za rok) infekcemi močových cest (močového měchýře)?',
      neurological_surgery_history:
        'Podstoupil/a jste v minulosti operaci močové trubice nebo močového měchýře?',
      hypertension: 'Hypertenze (vysoký krevní tlak)',
      hypothyroidism: 'Snížená funkce štítné žlázy',
      high_cholesterol: 'Zvýšená hladina cholesterolu',
      diabetes: 'Cukrovka',
      back_problems: 'Problémy se zády',
      depression: 'Deprese',
      other_psychiatric_conditions: 'Jiná psychiatrická onemocnění',
      reduced_immunity: 'Snížená imunita',
      headaches: 'Bolesti hlavy',
      hip_osteoarthritis: 'Artróza kyčlí',
      knee_osteoarthritis: 'Artróza kolen',
      cancer_treatment_history: 'Léčíte se nebo jste se léčil/a s onkologickým onemocněním?',
      cervical_cancer: 'Rakovina děložního čípku',
      endometrial_cancer: 'Rakovina sliznice dělohy',
      ovarian_cancer: 'Rakovina vaječníků',
      breast_cancer: 'Rakovina prsu',
      intestinal_cancer: 'Rakovina střev',
      other_cancer: 'Jiná onkologická onemocnění',
      cancer_type_details: 'Uveďte onkologické onemocnění',
      drug_allergies: 'Alergie na léky',
      drug_allergies_details: 'Specifikujte léky, na které jste alergický/á.',
      glaucoma_or_eye_pressure_meds:
        'Trpíte zeleným zákalem (glaukomem) nebo používáte léky na nitrooční tlak?',
      cardiac_conditions: 'Léčíte se se srdečním onemocněním?',
      heart_attack: 'Prodělal/a jste infarkt?',
      arrhythmia: 'Trpíte poruchou srdečního rytmu?',
      stroke: 'Prodělal/a jste cévní mozkovou příhodu (mrtvice)?',
      digestive_problems: 'Máte zažívací obtíže (zácpa, průjem)?',
      dry_mucous_membranes: 'Trpíte na suchost sliznic (například sucho v ústech)?',
      current_medications: 'Užíváte v současnosti nějaké léky?',
      current_medications_details: 'Uveďte názvy léků, které v současnosti užíváte',
      past_medications:
        'Užíval/a jste v minulosti (před více než 3 měsíci) léky na hyperaktivní močový měchýř?',
      past_medications_details:
        'Uveďte název léku používaného pro léčbu hyperaktivního močového měchýře',
      no_illness: 'Žádné z uvedených',
      no_surgery: 'Žádné z uvedených',
    };

    for (const [key, value] of objectEntries(anamnesticFormData)) {
      if (ignoredKeys.includes(key as (typeof ignoredKeys)[number]) || value === null) continue;

      if (key === 'surgery_for_benign_prostate_enlargement') {
        dataToCopy.push(['Prodělal jste předchozí operaci:', '']);
      } else if (key === 'hypertension') {
        dataToCopy.push(['Léčíte se pro některé z uvedených onemocnění?', '']);
      } else if (key === 'cervical_cancer') {
        dataToCopy.push([
          'Se kterým z uvedených onkologických onemocnění se léčíte nebo jste se léčil/a?',
          '',
        ]);
      }

      dataToCopy.push([
        anamnesticFormDataTexts[key as keyof typeof anamnesticFormDataTexts],
        typeof value === 'boolean' ? convertBooleanToText(value) : value,
      ]);
    }

    $clipboard.copy(dataToCopy.map((row) => row.join('\t')).join('\n'));
    toast.success('Údaje byly úspěšně zkopírovány');
  }

  onMount(() => {
    updateTextNodes();
  });
</script>

{#if breadcrumbs}
  <Breadcrumbs {breadcrumbs} />
{/if}

<div class={columnsVariants({ number: 0 })}>
  {#if userContext === 'patient' && context === 'new' && allowedToCreate === false}
    <!-- TODO: move to paraglide messages -->
    <Alert.Root class="sticky top-1 z-50" inverted={true} variant="destructive">
      <Alert.Description>
        {'Pro vyplnění anamnestického dotazníku musíte vyplnit všechny dotazníky kvality života a splnit podmínky účasti v programu.'}
      </Alert.Description>
    </Alert.Root>
  {/if}

  <Title includeMeta={true} text={m.anamnesticForm()}>
    {#if userContext === 'doctor'}
      <Tooltip.Root openDelay={100}>
        <Tooltip.Trigger asChild let:builder>
          <Button
            builders={[builder]}
            prependIcon={CopyIcon}
            prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
            size="icon2xs"
            variant="outline"
            on:click={handleCopyClick}
          >
            <span class="sr-only">{'Zkopírovat'}</span>
          </Button>
        </Tooltip.Trigger>
        <Tooltip.Content>
          <p>{'Zkopírovat'}</p>
        </Tooltip.Content>
      </Tooltip.Root>
    {/if}
  </Title>

  {#if userContext === 'patient'}
    <p>
      <strong>Anamnestický dotazník</strong> je součástí vaší zdravotnické dokumentace. Jeho vyplnění
      usnadní první rozhovor s lékařem a umožní mu soustředit se na aktuální problém. Prosíme o vyplnění
      všech otázek.
    </p>

    <p class="text-red-500">
      <strong>
        Po uložení se dotazník uzamkne a nebude možné odpovědi upravit. Prosím, zkontrolujte si je
        před uložením.
      </strong>
    </p>
  {/if}

  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      <Card.Root class="uzis-border max-w-prose">
        <Card.Content>
          <Form {context} initialData={{ anamnestic, gender: formGender }} {userContext} />
        </Card.Content>
      </Card.Root>
    {/if}
  {/if}
  <!-- svelte-ignore a11y-invalid-attribute -->
  <a class="bottom-0 ml-auto block md:sticky" href="#" title="Nahoru"
    ><img
      class="pointer-events-none w-80 max-w-full transition-all lg:w-96 2xl:w-[553px]"
      alt="illustr"
      src={DoctorImg}
    /></a
  >
</div>
