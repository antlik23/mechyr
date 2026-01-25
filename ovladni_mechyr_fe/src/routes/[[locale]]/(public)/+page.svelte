<script lang="ts">
  import HeroLeft from '$lib/assets/images/illustr2.png?url';
  import HeroRight from '$lib/assets/images/illustr4.png?url';
  import Title from '$lib/components/common/Title.svelte';
  import * as Form from '$lib/components/form';
  import { persistedEntryForm } from '$lib/components/form/entry';
  import * as Accordion from '$lib/components/ui/accordion';
  import * as Alert from '$lib/components/ui/alert';
  import * as Card from '$lib/components/ui/card';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { onMount, type ComponentEvents } from 'svelte';

  type AccordionType = {
    title: string;
    text: string;
    children?: AccordionType[];
  };

  // TODO: move to paraglide messages
  const accordions: AccordionType[] = [
    {
      title:
        'Příznaky hyperaktivního močového měchýře a dopad tohoto onemocnění na každodenní život',
      text: `<div class="flex flex-col gap-2">
				<p class="max-w-none">Příznaky zahrnují:</p>
				<ul class="list-disc pl-7">
					<li><strong>náhlé a časté nutkání na močení</strong> (i při slabě naplněném močovém měchýři),</li>
					<li><strong>zvýšený počet močení za den</strong>,</li>
					<li><strong>noční močení (nykturie)</strong> - stav, kdy musíte během noci opakovaně vstávat z důvodu nutkání na močení, což narušuje spánek a kvalitu života,</li>
					<li><strong>nedobíhání na záchod (urgentní inkontinence)</strong> - neschopnost zadržet moč při náhlém nutkání.</li>
				</ul>
			</div>
			<div class="flex flex-col gap-2">
				<p class="max-w-none">Tyto příznaky mohou mít dopady na každodenní život a způsobovat např.:</p>
				<ul class="list-disc pl-7">
					<li>chronický stres,</li>
					<li>deprese,</li>
					<li>poruchy spánku,</li>
					<li>zvýšenou nemocnost,</li>
					<li>změny v hormonální rovnováze apod.</li>
				</ul>
			</div>
			<p class="max-w-none">Zároveň mohou ovlivnit partnerské vztahy a celkovou psychickou a fyzickou pohodu.</p>`,
    },
    {
      title: 'Mám problém? Jak to poznám?',
      text: `<p class="max-w-none">
				Začněte jednoduše - vyplněním anonymního online testu (viz <a class="underline" href="#entry-form"><strong>Vstupní dotazník</strong></a>).
                Během několika kliknutí získáte přehled, zda u Vás může být podezření na hyperaktivní močový měchýř a zda je vhodné navštívit odborníka.
            </p>`,
      children: [
        {
          title:
            'Co dělat, pokud mi Vstupní dotazník řekne, že mohu trpět na hyperaktivní močový měchýř?',
          text: `<p class="max-w-none">
				Nelekejte se. Pokud test naznačí možné potíže, pomůžeme Vám co nejdříve se spojit s odborným lékařem
                (např. z oborů urogynekologie, funkční urologie nebo gynekologie) přes jednoduchou webovou aplikaci.
              </p>
              <p class="max-w-none">
                Po <strong>registraci</strong> vyplníte několik otázek týkajících se Vašeho zdraví, příjmu tekutin a frekvence močení během dne.
                Tato data pomohou lékaři k lepšímu posouzení situace.
              </p>`,
        },
        {
          title: 'A co když mi dotazníky řeknou, že mohu mít toto onemocnění?',
          text: `<p class="max-w-none">
					Pokud Vaše odpovědi <strong>potvrdí</strong> podezření na hyperaktivní močový měchýř, bude Vám nabídnuto osobní
                    vyšetření u specialisty dle Vašeho výběru. Ten si Vás následně pozve k osobní konzultaci.
				</p>
				<p class="max-w-none">
					Před návštěvou lékaře si veďte tzv. mikční deník, kam si zapisujete, kdy a kolikrát denně jdete na toaletu,
                    kolik tekutin vypijete a kolik moči vymočíte. Deník je pro lékaře velmi důležitý - umožní mu už při první
                    návštěvě zhodnotit závažnost potíží a zahájit vhodnou léčbu.
				</p>
                <p class="max-w-none">
                    <strong class="text-primary">Bez mikčního deníku lékař nemůže Váš stav vyhodnotit, a tím, že jej budete mít připraven/a už během
                    první návštěvy lékaře se vyhnete nutnosti absolvovat jednu návštěvu lékaře navíc.</strong>
                </p>`,
        },
      ],
    },
    {
      title: 'Diagnostika',
      text: `<p class="max-w-none">
				Diagnostický proces začíná podrobným lékařským pohovorem a fyzikálním vyšetřením, při kterém lékař zjišťuje Váš celkový zdravotní stav, prodělaná onemocnění, aktuální léčbu a užívané léky.
            </p>
			<div class="flex flex-col gap-2">
				<p class="max-w-none">Součástí diagnostiky je také <strong>vedení mikčního deníku</strong>, kam si zaznamenáváte:</p>
				<ul class="list-disc pl-7">
					<li>frekvenci močení,</li>
					<li>množství a typ vypité tekutiny,</li>
					<li>objem moči při močení,</li>
					<li>případné epizody inkontinence.</li>
				</ul>
			</div>
            <p class="max-w-none">
				Tyto údaje odrážejí reálnou funkci močového měchýře v běžném životě a poskytují lékaři cenné informace pro stanovení diagnózy.
            </p>
			<p class="max-w-none">
				Kromě toho je důležité <strong>vyloučit jiné možné příčiny</strong> potíží, které mohou napodobovat příznaky hyperaktivního močového měchýře.
                Může být provedeno funkční vyšetření močového měchýře (urodynamické vyšetření, cystoskopie).
			</p>`,
    },
    {
      title: 'Léčba',
      text: `<p class="max-w-none">Základní léčba hyperaktivního močového měchýře zahrnuje úpravy životního stylu a farmakologickou léčbu.</p>
			<p class="max-w-none">
                Mezi <strong>změny životního stylu</strong> patří např. úprava příjmu a složení tekutin a cvičení ke zpevnění svalů pánevního dna (fyzioterapie, rehabilitace).
            </p>
			<p class="max-w-none">
                Lékař může také předepsat <strong>léky</strong>, které pomáhají kontrolovat nutkání na močení a zvýšit kapacitu močového měchýře. U závažnějších případů jsou k dispozici další možnosti léčby po konzultaci s lékařem.
            </p>`,
    },
    {
      title: 'Prevence a samopéče',
      text: `<p class="max-w-none">
				Existuje několik kroků, které můžete podniknout, aby se minimalizovaly příznaky a zlepšila se kvalita Vašeho života.
                Tyto kroky zahrnují pravidelné cvičení, vyhýbání se dráždivým potravinám a nápojům (např. kofein, alkohol) a udržování zdravé tělesné hmotnosti.
            </p>
            <p class="max-w-none">
                Důležitou součástí prevence je také zavedení správné léčby a vyloučení závažnějších onemocnění, která by mohla být příčinou Vašich obtíží.
            </p>`,
    },
    {
      title: 'Kdo za projektem stojí?',
      text: `<p class="max-w-none">
                Projekt realizuje Národní screeningové centrum (součást Ústavu zdravotnických informací a statistiky ČR).
                Odbornou garanci projektu převzala <a class="underline" href="https://www.urogynekologie.com" target="_blank">Urogynekologická společnost České republiky</a>.
                Na projektu participuje řada předních odborníků v oborech urogynekologie, funkční urologie a gynekologie.
              </p>
              <p class="max-w-none">
                Projekt je financován z Operačního programu Zaměstnanost plus Evropského sociálního fondu, jehož gestorem je Ministerstvo práce a sociálních věcí ČR.
                Více informací k projektu naleznete také na webu realizátora ÚZIS ČR a <a class="underline" href="https://nsc.uzis.cz/oab" target="_blank">https://nsc.uzis.cz/oab</a>.
              </p>`,
    },
  ];

  function handleEntryFormSuccess({ detail }: ComponentEvents<Form.Entry>['success']) {
    $persistedEntryForm = detail;
  }

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class="-mt-8 mb-6 grid h-full w-full grid-cols-5 gap-6 lg:-mt-16">
  <div class="col-span-3 grid h-full w-full gap-5">
    <img
      class="h-full w-full rounded-sm object-cover"
      alt="illustr"
      src={HeroLeft}
      title="Banner"
    />
  </div>
  <div class="col-span-2 h-full w-full">
    <img
      class="h-full w-full rounded-sm object-cover"
      alt="illustr"
      src={HeroRight}
      title="Banner"
    />
  </div>
