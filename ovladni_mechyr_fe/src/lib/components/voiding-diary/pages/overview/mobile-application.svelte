<script lang="ts">
  import { PUBLIC_APPLE_APP_STORE_LINK, PUBLIC_GOOGLE_PLAY_LINK } from '$env/static/public';
  import * as m from '$paraglide/messages';
  import Columns from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import * as MobileApp from '$lib/components/mobile-app';
</script>

<Card.Root class="uzis-border bg-secondary/10">
  <Card.Header class="p-4 pb-0 lg:p-4 lg:pb-0">
    <Title
      class="leading-6"
      containerClasses="justify-center"
      level="h2"
      text={m.downloadTheApp()}
    />
  </Card.Header>
  <Card.Content class="p-4 pt-2 lg:p-4 lg:pt-2">
    <Columns class="grid-flow-col" gap={0} horizontalAlign="center" number={0}>
      <MobileApp.Download
        badgeImageProps={{ height: '40px', width: '135px', class: 'h-10 w-auto' }}
        qrCodeImageProps={{ width: '148px', height: '148px', class: 'mix-blend-darken' }}
        storeLink={PUBLIC_GOOGLE_PLAY_LINK}
        variant="google"
      />

      <MobileApp.Download
        badgeImageProps={{ height: '40px', width: '120px', class: 'h-10 w-auto' }}
        qrCodeImageProps={{ width: '148px', height: '148px', class: 'mix-blend-darken' }}
        storeLink={PUBLIC_APPLE_APP_STORE_LINK}
        variant="apple"
      />
    </Columns>
  </Card.Content>
</Card.Root>
