<script lang="ts">
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import Form from '$lib/components/user/pages/invitation-send/form.svelte';
  import * as Card from '$lib/components/ui/card';
</script>

<div class={columnsVariants({ number: 0, gap: 6 })}>
  <Title includeMeta={true} text={m.newDoctor()} />

  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      <Form />
    </Card.Content>
  </Card.Root>
</div>
