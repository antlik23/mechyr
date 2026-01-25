import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const patientId = Number(params.patientId);

  queryClient.prefetchQuery(queries.users.detail(patientId));
  queryClient.prefetchQuery(queries.users.detail(patientId)._ctx.forms);
  queryClient.prefetchQuery(queries.users.detail(patientId)._ctx.diaries);

  return {
    pageParams: {
      ...params,
      patientId,
    },
  };
}
