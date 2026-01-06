<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import * as m from '$paraglide/messages';
  import Form from './form.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';

  export let entryFormId: ComponentProps<Form>['initialData']['entryFormId'];
</script>

<Card.Root class="uzis-border mx-auto max-w-[25rem]">
  <Card.Header>
    <Title includeMeta={true} text={m.registration()} />
  </Card.Header>
  <Card.Content>
    <Form initialData={{ entryFormId }} />
  </Card.Content>
</Card.Root>
