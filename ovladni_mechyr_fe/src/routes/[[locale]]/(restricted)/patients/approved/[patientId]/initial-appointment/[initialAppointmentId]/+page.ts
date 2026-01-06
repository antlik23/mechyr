import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const patientId = Number(params.patientId);
  const initialAppointmentId = Number(params.initialAppointmentId);

  queryClient.prefetchQuery(queries.initialAppointments.detail(initialAppointmentId));

  return {
    pageParams: {
      ...params,
      patientId,
      initialAppointmentId,
    },
  };
}
