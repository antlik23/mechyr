import { createMutation } from '@tanstack/svelte-query';
import { apiClient, type UpdatedPaths } from '../api';
import { queries, queryClient } from '../queries';
import { handleRequest } from '$lib/utils/request';
import * as m from '$paraglide/messages';

export function createRejectPatientMutation() {
  return createMutation({
    mutationFn: async ({
      patientId,
    }: {
      patientId: UpdatedPaths['/api/v1/patients/reject/{id}']['put']['parameters']['path']['id'];
    }) => {
      return await handleRequest(
        async () => {
          await apiClient.PUT('/api/v1/patients/reject/{id}', {
            params: { path: { id: patientId } },
          });

          queryClient.invalidateQueries({ queryKey: queries.patients._def });
        },
        { toastSuccessText: m.successfulPatientReject() }
      );
    },
  });
}
