import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';

export const initialAppointments = createQueryKeys('initialAppointments', {
  detail: (
    initialAppointmentId: UpdatedPaths['/api/v1/appointment_initials/{id}']['get']['parameters']['path']['id']
  ) => ({
    queryKey: [initialAppointmentId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/appointment_initials/{id}', {
        params: { path: { id: initialAppointmentId } },
      });
      return data;
    },
  }),
});
