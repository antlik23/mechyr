import type { CustomFile } from '$lib/components/cards/FileItem.svelte';
import { writable, type Writable } from 'svelte/store';
import { getContext, setContext } from 'svelte';

type State = Record<
  string,
  {
    isLoading: boolean;
    isNativeFile: boolean;
    customFile?: CustomFile;
  }
>;
type ContextState = Writable<State>;

const contextKey = 'fileItems';

export function setFileItemsContext(files: CustomFile[]) {
  const fileItems: State = {};

  for (const file of files) {
    fileItems[file.url] = {
      isLoading: false,
      isNativeFile: false,
    };
  }

  const fileItemsStore = writable<State>(fileItems);

  setContext(contextKey, fileItemsStore);

  return fileItemsStore;
}

export function getFileItemsContext() {
  return getContext<ContextState | undefined>(contextKey);
}
