<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { QueryResponseProperties } from '../types';
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import Form from './form.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';

  export let response: QueryResponseProperties;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 5 })}>
  {#if response.isLoading}
    <LoadingIndicator />
  {:else if response.isSuccess}
    {#if response.data}
      {@const doctor = response.data.user}

      <Title
        includeMeta={true}
        text={m.contactDoctor({
          doctorName: doctor.full_name || '-',
          doctorAddress: doctor.street_and_number || '-',
        })}
      />

      <Card.Root class="uzis-border max-w-prose">
        <Card.Content>
          <Form initialData={{ doctorId: doctor.id }} />
        </Card.Content>
      </Card.Root>
    {/if}
  {/if}
</div>
