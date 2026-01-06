<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import Card from '$lib/components/wrappers/Card.svelte';

  export let title: ComponentProps<Card>['title'];
  export let text: string;
</script>

<Card {title}>
  <p class="text-gray-700">{text}</p>
</Card>
