import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const oabFormId = Number(params.oabFormId);

  queryClient.prefetchQuery(queries.oab.detail(oabFormId));

  return {
    pageParams: {
      ...params,
      oabFormId,
    },
  };
}
