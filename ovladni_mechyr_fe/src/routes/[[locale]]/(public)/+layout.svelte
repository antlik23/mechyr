<script lang="ts">
  import Footer from '$lib/components/layout/Footer.svelte';
  import Header from '$lib/components/layout/Header.svelte';
</script>

<div class="flex min-h-screen flex-col gap-8 pb-4 lg:gap-16 lg:pb-8">
  <Header context="public" isMobileMenuOpen={false} />

  <main class="container">
    <slot />
  </main>
  <Footer />
</div>
