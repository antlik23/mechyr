import { queries, queryClient } from '$lib/api/queries';

export async function load() {
  const patientsToBeApprovedFilters: NonNullable<
    Parameters<typeof queries.patients.listToBeApproved>['0']
  > = {};

  queryClient.prefetchQuery(queries.patients.listToBeApproved(patientsToBeApprovedFilters));

  return {
    patientsToBeApprovedFilters,
  };
}
