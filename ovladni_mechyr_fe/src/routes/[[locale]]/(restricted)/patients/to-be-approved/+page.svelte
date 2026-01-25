<script lang="ts">
  import type { IsAny } from 'type-fest';
  import { onMount, type ComponentEvents } from 'svelte';
  import { createQuery } from '@tanstack/svelte-query';
  import { assert, type Equals } from 'tsafe';
  import { queries, queryClient } from '$lib/api/queries';
  import * as Patient from '$lib/components/patient';

  export let data;

  $: patientsToBeApprovedQuery = createQuery({
    ...queries.patients.listToBeApproved(data.patientsToBeApprovedFilters),
    placeholderData: previousData,
  });

  let previousData: Awaited<
    ReturnType<ReturnType<typeof queries.patients.listToBeApproved>['queryFn']>
  >;
  $: if ($patientsToBeApprovedQuery?.isSuccess) {
    previousData = $patientsToBeApprovedQuery.data;
  }

  onMount(() => {
    if (!$patientsToBeApprovedQuery.isSuccess || !$patientsToBeApprovedQuery.data) return;

    previousData = queryClient.getQueryData(
      queries.patients.listToBeApproved(data.patientsToBeApprovedFilters).queryKey
    );
  });

  function handlePagination({
    detail: { page },
  }: ComponentEvents<Patient.Pages.ListToBeApproved>['pagination']) {
    assert<Equals<IsAny<Parameters<typeof handlePagination>['0']['detail']>, false>>();

    data.patientsToBeApprovedFilters.page_param = page;
  }

  function handleSort({
    detail: { sortKeys },
  }: ComponentEvents<Patient.Pages.ListToBeApproved>['sort']) {
    assert<Equals<IsAny<Parameters<typeof handleSort>['0']['detail']>, false>>();

    const { id, order } = sortKeys[0];

    // @ts-expect-error TODO: add type narrowing.
    data.patientsToBeApprovedFilters.sort_by = id;
    data.patientsToBeApprovedFilters.direction = order;
  }
</script>

<Patient.Pages.ListToBeApproved
  response={{
    data: $patientsToBeApprovedQuery.data,
    isLoading: $patientsToBeApprovedQuery.isLoading,
    isSuccess: $patientsToBeApprovedQuery.isSuccess,
    isError: $patientsToBeApprovedQuery.isError,
  }}
  on:pagination={handlePagination}
  on:sort={handleSort}
/>
