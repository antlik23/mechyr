<script lang="ts">
  import type { HTMLAttributes, HTMLImgAttributes } from 'svelte/elements';
  import { renderSVG } from 'uqr';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import googlePlayBadgeCzech from './assets/badge/google-play-badge-cs.png';
  import appleAppStoreBadgeCzech from './assets/badge/apple-app-store-badge-cs.png';

  export let storeLink: string;
  export let variant: 'google' | 'apple';
  export let containerClasses: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export let qrCodeImageProps: HTMLImgAttributes = {};
  export let badgeImageProps: HTMLImgAttributes = {};

  $: badgeImageLink = { google: googlePlayBadgeCzech, apple: appleAppStoreBadgeCzech }[variant];
  $: qrCodeSvg = renderSVG(storeLink);
</script>

<div class={cn('grid justify-center gap-1', containerClasses)}>
  <img alt="" {...qrCodeImageProps} src="data:image/svg+xml;base64,{btoa(qrCodeSvg)}" />

  <Button
    class="transition-opacity hover:opacity-80"
    aria-label={m.download()}
    href={storeLink}
    size="none"
    target="_blank"
    variant="none"
  >
    <img alt="" {...badgeImageProps} src={badgeImageLink} />
  </Button>
</div>
