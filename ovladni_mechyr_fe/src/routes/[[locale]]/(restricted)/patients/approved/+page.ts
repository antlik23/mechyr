import { queries, queryClient } from '$lib/api/queries';

export async function load() {
  const patientsFilters: NonNullable<Parameters<typeof queries.patients.list>['0']> = {};

  queryClient.prefetchQuery(queries.patients.list(patientsFilters));

  return {
    patientsFilters,
  };
}
