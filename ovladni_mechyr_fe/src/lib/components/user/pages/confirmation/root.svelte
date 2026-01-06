<script lang="ts">
  import { onMount } from 'svelte';
  import { apiClient } from '$lib/api/api';
  import { persistedConfirmationUser } from './index';
  import { handleRequest } from '$lib/utils/request';
  import { goto } from '$app/navigation';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Card from '$lib/components/ui/card';

  export let confirmationToken: string | null;

  let isLoading = false;

  onMount(() => {
    if (!confirmationToken) return;

    handleRequest(
      async () => {
        await apiClient.POST('/api/v1/confirmation', {
          params: { query: { confirmation_token: confirmationToken } },
        });

        $persistedConfirmationUser = null;
        await goto(localizeRoute(route('/login')));
      },
      { toastSuccessText: m.successfulEmailConfirmation() }
    );
  });

  async function handleResendEmailClick() {
    if (isLoading) return;

    isLoading = true;
    await handleRequest(
      async () => {
        const email = $persistedConfirmationUser?.email;
        if (!email) {
          console.error('Missing email!');
          throw new Error(m.unexpectedError());
        }

        await apiClient.POST('/api/v1/resend_confirmation', { body: { user: { email } } });
      },
      { toastSuccessText: m.successfulConfirmationEmailSent() }
    );
    isLoading = false;
  }
</script>

<Card.Root class="uzis-border mx-auto max-w-[25rem]">
  <Card.Header>
    <Title includeMeta={true} text={m.confirmYourAccount()} />
  </Card.Header>
  <Card.Content class={columnsVariants({ number: 0, gap: 6 })}>
    <p>{m.confirmationEmailWillBeSentDescriptionText()}</p>

    <Title level="h2" text={m.didYouNotReceiveEmail()} />

    <p>{m.confirmationEmailNotReceivedDescriptionText()}</p>

    <Button on:click={handleResendEmailClick}>{m.resendEmail()}</Button>
  </Card.Content>
</Card.Root>
