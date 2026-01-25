import type { ComponentProps } from 'svelte';
import type { CustomFile } from '$lib/components/cards/FileItem.svelte';
import type Lightbox from '$lib/components/lightbox/Lightbox.svelte';

export function convertToLightboxItems(
  attachments: CustomFile[]
): ComponentProps<Lightbox>['mediaItems'] {
  return attachments.map((attachment) => {
    const lightboxItem: ComponentProps<Lightbox>['mediaItems'][number] = {
      id: attachment.id,
      url: attachment.url,
      thumbnailUrl: attachment.thumbnail_url,
      width: attachment?.width ?? 0,
      height: attachment?.height ?? 0,
    };

    if (attachment.content_type.startsWith('video')) {
      lightboxItem.videoOrAudioSources = [
        {
          src: attachment.url,
          type: attachment.content_type,
        },
      ];
    }

    return lightboxItem;
  });
}
