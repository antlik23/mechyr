import { browser, dev } from '$app/environment';
import { QueryClient } from '@tanstack/svelte-query';
import { mergeQueryKeys } from '@lukemorales/query-key-factory';
import { redirectAfterSessionExpired } from '$lib/utils/routing';
import { users } from './users';
import { oab } from './oab';
import { iciq } from './iciq';
import { ipss } from './ipss';
import { anamnestic } from './anamnestic';
import { doctors } from './doctors';
import { patients } from './patients';
import { voidingDiaries } from './voidingDiaries';
import { initialAppointments } from './initialAppointments';
import { firstAppointments } from './firstAppointments';
import { secondAppointments } from './secondAppointments';

export const queries = mergeQueryKeys(
  users,
  oab,
  iciq,
  ipss,
  anamnestic,
  doctors,
  patients,
  voidingDiaries,
  initialAppointments,
  firstAppointments,
  secondAppointments
);

export const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      enabled: browser,
      refetchOnWindowFocus: !dev,
      staleTime: 5 * 60 * 1000, // 5 minutes.
      retry: (failureCount, error) => {
        // Allow retry for first 401.
        if (error?.cause === 401 && failureCount >= 1) {
          redirectAfterSessionExpired();

          return false;
        }

        // Max 2 retries.
        return failureCount < 1;
      },
      retryDelay(failureCount, error) {
        // For first 401 retry immediately.
        if (error.cause === 401 && failureCount < 1) {
          return 0;
        }

        // Default retry delay.
        return Math.min(1000 * 2 ** failureCount, 30000);
      },
    },
  },
});
