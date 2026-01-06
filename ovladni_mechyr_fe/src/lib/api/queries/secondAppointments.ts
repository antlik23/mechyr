import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';

export const secondAppointments = createQueryKeys('secondAppointments', {
  detail: (
    secondAppointmentId: UpdatedPaths['/api/v1/appointment_seconds/{id}']['get']['parameters']['path']['id']
  ) => ({
    queryKey: [secondAppointmentId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/appointment_seconds/{id}', {
        params: { path: { id: secondAppointmentId } },
      });
      return data;
    },
  }),
});
