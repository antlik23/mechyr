import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';

export const firstAppointments = createQueryKeys('firstAppointments', {
  detail: (
    firstAppointmentId: UpdatedPaths['/api/v1/appointment_firsts/{id}']['get']['parameters']['path']['id']
  ) => ({
    queryKey: [firstAppointmentId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/appointment_firsts/{id}', {
        params: { path: { id: firstAppointmentId } },
      });
      return data;
    },
  }),
});
