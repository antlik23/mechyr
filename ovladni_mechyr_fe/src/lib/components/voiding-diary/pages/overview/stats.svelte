<script lang="ts">
  import { languageTag } from '$paraglide/runtime';
  import * as Card from '$lib/components/ui/card';
  import Columns from '$lib/components/common/Columns.svelte';

  export let data: { title: string; value: number; unit: 'ml' }[];
</script>

<Card.Root class="uzis-border bg-accent/10">
  <Card.Content class="p-8 lg:p-8">
    <Columns class="sm:grid-cols-2 md:grid-cols-3" gap={6} number={3}>
      {#each data as item}
        <div class="grid gap-1.5 text-center">
          <span class="text-sm text-grays-500">{item.title}</span>

          <strong class="text-3xl/6 text-primary">
            {item.value.toLocaleString(languageTag())}

            {item.unit}
          </strong>
        </div>
      {/each}
    </Columns>
  </Card.Content>
</Card.Root>