</div>

<div class="grid items-start gap-6 lg:grid-cols-2 xl:grid-cols-5">
  <div class="grid gap-5 xl:col-span-3">
    <Alert.Root inverted={true} variant="destructive">
      <Alert.Description class="flex items-center gap-4">
        <div
          class="float-left flex h-16 w-16 items-center justify-center rounded-full bg-white text-4xl font-extrabold text-primary"
        >
          !
        </div>
        {m.seekDoctorOnAcuteProblem()}</Alert.Description
      >
    </Alert.Root>

    <!-- TODO: move to paraglide messages -->
    <Title includeMeta={true} text={'Úvod'} />

    <div class="grid gap-5 text-sm font-medium">
      <div class="grid gap-5">
        <p class="max-w-none">
          Vítejte na webu pilotního projektu časného záchytu hyperaktivního močového měchýře (OAB) a
          zlepšení kvality života. Projekt se zaměřuje na onemocnění dolních močových cest,
          především na hyperaktivní močový měchýř (anglicky Overactive Bladder, zkráceně OAB).
        </p>

        <p class="max-w-none">
          Máte pocit, že s Vaším močovým měchýřem není něco v pořádku? Možná hledáte odpovědi pro
          sebe, možná pro někoho blízkého. Nečekejte - informace i pomoc jsou na dosah. Projekt je
          určen nejen těm, kdo pociťují příznaky onemocnění, ale rádi přivítáme i zdravé účastníky,
          kteří nám pomohou lépe porozumět rozdílům ve fungování močového měchýře.
        </p>

        <p class="max-w-none">
          Plánujete si den podle toho, kdy a kde bude toaleta?
          <strong>Řešení existuje - a není důvod ho odkládat.</strong>
        </p>
      </div>

      <Accordion.Root multiple={true}>
        {#each accordions as acc, index}
          <Accordion.Item value="chapter-{index}">
            <Accordion.Trigger class="text-lg font-semibold text-primary" level={2}>
              {acc.title}
            </Accordion.Trigger>
            <Accordion.Content innerContainerClasses="grid gap-5">
              <!-- eslint-disable-next-line svelte/no-at-html-tags -->
              {@html acc.text}

              {#if acc.children}
                {#each acc.children as child, idx}
                  <Accordion.Item
                    class={idx !== acc.children.length - 1 ? '' : 'border-none'}
                    value="nasted-chapter-{idx}"
                  >
                    <Accordion.Trigger class="text-md font-semibold text-primary">
                      {child.title}
                    </Accordion.Trigger>
                    <Accordion.Content innerContainerClasses="grid gap-5">
                      <!-- eslint-disable-next-line svelte/no-at-html-tags -->
                      {@html child.text}
                    </Accordion.Content>
                  </Accordion.Item>
                {/each}
              {/if}
            </Accordion.Content>
          </Accordion.Item>
        {/each}
      </Accordion.Root>
    </div>
  </div>

  <div id="entry-form" class="xl:col-span-2">
    <Card.Root class="uzis-border">
      <Card.Header>
        <Title text={m.entryForm()} />
        <Card.Description>{m.pleaseFillEntryForm()}</Card.Description>
      </Card.Header>
      <Card.Content>
        <Form.Entry on:success={handleEntryFormSuccess} />
      </Card.Content>
    </Card.Root>
  </div>
</div>
