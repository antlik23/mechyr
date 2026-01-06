<script context="module" lang="ts">
  import type { BreadcrumbsData } from '$lib/components/ui-wrappers/Breadcrumbs.svelte';

  export type QuestionnaireBreadcrumbsData = BreadcrumbsData & { isLink: boolean };
</script>

<script lang="ts">
  import { cn } from '$lib/utils';
  import * as Breadcrumb from '$lib/components/ui/breadcrumb';

  export let breadcrumbs: QuestionnaireBreadcrumbsData[];
  export let currentUrlPathName: string;

  $: indexOfCurrent = breadcrumbs.findIndex(({ link }) => link === currentUrlPathName);
</script>

<Breadcrumb.Root class="mb-4">
  <Breadcrumb.List>
    {#each breadcrumbs as breadcrumb, index}
      {@const isFirst = index === 0}
      {@const isCurrent = currentUrlPathName === breadcrumb.link}

      {#if !isFirst}
        <Breadcrumb.Separator />
      {/if}

      <Breadcrumb.Item>
        {#if isCurrent}
          <Breadcrumb.Page class="font-semibold">{breadcrumb.name}</Breadcrumb.Page>
        {:else if index < indexOfCurrent}
          <Breadcrumb.Link class="text-foreground" href={breadcrumb.link}>
            {breadcrumb.name}
          </Breadcrumb.Link>
        {:else}
          <Breadcrumb.Link
            class={cn(
              breadcrumb.isLink && 'text-foreground',
              !breadcrumb.isLink && 'cursor-not-allowed'
            )}
            href={breadcrumb.isLink ? breadcrumb.link : undefined}
          >
            {breadcrumb.name}
          </Breadcrumb.Link>
        {/if}
      </Breadcrumb.Item>
    {/each}
  </Breadcrumb.List>
</Breadcrumb.Root>
