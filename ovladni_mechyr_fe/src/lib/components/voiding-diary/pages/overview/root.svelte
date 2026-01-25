<script lang="ts">
  import Button from '$lib/components/common/Button.svelte';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { cn, updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import { onMount } from 'svelte';
  import MobileApplication from './mobile-application.svelte';
  import Stats from './stats.svelte';
  import Table from './table.svelte';
  import type { AnamnesticQueryResponseProperties, QueryResponseProperties } from './types';
  import { FileDownIcon } from 'lucide-svelte';

  export let response: QueryResponseProperties;
  export let anamnesticResponse: AnamnesticQueryResponseProperties;

  $: hasAnamnesticForm =
    anamnesticResponse.data && anamnesticResponse.data.anamnestic_forms.length > 0;

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class={columnsVariants({ number: 0, gap: 8 })}>
  <Columns gap={6} number={2} verticalAlign="start">
    <div class={columnsVariants({ number: 0, gap: 5 })}>
      <Title includeMeta={true} text={m.voidingDiary()} />

      <!-- TODO: move to paraglide messages -->
      <p>
        Abyste se mohli objednat k lékaři v sekci
        <strong class="text-primary">Výběr lékaře</strong>, prosíme o zaznamenávání močení a příjmu
        tekutin minimálně 24 hodin. Mikční deník je speciální nástroj, kam zapisujete, kdy a kolik
        jste pili a kdy jste šli na záchod. Zaznamenáváte frekvenci močení, množství vypité tekutiny
        a případné epizody inkontinence.
      </p>

      <p>
        <strong>
          Po 48 hodinách od začátku zadávání bude mikční deník uzavřen bez možnosti další editace.
        </strong>
      </p>

      <div class="grid gap-3">
        <p><strong class="text-primary">Jak na to:</strong></p>

        <ol class="list-inside list-decimal space-y-2">
          <li>Deník vyplňujete alespoň 1 den.</li>
          <li>Když se napijete, zaznamenáte si, kolik jste vypil/a a čeho.</li>
          <li>
            Když jdete na záchod, zaznamenáte si, v kolik hodin to bylo a kolik jste vymočil/a.
          </li>
          <li>Pokud se vám stane nehoda a pomočíte se, uděláte záznam v deníku.</li>
          <li>Deník začněte vyplňovat údaji o druhé ranní mikci.</li>
        </ol>
      </div>

      <p>
        Zadávání informací probíhá výhradně prostřednictvím mobilní aplikace. Veškeré záznamy prosím
        vkládejte přímo do aplikace, která je přehledná a jednoduchá na použití.
      </p>

      <div class="mb-4 flex flex-wrap gap-4">
        <Button
          href="/mikcni-denik-papir.pdf"
          prependIcon={FileDownIcon}
          prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
          target="_blank"
        >
          {m.paperVersionOfVoidingDiary()}
        </Button>

        <Tooltip.Root openDelay={100}>
          <Tooltip.Trigger asChild let:builder>
            <Button
              builders={[builder]}
              disabled={!hasAnamnesticForm}
              href={hasAnamnesticForm ? localizeRoute(route('/voiding-diary/list')) : undefined}
              variant="outline"
            >
              Seznam mikčních deníků
            </Button>
          </Tooltip.Trigger>
          <Tooltip.Content class={cn(hasAnamnesticForm && 'hidden')}>
            <p>
              {'Pro vytvoření mikčního deníku je zapotřebí mít vyplněný anamnestický dotazník.'}
            </p>
          </Tooltip.Content>
        </Tooltip.Root>
      </div>
    </div>

    <MobileApplication />
  </Columns>

  <div class={columnsVariants({ number: 0, gap: 5 })}>
    {#if response.isLoading}
      <LoadingIndicator />
    {:else if response.isSuccess}
      {@const { voiding_diary } = response.data ?? {}}

      {#if voiding_diary}
        <Title level="h1" text={m.evaluationOfVoiding()} />

        <Stats
          data={[
            {
              value: voiding_diary.max_voided_volume,
              unit: 'ml',
              title: m.maximumVoidingVolume(),
            },
            {
              value: voiding_diary.median_voided_volume,
              unit: 'ml',
              title: m.medianVoidingVolume(),
            },
            {
              value: voiding_diary.average_voided_volume,
              unit: 'ml',
              title: m.meanVoidingVolume(),
            },
          ]}
        />

        <!-- TODO: move to paraglide messages -->
        <Table
          responseData={[
            {
              label: m.date(),
              value: new Date(voiding_diary.diary_start_date).toLocaleDateString(languageTag()),
            },
            {
              label: 'Objem - příjem',
              value: `${voiding_diary.fluid_intake_volume.toLocaleString(languageTag())} ml`,
              tooltipText:
                'Celkový příjem tekutin dosažený od první zaznamenané mikce až do následující ranní mikce. Pokud nastal příjem méně než 30 minut před první zaznamenanou ranní mikcí, započítává se již do dalšího dne.',
            },
            {
              label: 'Objem - mikce',
              value: `${voiding_diary.voided_volume.toLocaleString(languageTag())} ml`,
              tooltipText:
                'Zobrazuje celkový objem mikce od druhé mikce po první ranní mikci následujícího dne (včetně).',
            },
            {
              label: 'Objem - mikce noc',
              value: `${voiding_diary.nocturnal_voided_volume.toLocaleString(languageTag())} ml`,
              tooltipText:
                'Zobrazuje celkový objem mikcí, které proběhly v noci, respektive pacient před i po močení spal (v noci se probudil a šel na záchod a znovu spát) a k tomu navíc první ranní mikce.',
            },
            {
              label: 'Polyurie',
              value: voiding_diary.polyuria,
              tooltipText:
                'Nadměrné vylučování moči, které vede k hojné a časté mikci. Byla definována jako více než 40 ml/kg tělesné hmotnosti během 24 h.',
            },
            {
              label: 'Index noční polyurie',
              value: `${voiding_diary.nocturnal_polyuria_index}%`,
              tooltipText: 'Podíl noční mikce na celkové mikci.',
            },
            {
              label: 'Frekvence',
              value: voiding_diary.frequency,
              tooltipText:
                'Počet mikcí v průběhu celého dne (den i noc) od první mikce v daném dni do poslední mikce, která nastala v průběhu spánku a první mikce po probuzení.',
            },
            {
              label: 'Nykturie',
              value: voiding_diary.nocturnal_voids,
              tooltipText:
                'Počet mikcí, které proběhly v průběhu spánku, tj. pacient se probudí, jde se vymočit a poté znovu usne.',
            },
            {
              label: 'Urgence',
              value: voiding_diary.urgencies,
              tooltipText:
                'Počet mikcí v průběhu celého dne (den i noc) od první ranní mikce v daném dni do poslední mikce, která nastala v průběhu spánku a první po probuzení.',
            },
            { label: 'Urgence s únikem moči', value: voiding_diary.urgent_incontinence },
            {
              label: 'Inkontinence',
              value: voiding_diary.incontinence_episodes,
              tooltipText:
                'Počet úniků moči bez varování během celého dne a noci, nezapočítávají se urgence, jedná se výhradně o počet úniků bez varování.',
            },
          ]}
        />
      {/if}
    {/if}
  </div>
</div>
