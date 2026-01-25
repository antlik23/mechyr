<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import * as Card from '$lib/components/ui/card';
  import { Results } from '../index';

  export let points: ComponentProps<Results.Score>['points'];
  export let title: ComponentProps<Results.Score>['title'] = undefined;
  export let completedDate: ComponentProps<Results.Completed>['completedDate'];
</script>

<Card.Root>
  <Card.Content class="grid gap-6">
    <Results.Root>
      <Results.Score {points} {title} />

      <Results.Completed {completedDate} />
    </Results.Root>

    <Results.Explanations.Root>
      <slot />
    </Results.Explanations.Root>
  </Card.Content>
</Card.Root>
