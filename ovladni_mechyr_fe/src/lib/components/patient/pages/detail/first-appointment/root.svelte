<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { InitialAppointmentQueryResponseProperties, QueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Form from './form.svelte';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import { LoadingIndicator } from '$lib/components/loading';

  export let response: QueryResponseProperties | undefined = undefined;
  export let initialAppointmentResponse: InitialAppointmentQueryResponseProperties;
  export let patientId: ComponentProps<Form>['initialData']['patientId'];
  export let gender: ComponentProps<Form>['initialData']['gender'];
  export let context: NonNullable<ComponentProps<Form>['context']>;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0 })}>
  <Title includeMeta={true} text={m.personalVisitDiagnostics()} />

  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      {#if context === 'new'}
        {#if initialAppointmentResponse.isLoading}
          <LoadingIndicator />
        {:else if initialAppointmentResponse.isSuccess}
          {#if initialAppointmentResponse.data}
            <Form
              {context}
              initialData={{
                initialAppointment: initialAppointmentResponse.data.appointment_initial,
                patientId,
                gender,
              }}
            />
          {/if}
        {/if}
      {/if}

      {#if context !== 'new'}
        {#if response?.isLoading || initialAppointmentResponse.isLoading}
          <LoadingIndicator />
        {:else if response?.isSuccess && initialAppointmentResponse.isSuccess}
          {#if response.data && initialAppointmentResponse.data}
            <Form
              {context}
              initialData={{
                firstAppointment: response.data.appointment_first,
                initialAppointment: initialAppointmentResponse.data.appointment_initial,
                patientId,
                gender,
              }}
            />
          {/if}
        {/if}
      {/if}
    </Card.Content>
  </Card.Root>
</div>
