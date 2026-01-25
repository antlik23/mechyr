<script lang="ts">
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import * as Card from '$lib/components/ui/card';
  import * as Form from '$lib/components/form/index';
</script>

<Card.Root class="uzis-border mx-auto max-w-[25rem]">
  <Card.Header>
    <Title includeMeta={true} text={m.login()} />
  </Card.Header>
  <Card.Content class="grid gap-4">
    <Form.Login />

    <Button
      class="justify-self-start"
      href={localizeRoute(route('/forgot-password'))}
      size="none"
      variant="link"
    >
      {m.forgotPassword()}
    </Button>
  </Card.Content>
</Card.Root>
