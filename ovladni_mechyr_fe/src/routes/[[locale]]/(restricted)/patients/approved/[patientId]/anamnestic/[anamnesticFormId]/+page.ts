import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const anamnesticFormId = Number(params.anamnesticFormId);

  queryClient.prefetchQuery(queries.anamnestic.detail(anamnesticFormId));

  return {
    pageParams: {
      ...params,
      anamnesticFormId,
    },
  };
}
