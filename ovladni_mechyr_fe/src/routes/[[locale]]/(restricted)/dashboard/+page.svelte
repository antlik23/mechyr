<script lang="ts">
  import * as Accordion from '$lib/components/ui/accordion';
  import About from '$lib/assets/images/illustr3.png?url';
  import FooterImg from '$lib/assets/images/ilustrace.png?url';
  import Meta from '$lib/components/common/Meta.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { onMount } from 'svelte';
  import { currentUser } from '$lib/components/user/data.js';

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class="grid gap-5">
  <!-- TODO: move to paraglide messages -->
  <Meta title={m.homePage()} />
  <img class="w-full" alt="illustr" src={FooterImg} title="Chci vědět víc" />
  <div class="flex gap-4 max-md:flex-col">
    <div class="grid gap-4 md:w-1/2">
      <Title level="h1" text={'3 kroky k úlevě'} />
      <p>
        <strong>
          !! Po uložení daného dotazníku nebude možné odpovědi upravit - proto si je před uložením
          pečlivě zkontrolujte !!
        </strong>
      </p>
      <ol class="list-inside list-decimal space-y-3">
        <li>Vyplňte dotazníky.</li>
        <li>Vyplňte mikční deník.</li>
        <li>Kontaktujte lékaře.</li>
      </ol>
    </div>

    <div class="min-w-80 flex-1">
      <a href="#more">
        <img class="w-full" alt="illustr" src={About} title="Chci vědět víc" />
      </a>
    </div>
  </div>
  <a id="more"><span></span></a>

  <!-- <Title level="h1" text={'Pokyny pro vyplnění dotazníků'} /> -->
  <Accordion.Root>
    <Accordion.Item value="instructions" style="border: 0">
      <Accordion.Trigger class="text-xl font-semibold text-primary" style="max-width: 520px;">
        Vyplňujte dotazníky v následujícím pořadí
      </Accordion.Trigger>
      <Accordion.Content innerContainerClasses="grid gap-5">
        <ol class="list-inside list-decimal space-y-3">
          <li class="max-w-prose text-justify">
            <a class="text-primary underline" href={localizeRoute(route('/questionnaires'))}>
              <strong>Dotazník OAB-V8</strong>
            </a> - pomůže lékaři zjistit souvislost vašich problémů s močovým měchýřem.
          </li>
          <li class="max-w-prose text-justify">
            <a class="text-primary underline" href={localizeRoute(route('/questionnaires/iciq'))}>
              <strong>Dotazník ICIQ-UI SF</strong>
            </a> - je zaměřen na inkontinenci.
          </li>
          {#if $currentUser.gender === 'male'}
            <li class="max-w-prose text-justify">
              <a class="text-primary underline" href={localizeRoute(route('/questionnaires/ipss'))}>
                <strong>Dotazník IPSS</strong>
              </a> - je určen pouze mužům. Jedná se o získání informací ohledně onemocnění prostaty či
              léčby symptomů dolních cest močových.
            </li>
          {/if}
          <li class="max-w-prose text-justify">
            <a class="text-primary underline" href={localizeRoute(route('/anamnestic'))}>
              <strong>Anamnestický dotazník</strong>
            </a> - je součástí vaší zdravotnické dokumentace. Jeho vyplnění usnadní první rozhovor s
            lékařem a umožní mu soustředit se na aktuální problém.
          </li>
          <li class="max-w-prose text-justify">
            <a class="text-primary underline" href={localizeRoute(route('/voiding-diary'))}>
              <strong>Mikční deník</strong>
            </a> - bude možné vyplnit až po uložení předchozích dotazníků a splnění kritérií projektu.
            Slouží k zaznamenání frekvence močení, objemu moči a příjmu tekutin. Pro vyplnění deníku
            použijte mobilní aplikaci, která slouží jako přehledný formulář.
          </li>
        </ol>

        <p>V sekci <span class="italic">Záznamy</span> poté uvidíte vyplněné dotazníky.</p>
      </Accordion.Content>
    </Accordion.Item>
  </Accordion.Root>

  <p>
    Podoby všech dotazníků a mikčního deníku byly schváleny zástupci Urogynekologické společnosti
    České republiky a zástupců předních odborníků zapojených do projektu.
  </p>

  <Title level="h2" text={'O projektu:'} />
  <p>
    Projekt <strong class="italic">
      Časný záchyt hyperaktivního močového měchýře a eliminace negativního dopadu na kvalitu života
    </strong> pomáhá s včasným odhalením tohoto onemocnění. Naším cílem je usnadnit cestu k odborné péči
    a pomoci lidem začít řešit svůj problém co nejdříve.
  </p>
</div>
