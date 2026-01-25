import '$lib/polyfills';
import type { MergeDeep, IsEqual, StringKeyOf, SetOptional, Except, PartialDeep } from 'type-fest';
import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import type { paths } from './types';
import type { CurrentUser, User } from '$lib/components/user/types';
import { PUBLIC_API_URL } from '$env/static/public';
import createClient, { type Middleware } from 'openapi-fetch';
import { updateUser, persistedUser } from '$lib/components/user/data';
import { redirectAfterSessionExpired } from '$lib/utils/routing';

/**
 * Merge by "paths"-like object to override.
 *
 * Merge by "EmptyObject" from "type-fest" when apiClient shows "ERROR: UpdatedPaths is equal to paths".
 */
export type UpdatedPaths = MergeDeep<
  paths,
  {
    '/api/v1/invitation': {
      /** accept invitation */
      put: {
        responses: {
          /** @description accepted */
          202: {
            content: {
              'application/json': {
                user: {
                  patient_public_id: null;
                };
              };
            };
          };
        };
      };
    };
    '/api/v1/voiding_diaries': {
      /** create voiding_diaries */
      post: {
        requestBody: {
          content: {
            'application/json': {
              voiding_diary: {
                /** Format: time */
                bedtime_day_two?: string;
                /** Format: time */
                wake_up_time_day_two?: string;
              };
            };
          };
        };
      };
    };
    '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records': {
      /** create voiding record */
      post: {
        requestBody: {
          content: {
            'application/json': {
              voiding_record: SetOptional<
                RequestBodyJSON<
                  paths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records']['post']
                >['voiding_record'],
                keyof Except<
                  RequestBodyJSON<
                    paths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records']['post']
                  >['voiding_record'],
                  'recorded_at'
                >
              >;
            };
          };
        };
      };
    };
    '/api/v1/users/{id}': {
      /** update user */
      patch: {
        requestBody: {
          content: {
            'application/json': {
              user: PartialDeep<RequestBodyJSON<paths['/api/v1/users/{id}']['patch']>['user']>;
            };
          };
        };
      };
    };
    '/api/v1/appointment_initials': {
      /** create appointment_initial */
      post: {
        requestBody: {
          content: {
            'application/json': {
              appointment_initial: SetOptional<
                RequestBodyJSON<
                  paths['/api/v1/appointment_initials']['post']
                >['appointment_initial'],
                | 'alternative_diagnosis'
                | 'oab_treatment_criteria_met'
                | 'initiate_pharmacological_treatment'
                | 'prescribed_medication'
                | 'dosage'
                | 'dosage_unit'
                | 'alternative_dosage_unit'
                | 'reason_treatment_not_started'
                | 'alternative_treatment_details'
              >;
            };
          };
        };
      };
    };
  }
>;

type UpdatedPathsOrError =
  IsEqual<paths, UpdatedPaths> extends false
    ? UpdatedPaths
    : Record<'ERROR: UpdatedPaths is equal to paths', never>;
export const apiClient = createClient<UpdatedPathsOrError>({ baseUrl: PUBLIC_API_URL });

const publicRoutes: StringKeyOf<UpdatedPaths>[] = [
  '/api/v1/login',
  '/api/v1/refresh',
  '/api/v1/users/password_forgot',
  '/api/v1/users/password_reset',
];

let userStore: User = null;
persistedUser.subscribe(($user) => (userStore = $user));

let lastTriedRefreshToken: CurrentUser['refresh_token'];

// Deferred promise.
let { promise: refreshingTokenPromise, resolve: resolveRefreshingTokenPromise } =
  Promise.withResolvers();
resolveRefreshingTokenPromise(undefined);

const authMiddleware: Middleware = {
  async onRequest({ request }) {
    // Skip public routes.
    if (publicRoutes.some((pathname) => new URL(request.url).pathname.startsWith(pathname))) return;

    await refreshingTokenPromise;

    const accessToken = userStore?.access_token;
    if (!accessToken) return;

    request.headers.set('Authorization', `Bearer ${accessToken}`);

    return request;
  },
  async onResponse({ response }) {
    if (!response.ok) {
      if (
        response.status === 401 &&
        userStore?.access_token &&
        userStore?.refresh_token &&
        lastTriedRefreshToken !== userStore?.refresh_token
      ) {
        lastTriedRefreshToken = userStore.refresh_token;

        // Create new deferred promise.
        ({ promise: refreshingTokenPromise, resolve: resolveRefreshingTokenPromise } =
          Promise.withResolvers());

        await refreshLoggedInUser();

        resolveRefreshingTokenPromise(undefined);
      }

      let error: string;

      if (response.headers.get('Content-Type')?.includes('application/json')) {
        error = (await response.clone().json()).error;
      } else {
        error = await response.clone().text();
      }

      throw new Error(error, { cause: response.status });
    }

    return response;
  },
};

apiClient.use(authMiddleware);

export async function refreshLoggedInUser() {
  try {
    const { data, error } = await apiClient.POST('/api/v1/refresh', {
      headers: { Authorization: `Bearer ${userStore?.refresh_token}` },
    });

    if (data) {
      updateUser(data);
    } else if (error) {
      console.error(error);
    }
  } catch (error) {
    // Expired refresh token.
    if (error instanceof Error && error.message === 'invalid_token') {
      redirectAfterSessionExpired();
    } else {
      console.error(error);
    }
  }
}
