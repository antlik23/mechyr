<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import Header from '$lib/components/layout/Header.svelte';
  import Sidebar from '$lib/components/layout/Sidebar.svelte';

  let isMobileMenuOpen: ComponentProps<Header>['isMobileMenuOpen'] = false;
</script>

<div class="flex min-h-screen flex-col">
  <Header context="restricted" bind:isMobileMenuOpen />

  <main class="relative grid flex-grow lg:grid-cols-5 xl:grid-cols-6">
    <Sidebar bind:isMobileMenuOpen />

    <div class="relative p-4 lg:col-start-2 lg:col-end-6 xl:col-end-7">
      <slot />
    </div>
  </main>
</div>
