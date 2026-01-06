import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const patientId = Number(params.patientId);
  const firstAppointmentId = Number(params.firstAppointmentId);

  queryClient.prefetchQuery(queries.users.detail(patientId));
  queryClient.prefetchQuery(queries.firstAppointments.detail(firstAppointmentId));

  return {
    pageParams: {
      ...params,
      patientId,
      firstAppointmentId,
    },
  };
}
