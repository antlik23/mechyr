import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const ipssFormId = Number(params.ipssFormId);

  queryClient.prefetchQuery(queries.ipss.detail(ipssFormId));

  return {
    pageParams: {
      ...params,
      ipssFormId,
    },
  };
}
