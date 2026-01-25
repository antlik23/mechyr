<script lang="ts">
  import logo from '$lib/assets/icons/logo.svg?url';
  import euFinancingImageLink from '$lib/assets/images/eu-financing.png';
  import Title from '$lib/components/common/Title.svelte';
  import { updateTextNodes } from '$lib/utils';
  import { onMount } from 'svelte';

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class="m-auto flex max-w-[1000px] flex-col gap-5">
  <div class="items.items-center flex flex-wrap justify-between gap-5">
    <img alt="NSC" src={logo} width="200" />
    <img alt="Spolufinancováno Evropskou unií" height="30" src={euFinancingImageLink} width="200" />
  </div>
  <p class="max-w-full text-center text-xs">
    Časný záchyt hyperaktivního močového měchýře a eliminace negativního dopadu na kvalitu života,
    registrační číslo CZ.03.02.02/00/22_005/0002019 je příjemcem podpory z OPZ+ je ÚZIS ČR,
    Palackého náměstí 375/4, 128 00 Praha 2
  </p>
  <Title includeMeta={true} text={'Souhlas se zpracováním osobních údajů'} />
  <p class="max-w-full">
    Já, níže uvedený/á uděluji svůj souhlas s účastí v projektu a svým podpisem níže stvrzuji, že
    jsem byl/a o projektu řádně informován/a a byl/a jsem informován/a tom, že mohu svou účast v
    projektu kdykoliv ukončit.
  </p>

  <p class="max-w-full">
    Já, níže uvedený/á, uděluji svůj souhlas s tím, aby poskytovatel zdravotních služeb, který
    provede vyšetření v rámci pilotního projektu Časný záchyt hyperaktivního močového měchýře a
    eliminace negativního dopadu na kvalitu života č. CZ.03.02.02/00/22_005/0002019 (zpracovatel),
    předal mé údaje ÚZIS ČR (správci). Tento zajišťuje sledování a vyhodnocení tohoto pilotního
    projektu - statistického zjišťování dle ustanovení § 72 odst. 1 písm. j) zákona č. 372/2011 Sb.,
    o zdravotních službách a podmínkách jejich poskytování (zákon o zdravotních službách), ve znění
    pozdějších předpisů. ÚZIS ČR jako správci osobních údajů v Národním zdravotnickém informačním
    systému uděluji svůj souhlas ke zpracování níže uvedených osobních údajů za účelem vyhodnocení
    vyšetření v rámci pilotního projektu Časný záchyt hyperaktivního močového měchýře a eliminace
    negativního dopadu na kvalitu života.
  </p>

  <p class="max-w-full">
    Vzhledem k tomu, že pilotní projekt je financován z operačního programu Zaměstnanost plus, je
    ÚZIS ČR povinen doložit, že finance určené pro tento projekt byly využity řádně a efektivně. Pro
    tyto účely bude ÚZIS ČR jako zpracovatel pro Ministerstvo práce a sociálních věcí jako správce
    uchovávat Vaše jméno, příjmení, adresu a rodné číslo, a to do 31.&nbsp;12.&nbsp;2036 tedy po
    dobu, po kterou je Evropská komise oprávněna provádět kontrolu tohoto projektu. Na zpracování
    těchto údajů se bude podílet rovněž poskytovatel zdravotních služeb, který provede vyšetření v
    rámci tohoto projektu. Výše uvedená povinnost byla zavedena nařízením Evropského parlamentu a
    Rady (EU) č. 1304/2013 ze dne 17.&nbsp;prosince 2013 o Evropském sociálním fondu a o zrušení
    nařízení Rady Evropské unie č. 1081/2006 (zejména jeho příloh I a II).
  </p>

  <p class="max-w-full">
    Tento souhlas uděluji na dobu nejdéle do 31.&nbsp;12.&nbsp;2036. Tímto potvrzuji, že jsem byl/a
    poučen/a o právu na přístup k těmto údajům, jejich opravu, doplnění a výmaz, právu na omezení
    zpracování těchto údajů a právu podat stížnost u Úřadu pro ochranu osobních údajů. Tento souhlas
    uděluji dobrovolně. S informacemi o zpracování těchto osobních údajů jsem se seznámil/a a
    porozuměl/a obsahu. Jsem si vědom/a, že souhlas lze kdykoliv zcela odvolat zasláním e-mailu na
    adresu nsc@uzis.cz nebo dopisem na adresu ÚZIS ČR. V případě odvolání souhlasu nebudou výše
    uvedené osobní údaje nadále zpracovávány pro účely, pro které byl tento souhlas udělen,
    zpracování těchto údajů před odvoláním souhlasu ale zůstane zákonné.
  </p>

  <div>
    <p class="max-w-full">Statistické zjišťování zahrnuje:</p>
    <ul class="list-disc pl-7">
      <li>údaje o osobě: jméno, příjmení, pohlaví, rodné číslo;</li>
      <li>
        a dále údaje o zdravotním stavu a údaje o výsledcích lékařských vyšetření souvisejících s
        tímto projektem.
      </li>
    </ul>
  </div>
  <p class="mb-20 max-w-full">
    V případě jakýchkoliv dotazů nebo žádostí, týkajících se zpracování osobních údajů, mohu
    kontaktovat ÚZIS ČR na adrese uvedené výše nebo e-mailu <a
      class="underline"
      href="mailto:nsc@uzis.cz">nsc@uzis.cz</a
    >
  </p>

  <p class="max-w-full">
    Uděluji svůj souhlas se zpracováním osobních údajů a zaškrtnutím pole stvrzuji, že jsem byl/a o
    projektu řádně informován/a a byl/a jsem informován/a tom, že mohu svou účast v projektu
    kdykoliv ukončit.
  </p>
  <p class="max-w-full text-xs">
    Informace o zpracování osobních údajů a souhlas se zpracováním osobních údajů verze 1.0
  </p>
</div>
