import type { EntryFormResponse } from './types';
import { persisted } from 'svelte-persisted-store';

export const persistedEntryForm = persisted<EntryFormResponse | null>('entry-form-data', null, {
  syncTabs: true,
});
