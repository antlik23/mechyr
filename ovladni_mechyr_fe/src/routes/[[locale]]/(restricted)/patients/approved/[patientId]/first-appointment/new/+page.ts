import { queries, queryClient } from '$lib/api/queries/index.js';

export async function load({ params }) {
  const patientId = Number(params.patientId);

  queryClient.prefetchQuery(queries.users.detail(patientId));

  return {
    pageParams: {
      ...params,
      patientId,
    },
  };
}
