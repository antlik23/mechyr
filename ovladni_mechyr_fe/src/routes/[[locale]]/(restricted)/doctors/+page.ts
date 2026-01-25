import { queries, queryClient } from '$lib/api/queries';

export async function load() {
  const doctorsFilters: NonNullable<Parameters<typeof queries.doctors.availableList>['0']> = {};

  queryClient.prefetchQuery(queries.doctors.availableList(doctorsFilters));

  return {
    doctorsFilters,
  };
}
