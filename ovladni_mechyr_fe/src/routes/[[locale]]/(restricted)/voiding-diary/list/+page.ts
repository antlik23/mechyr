import { queries, queryClient } from '$lib/api/queries';
import { MAXIMUM_ITEMS_PER_PAGE } from '$lib/api/queries/constants';

export async function load() {
  const voidingDiariesFilters: NonNullable<Parameters<typeof queries.voidingDiaries.list>['0']> = {
    items_per_page: MAXIMUM_ITEMS_PER_PAGE,
  };

  queryClient.prefetchQuery(queries.voidingDiaries.list(voidingDiariesFilters));

  return {
    voidingDiariesFilters,
  };
}
