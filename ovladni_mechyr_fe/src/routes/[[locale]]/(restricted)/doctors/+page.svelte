<script lang="ts">
  import { onMount, type ComponentEvents } from 'svelte';
  import { createQuery } from '@tanstack/svelte-query';
  import { queries, queryClient } from '$lib/api/queries';
  import { currentUser } from '$lib/components/user/data';
  import * as Doctor from '$lib/components/doctor';

  export let data;

  $: doctorsQuery = createQuery({
    ...queries.doctors.availableList(data.doctorsFilters),
    placeholderData: previousData,
  });

  let previousData: Awaited<
    ReturnType<ReturnType<typeof queries.doctors.availableList>['queryFn']>
  >;
  $: if ($doctorsQuery?.isSuccess) {
    previousData = $doctorsQuery.data;
  }

  onMount(() => {
    if (!$doctorsQuery.isSuccess || !$doctorsQuery.data) return;

    previousData = queryClient.getQueryData(
      queries.doctors.availableList(data.doctorsFilters).queryKey
    );
  });

  function handlePagination({
    detail: { page },
  }: ComponentEvents<Doctor.Pages.List>['pagination']) {
    data.doctorsFilters.page_param = page;
  }

  function handleSort({ detail: { sortKeys } }: ComponentEvents<Doctor.Pages.List>['sort']) {
    const { id, order } = sortKeys[0];

    // @ts-expect-error TODO: add type narrowing.
    data.doctorsFilters.sort_by = id;
    data.doctorsFilters.direction = order;
  }

  function handleFilter({
    detail: { filterValue, filterKey },
  }: ComponentEvents<Doctor.Pages.List>['filter']) {
    data.doctorsFilters.page_param = 1;

    data.doctorsFilters[filterKey] = filterValue;
  }
</script>

<Doctor.Pages.List
  filters={data.doctorsFilters}
  response={{
    data: $doctorsQuery.data,
    isLoading: $doctorsQuery.isLoading,
    isSuccess: $doctorsQuery.isSuccess,
    isError: $doctorsQuery.isError,
  }}
  userContext={$currentUser.isAdmin ? 'admin' : 'patient'}
  on:pagination={handlePagination}
  on:sort={handleSort}
  on:filter={handleFilter}
/>
