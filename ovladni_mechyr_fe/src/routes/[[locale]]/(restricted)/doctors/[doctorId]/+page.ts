import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const doctorId = Number(params.doctorId);

  queryClient.prefetchQuery(queries.users.detail(doctorId));

  return {
    pageParams: {
      ...params,
      doctorId,
    },
  };
}
