<script lang="ts">
  import type { HTMLInputAttributes } from 'svelte/elements';
  import { createEventDispatcher, type ComponentProps } from 'svelte';
  import { getFileItemsContext } from '$lib/context/FileItem';
  import { hashFile } from '$lib/utils/hashing';
  import * as m from '$paraglide/messages.js';
  import Button from '$lib/components/common/Button.svelte';
  import FileItem, {
    type CustomFile,
    type FileOrCustom,
  } from '$lib/components/cards/FileItem.svelte';
  import Card from '$lib/components/wrappers/Card.svelte';

  export let cardTitle: ComponentProps<Card>['title'] = m.documents();
  export let required: HTMLInputAttributes['required'] = undefined;
  export let filesAcceptedTypes: string[] = [];
  export let initialFiles: CustomFile[] = [];
  export let multiple: HTMLInputAttributes['multiple'] = true;
  export let readOnly: boolean = false;
  export let allowRemoval: ComponentProps<FileItem>['allowRemoval'] = true;

  const dispatch = createEventDispatcher<{
    uploadedFiles: {
      files: File[];
    };
  }>();

  const fileItems = getFileItemsContext();

  let fileInput: HTMLInputElement;
  let newFiles: File[] = [];

  let files: FileOrCustom[] = [];
  $: mergeFiles(initialFiles, newFiles).then((mergedFiles) => {
    files = mergedFiles;
  });

  async function mergeFiles(customFiles: typeof initialFiles, nativeFiles: typeof newFiles) {
    if (nativeFiles.length === 0) return customFiles;

    const mergedFiles: typeof files = [];

    for (const customFile of customFiles) {
      let wasUploaded = false;
      for (const nativeFile of nativeFiles) {
        const nativeFileHash = await hashFile(nativeFile);
        const fileItemContext = $fileItems?.[nativeFileHash];
        if (!fileItemContext || !fileItemContext?.customFile) continue;

        if (fileItemContext.customFile.url === customFile.url) {
          wasUploaded = true;
          break;
        }
      }

      if (!wasUploaded) {
        mergedFiles.push(customFile);
      }
    }

    for (let i = nativeFiles.length - 1; i >= 0; i--) {
      const nativeFile = nativeFiles[i];
      const nativeFileHash = await hashFile(nativeFile);
      const fileItemContext = $fileItems?.[nativeFileHash];
      if (!fileItemContext || !fileItemContext?.customFile) continue;

      // Deleted removed native files.
      if (!customFiles.some((customFile) => customFile.url === fileItemContext.customFile?.url)) {
        nativeFiles.splice(i, 1);

        delete $fileItems[nativeFileHash];
      }
    }

    mergedFiles.push(...nativeFiles);

    return mergedFiles;
  }

  function handleChange() {
    const selectedFiles = Array.from(fileInput.files ?? []);
    newFiles = [...newFiles, ...selectedFiles];

    dispatch('uploadedFiles', { files: selectedFiles });
    fileInput.value = '';
  }

  function getFileName(file: ComponentProps<FileItem>['file'], index: number): string {
    if ('name' in file) {
      return file.name + '_' + file.lastModified;
    } else {
      return file.filename + '_' + index;
    }
  }
</script>

<Card title={cardTitle}>
  {#if initialFiles.length || newFiles.length}
    <div class="flex flex-col">
      {#each files as file, index (getFileName(file, index))}
        <FileItem
          allowRemoval={readOnly !== undefined ? !readOnly : allowRemoval}
          {file}
          on:remove
        />
      {/each}
    </div>
  {:else}
    <div class="text-sm text-gray-600">{m.noFileUploaded()}</div>
  {/if}

  {#if !readOnly}
    <div>
      <input
        bind:this={fileInput}
        accept={filesAcceptedTypes.length > 0 ? filesAcceptedTypes.join() : null}
        hidden
        {multiple}
        {required}
        type="file"
        on:change={handleChange}
      />

      <Button variant="outline" on:click={() => fileInput.click()}>
        {m.uploadFile()}
      </Button>
    </div>
  {/if}
</Card>
