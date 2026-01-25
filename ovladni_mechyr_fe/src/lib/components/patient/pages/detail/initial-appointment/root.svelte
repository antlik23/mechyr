<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { QueryResponseProperties, QueryUserResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Form from './form.svelte';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import { LoadingIndicator } from '$lib/components/loading';

  export let response: QueryResponseProperties | undefined = undefined;
  export let userResponse: QueryUserResponseProperties | undefined = undefined;
  export let patientId: ComponentProps<Form>['initialData']['patientId'];
  export let context: NonNullable<ComponentProps<Form>['context']>;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0 })}>
  <Title includeMeta={true} text={m.remotePatientDiagnostics()} />
  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      {#if context === 'new'}
        {#if userResponse?.isLoading}
          <LoadingIndicator />
        {:else if userResponse?.isSuccess}
          {#if userResponse.data}
            <Form {context} initialData={{ patientId, user: userResponse.data.user }} />
          {/if}
        {/if}
      {/if}

      {#if context !== 'new'}
        {#if response?.isLoading || userResponse?.isLoading}
          <LoadingIndicator />
        {:else if response?.isSuccess && userResponse?.isSuccess}
          {#if response.data && userResponse.data}
            <Form
              {context}
              initialData={{
                initialAppointment: response.data.appointment_initial,
                patientId,
                user: userResponse.data.user,
              }}
            />
          {/if}
        {/if}
      {/if}
    </Card.Content>
  </Card.Root>
</div>
