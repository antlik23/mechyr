<script lang="ts">
  import About from '$lib/assets/images/illustr3.png?url';
  import FooterImg from '$lib/assets/images/ilustrace.png?url';
  import FooterImgMobile from '$lib/assets/images/OAB-krok-za-krokem-k-uleve_mob.jpg?url';
  import Meta from '$lib/components/common/Meta.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { updateTextNodes } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { onMount } from 'svelte';
  import * as Alert from '$lib/components/ui/alert';

  onMount(() => {
    updateTextNodes();
  });
</script>

<div class="grid gap-5">
  <!-- TODO: move to paraglide messages -->
  <Meta title={m.homePage()} />
  <img class="w-full md:hidden" alt="illustr" src={FooterImgMobile} title="Chci vědět víc" />
  <img class="hidden w-full md:block" alt="illustr" src={FooterImg} title="Chci vědět víc" />
  <div class="flex gap-4 max-md:flex-col">
    <div class="grid gap-4 md:w-1/2">
      <Title level="h1" text={'3 kroky k úlevě'} />
      <div style="padding: 5px 10px;">
        <ol class="list-inside list-decimal space-y-1">
          <li>
            Vyplňte <a
              class="font-bold text-primary underline"
              href={localizeRoute(route('/questionnaires'))}>dotazníky</a
            >.
          </li>
          <li>
            Vyplňte <a
              class="font-bold text-primary underline"
              href={localizeRoute(route('/voiding-diary'))}>mikční deník</a
            >.
          </li>
          <li>
            Kontaktujte <a
              class="font-bold text-primary underline"
              href={localizeRoute(route('/doctors'))}>lékaře</a
            >.
          </li>
        </ol>
      </div>
      <Alert.Root inverted={true} variant="destructive">
        <Alert.Description class="flex items-center gap-4">
          <div
            class="float-left flex h-16 w-16 items-center justify-center rounded-full bg-white text-4xl font-extrabold text-primary"
          >
            !
          </div>
          Po uložení daného dotazníku nebude možné odpovědi upravit - proto si je před uložením pečlivě
          zkontrolujte
        </Alert.Description>
      </Alert.Root>
    </div>

    <div class="min-w-80 flex-1">
      <a
        href="https://nsc.uzis.cz/projekt/10-casny-zachyt-hyperaktivni-mocovy-mechyr-kvalita-zivota/"
        target="_blank"
      >
        <img class="w-full" alt="illustr" src={About} title="Chci vědět víc" />
      </a>
    </div>
  </div>
  <a id="more"><span></span></a>
</div>
