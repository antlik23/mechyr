import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import { createMutation } from '@tanstack/svelte-query';
import { apiClient, type UpdatedPaths } from '../api';
import { queries, queryClient } from '../queries';
import { handleRequest } from '$lib/utils/request';
import * as m from '$paraglide/messages';

export function createChangeFullCapacityMutation() {
  return createMutation({
    mutationFn: async ({
      fullCapacity,
    }: {
      fullCapacity: RequestBodyJSON<
        UpdatedPaths['/api/v1/doctors/update_full_capacity']['put']
      >['doctor']['full_capacity'];
    }) => {
      return await handleRequest(
        async () => {
          await apiClient.PUT('/api/v1/doctors/update_full_capacity', {
            body: { doctor: { full_capacity: fullCapacity } },
          });

          queryClient.invalidateQueries({ queryKey: queries.users._def });
          queryClient.invalidateQueries({ queryKey: queries.patients._def });
        },
        { toastSuccessText: m.successfulFullCapacityChange() }
      );
    },
  });
}
