import { persisted } from 'svelte-persisted-store';
import Root from './root.svelte';

export const persistedConfirmationUser = persisted<{ email: string } | null>(
  'confirmation-user-data',
  null
);

export { Root as Confirmation };
