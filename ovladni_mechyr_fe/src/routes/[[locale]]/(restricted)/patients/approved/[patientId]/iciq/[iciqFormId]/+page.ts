import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const iciqFormId = Number(params.iciqFormId);

  queryClient.prefetchQuery(queries.iciq.detail(iciqFormId));

  return {
    pageParams: {
      ...params,
      iciqFormId,
    },
  };
}
