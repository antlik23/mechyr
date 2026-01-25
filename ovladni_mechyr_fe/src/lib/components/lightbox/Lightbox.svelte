<script lang="ts">
  import 'bigger-picture/css';
  import type { HTMLAttributes } from 'svelte/elements';

  import { onMount } from 'svelte';
  import BiggerPicture, { type BiggerPictureInstance } from 'bigger-picture';
  import { cn } from '$lib/utils';

  import Icon from '$lib/components/wrappers/Icon.svelte';
  import PlayIcon from '$lib/assets/icons/play.svg?component';

  type MediaItem = {
    id: number;
    thumbnailUrl: string;
    url: string;
    width: number;
    height: number;
    caption?: string;
    videoOrAudioSources?: {
      src: string;
      type?: string;
    }[];
  };

  let className: HTMLAttributes<HTMLDivElement>['class'] = undefined;
  export { className as class };
  export let mediaItems: MediaItem[];

  let biggerPicture: BiggerPictureInstance;

  onMount(() => {
    biggerPicture = BiggerPicture({ target: document.body });
  });

  function handleThumbnailClick(itemIndex: number) {
    biggerPicture.open({
      scale: 0.95,
      intro: 'fadeup',
      position: itemIndex,
      items: mediaItems.map((item) => ({
        caption: item?.caption,
        height: item.height,
        img: !item?.videoOrAudioSources ? item.url : undefined,
        width: item.width,
        thumb: item.thumbnailUrl,
        sources: item?.videoOrAudioSources,
      })),
    });
  }
</script>

<div class={cn('grid grid-cols-3 gap-4', className)}>
  {#each mediaItems as mediaItem, index (mediaItem.id)}
    <div class="relative aspect-square">
      <a
        class="group"
        href={mediaItem.url}
        target="_blank"
        on:click|preventDefault={() => handleThumbnailClick(index)}
      >
        <div class="absolute inset-0 h-full w-full overflow-hidden rounded-lg">
          <img
            class="absolute inset-0 h-full w-full object-cover transition-transform group-hover:scale-105 group-focus-visible:scale-105"
            alt=""
            loading="lazy"
            src={mediaItem.thumbnailUrl}
          />
        </div>
        {#if mediaItem?.videoOrAudioSources}
          <div
            class="absolute inset-0 inline-grid place-items-center text-white group-hover:text-gray-200 group-focus-visible:text-gray-200"
          >
            <Icon class="w-fit drop-shadow" icon={PlayIcon} />
          </div>
        {/if}
      </a>

      <slot id={mediaItem.id} name="itemAppend" {mediaItem} />
    </div>
  {/each}
</div>
