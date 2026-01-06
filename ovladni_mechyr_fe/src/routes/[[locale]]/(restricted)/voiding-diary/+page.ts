import { queries, queryClient } from '$lib/api/queries';

export async function load() {
  queryClient.prefetchQuery(queries.voidingDiaries.latest);
  queryClient.prefetchQuery(queries.anamnestic.list());
}
