<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import { cn } from '$lib/utils';
  import { DEFAULT_ITEMS_PER_PAGE } from '$lib/api/queries/constants';
  import * as Pagination from '$lib/components/ui/pagination';

  let className: ComponentProps<Pagination.Root>['class'] = undefined;
  export { className as class };
  export let onPageChange: (page: number) => void;
  export let count: number;
  export let page: number;
  export let perPage = DEFAULT_ITEMS_PER_PAGE;
  export let siblingCount: ComponentProps<Pagination.Root>['siblingCount'] = 0;
</script>

<Pagination.Root
  class={cn('mx-0 w-auto grow', className)}
  count={Math.max(1, count)}
  {onPageChange}
  {page}
  {perPage}
  {siblingCount}
  let:currentPage
  let:pages
>
  <Pagination.Content>
    <Pagination.Item>
      <Pagination.PrevButton class="select-none" />
    </Pagination.Item>

    {#each pages as page (page.key)}
      {#if page.type === 'ellipsis'}
        <Pagination.Item>
          <Pagination.Ellipsis />
        </Pagination.Item>
      {:else}
        <Pagination.Item>
          <Pagination.Link class="select-none" isActive={currentPage == page.value} {page}>
            {page.value}
          </Pagination.Link>
        </Pagination.Item>
      {/if}
    {/each}

    <Pagination.Item>
      <Pagination.NextButton class="select-none" />
    </Pagination.Item>
  </Pagination.Content>
</Pagination.Root>
