import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const patientId = Number(params.patientId);
  const secondAppointmentId = Number(params.secondAppointmentId);

  queryClient.prefetchQuery(queries.users.detail(patientId));
  queryClient.prefetchQuery(queries.secondAppointments.detail(secondAppointmentId));

  return {
    pageParams: {
      ...params,
      patientId,
      secondAppointmentId,
    },
  };
}
