<script context="module" lang="ts">
  export interface CustomFile {
    id: number;
    url: string;
    thumbnail_url: string;
    download_url: string;
    filename: string;
    content_type: string;
    height?: number;
    width?: number;
  }

  export type FileOrCustom = File | CustomFile;

  export type FileType = 'file' | 'pdf' | 'spreadsheet' | 'image' | 'video';
</script>

<script lang="ts">
  import type { StoresValues } from 'svelte/store';
  import { createEventDispatcher, onMount } from 'svelte';
  import { getFileItemsContext } from '$lib/context/FileItem';
  import { hashFile } from '$lib/utils/hashing';
  import Icon from '$lib/components/wrappers/Icon.svelte';
  import Button from '$lib/components/common/Button.svelte';

  import SpreadsheetIcon from 'lucide-svelte/icons/file-spreadsheet';
  import ImageIcon from 'lucide-svelte/icons/file-image';
  import FileIcon from 'lucide-svelte/icons/file';
  import VideoIcon from 'lucide-svelte/icons/file-video';
  import Protocol from '$lib/assets/icons/protocol.svg?component';
  import LoaderCircleIcon from 'lucide-svelte/icons/loader-circle';
  import Download from '$lib/assets/icons/download.svg?component';
  import TrashIcon from '$lib/assets/icons/trash.svg?component';

  export let file: FileOrCustom;
  export let allowRemoval: boolean = true;

  const dispatch = createEventDispatcher<{
    remove: {
      file: CustomFile;
      fileHash?: string;
    };
  }>();

  const fileItems = getFileItemsContext();

  let fileUrl: string;
  let downloadUrl: string;
  let fileType: FileType;
  let fileItemContext: StoresValues<NonNullable<typeof fileItems>>[string] | undefined;
  let fileHash: string;

  $: filename = getFileDisplayName(file);
  $: fileType = determineFileType(file);
  $: {
    if (isCustomFile(file)) {
      fileItemContext = $fileItems?.[fileUrl];
    } else {
      hashFile(file).then((hash) => {
        fileHash = hash;
        fileItemContext = $fileItems?.[fileHash];
        if (fileItemContext?.customFile) {
          fileUrl = fileItemContext.customFile.url;
          downloadUrl = fileItemContext.customFile.download_url;
          filename = fileItemContext.customFile.filename;
        }
      });
    }
  }

  onMount(() => {
    fileUrl = determineFileUrl(file);
    downloadUrl = determineDownloadUrl(file);

    return () => {
      if (!isCustomFile(file)) {
        URL.revokeObjectURL(fileUrl);
      }
    };
  });

  function isCustomFile(file: FileOrCustom): file is CustomFile {
    return 'url' in file;
  }

  function getFileDisplayName(file: FileOrCustom): string {
    return 'filename' in file ? file.filename : file.name;
  }

  function determineFileType(file: FileOrCustom): FileType {
    const fileMimeType =
      'content_type' in file ? file.content_type : 'type' in file ? file.type : '';

    switch (true) {
      case fileMimeType === 'application/pdf':
        return 'pdf';
      case fileMimeType.includes('sheet'):
        return 'spreadsheet';
      case fileMimeType.includes('image'):
        return 'image';
      case fileMimeType.includes('video'):
        return 'video';
      default:
        return 'file';
    }
  }

  function determineFileUrl(file: FileOrCustom) {
    return isCustomFile(file) ? file.url : URL.createObjectURL(file);
  }

  function determineDownloadUrl(file: FileOrCustom) {
    return isCustomFile(file) ? file.download_url : fileUrl;
  }

  function handleRemoveClick() {
    let fileToDispatch = file as CustomFile;

    if (fileItemContext && fileItemContext?.customFile) {
      fileToDispatch = fileItemContext.customFile;
    }

    dispatch('remove', { file: fileToDispatch, fileHash });
  }
</script>

<div class="flex items-center justify-between p-2" data-testid="file-item">
  <div class="flex items-center gap-2">
    {#if fileType === 'pdf'}
      <Icon icon={Protocol} testId="file-item-file-icon-{fileType}" />
    {:else if fileType === 'spreadsheet'}
      <Icon
        icon={SpreadsheetIcon}
        size="20"
        strokeWidth="1.25"
        testId="file-item-file-icon-{fileType}"
      />
    {:else if fileType === 'image'}
      <Icon icon={ImageIcon} size="20" strokeWidth="1.25" testId="file-item-file-icon-{fileType}" />
    {:else if fileType === 'file'}
      <Icon icon={FileIcon} size="20" strokeWidth="1.25" testId="file-item-file-icon-{fileType}" />
    {:else if fileType === 'video'}
      <Icon icon={VideoIcon} size="20" strokeWidth="1.25" testId="file-item-file-icon-{fileType}" />
    {/if}

    <a class="body-sm hover:underline" href={fileUrl} target="_blank">{filename}</a>
  </div>

  <div class="flex gap-2">
    {#if fileItemContext && fileItemContext?.isLoading}
      <Icon
        class="animate-spin"
        data-testid="file-item-loading-icon"
        icon={LoaderCircleIcon}
        size={18}
      />
    {/if}

    <a data-testid="file-item-download-link" download={filename} href={downloadUrl} target="_blank">
      <Icon icon={Download} />
    </a>

    {#if allowRemoval && (isCustomFile(file) || (fileItemContext && fileItemContext?.customFile?.url))}
      <Button
        class="p-0"
        data-testid="file-item-remove-button"
        variant="ghost"
        on:click={handleRemoveClick}
      >
        <Icon height={18} icon={TrashIcon} width={18} />
      </Button>
    {/if}
  </div>
</div>
