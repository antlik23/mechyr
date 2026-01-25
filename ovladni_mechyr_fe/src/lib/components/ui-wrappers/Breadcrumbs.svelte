<script context="module" lang="ts">
  export type BreadcrumbsData = {
    name: string;
    link: string;
  };
</script>

<script lang="ts">
  import * as Breadcrumb from '$lib/components/ui/breadcrumb';

  export let breadcrumbs: BreadcrumbsData[];
</script>

<Breadcrumb.Root class="mb-4">
  <Breadcrumb.List>
    {#each breadcrumbs as breadcrumb, index}
      {@const isFirst = index === 0}
      {@const isLast = index === breadcrumbs.length - 1}

      {#if !isFirst}
        <Breadcrumb.Separator />
      {/if}

      <Breadcrumb.Item>
        {#if !isLast}
          <Breadcrumb.Link href={breadcrumb.link}>
            {breadcrumb.name}
          </Breadcrumb.Link>
        {:else}
          <Breadcrumb.Page>{breadcrumb.name}</Breadcrumb.Page>
        {/if}
      </Breadcrumb.Item>
    {/each}
  </Breadcrumb.List>
</Breadcrumb.Root>
