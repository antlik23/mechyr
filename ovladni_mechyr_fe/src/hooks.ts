import type { Handle } from '@sveltejs/kit';
import { i18n } from '$lib/i18n.js';
import { handleServerRedirect } from '$lib/utils/routing';

export const reroute = i18n.reroute();

export const handle: Handle = async ({ event, resolve }) => {
  handleServerRedirect(event.url);

  return resolve(event);
};
