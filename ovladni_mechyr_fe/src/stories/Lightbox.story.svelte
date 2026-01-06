<script lang="ts">
  import type { StoryLayout } from 'histoire';
  import type { Hst } from '@histoire/plugin-svelte';
  export let Hst: Hst;

  import type { ComponentProps } from 'svelte';
  import Lightbox from '$lib/components/lightbox/Lightbox.svelte';

  import ImageLink from './mock-assets/lightbox-image1.jpg';
  import ImageLink2 from './mock-assets/lightbox-image2.jpg';
  import ImageLink3 from './mock-assets/lightbox-image3.jpg';
  import ImageLink4 from './mock-assets/lightbox-video1-thumbnail.jpg';

  const layout: StoryLayout = {
    type: 'grid',
    width: '49.5%',
  };

  let state: Record<
    'oneImage' | 'moreImages' | 'imageAndVideo' | 'video',
    ComponentProps<Lightbox>
  > = {
    oneImage: {
      mediaItems: [
        {
          id: 1,
          thumbnailUrl: ImageLink,
          url: ImageLink,
          width: 800,
          height: 450,
          caption: 'Lorem ipsum caption',
        },
      ],
    },
    moreImages: {
      mediaItems: [
        {
          id: 2,
          thumbnailUrl: ImageLink,
          url: ImageLink,
          width: 800,
          height: 450,
          caption: 'Lorem ipsum caption',
        },
        {
          id: 3,
          thumbnailUrl: ImageLink2,
          url: ImageLink2,
          width: 1920,
          height: 1440,
          caption: 'Lorem ipsum dolor sit amet caption',
        },
        {
          id: 4,
          thumbnailUrl: ImageLink3,
          url: ImageLink3,
          width: 1000,
          height: 1018,
        },
        {
          id: 5,
          thumbnailUrl: ImageLink4,
          url: ImageLink4,
          width: 1920,
          height: 1440,
        },
      ],
    },
    imageAndVideo: {
      mediaItems: [
        {
          id: 6,
          thumbnailUrl: ImageLink,
          url: ImageLink,
          width: 800,
          height: 450,
        },
      ],
    },
    video: {
      mediaItems: [
      ],
    },
  };
</script>

<svelte:component this={Hst.Story} {layout} title="Lightbox/Lightbox">
  <svelte:component this={Hst.Variant} title="One image">
    <Lightbox {...state.oneImage} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Multiple images">
    <Lightbox {...state.moreImages} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="Image and video">
    <Lightbox {...state.imageAndVideo} />
  </svelte:component>

  <svelte:component this={Hst.Variant} title="One video">
    <Lightbox {...state.video} />
  </svelte:component>
</svelte:component>
