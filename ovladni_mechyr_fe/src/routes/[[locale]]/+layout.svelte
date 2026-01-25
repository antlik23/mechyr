<script lang="ts">
  import '../../app.css';
  import '@fontsource-variable/noto-sans/wdth.css';
  import { ProgressBar } from '@prgm/sveltekit-progress-bar';

  import { QueryClientProvider } from '@tanstack/svelte-query';
  import { SvelteQueryDevtools } from '@tanstack/svelte-query-devtools';

  import { ParaglideJS } from '@inlang/paraglide-js-adapter-sveltekit';
  import { i18n } from '$lib/i18n';

  import { Toaster } from '$lib/components/ui/sonner';
  import { afterNavigate, beforeNavigate } from '$app/navigation';
  import { queryClient } from '$lib/api/queries';
  import { page } from '$app/stores';
  import { handleClientRedirect } from '$lib/utils/routing';
  import { progressBar } from '$lib/stores/progressBar';

  let progressBarRef: ProgressBar;

  $: if (progressBarRef) {
    $progressBar = progressBarRef;
  }

  beforeNavigate(() => {
    progressBarRef.start();
  });
  afterNavigate(() => {
    progressBarRef.complete();
  });

  handleClientRedirect($page.url);
</script>

<ProgressBar bind:this={progressBarRef} class="text-primary/90" zIndex={100} />

<QueryClientProvider client={queryClient}>
  <ParaglideJS {i18n}>
    <Toaster />

    <slot />
  </ParaglideJS>
  <SvelteQueryDevtools />
</QueryClientProvider>
