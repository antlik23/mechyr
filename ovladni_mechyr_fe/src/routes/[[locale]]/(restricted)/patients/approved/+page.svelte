<script lang="ts">
  import type { IsAny } from 'type-fest';
  import { onMount, type ComponentEvents } from 'svelte';
  import { createQuery } from '@tanstack/svelte-query';
  import { assert, type Equals } from 'tsafe';
  import { queries, queryClient } from '$lib/api/queries';
  import { setObjectValue } from '$lib/utils/object.js';
  import { currentUser } from '$lib/components/user/data.js';
  import * as Patient from '$lib/components/patient';

  export let data;

  const userQuery = createQuery({
    ...queries.users.detail($currentUser.id),
    enabled: $currentUser.isDoctor,
  });

  $: patientsQuery = createQuery({
    ...queries.patients.list(data.patientsFilters),
    placeholderData: previousData,
  });

  let previousData: Awaited<ReturnType<ReturnType<typeof queries.patients.list>['queryFn']>>;
  $: if ($patientsQuery?.isSuccess) {
    previousData = $patientsQuery.data;
  }

  onMount(() => {
    if (!$patientsQuery.isSuccess || !$patientsQuery.data) return;

    previousData = queryClient.getQueryData(queries.patients.list(data.patientsFilters).queryKey);
  });

  function handlePagination({
    detail: { page },
  }: ComponentEvents<Patient.Pages.List>['pagination']) {
    assert<Equals<IsAny<Parameters<typeof handlePagination>['0']['detail']>, false>>();

    data.patientsFilters.page_param = page;
  }

  function handleSort({ detail: { sortKeys } }: ComponentEvents<Patient.Pages.List>['sort']) {
    assert<Equals<IsAny<Parameters<typeof handleSort>['0']['detail']>, false>>();

    const { id, order } = sortKeys[0];

    // @ts-expect-error TODO: add type narrowing.
    data.patientsFilters.sort_by = id;
    data.patientsFilters.direction = order;
  }

  function handleFilter({
    detail: { filterValue, filterKey },
  }: ComponentEvents<Patient.Pages.List>['filter']) {
    assert<Equals<IsAny<Parameters<typeof handleFilter>['0']['detail']>, false>>();

    data.patientsFilters.page_param = 1;

    setObjectValue(data.patientsFilters, filterKey, filterValue);
    data.patientsFilters = data.patientsFilters;
  }
</script>

<Patient.Pages.List
  filters={data.patientsFilters}
  response={{
    data: $patientsQuery.data,
    isLoading: $patientsQuery.isLoading,
    isSuccess: $patientsQuery.isSuccess,
    isError: $patientsQuery.isError,
  }}
  userResponse={$currentUser.isDoctor
    ? {
        data: $userQuery.data,
        isLoading: $userQuery.isLoading,
        isSuccess: $userQuery.isSuccess,
        isError: $userQuery.isError,
      }
    : undefined}
  on:pagination={handlePagination}
  on:sort={handleSort}
  on:filter={handleFilter}
/>
