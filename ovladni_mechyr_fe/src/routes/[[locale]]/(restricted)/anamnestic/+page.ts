import { queries, queryClient } from '$lib/api/queries';

export async function load() {
  queryClient.prefetchQuery(queries.anamnestic.list());
  queryClient.prefetchQuery(queries.iciq.list());
  queryClient.prefetchQuery(queries.ipss.list());
}
