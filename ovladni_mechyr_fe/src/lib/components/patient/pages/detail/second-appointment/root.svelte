<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { FirstAppointmentQueryResponseProperties, QueryResponseProperties } from './types';
  import * as m from '$paraglide/messages';
  import Title from '$lib/components/common/Title.svelte';
  import * as Card from '$lib/components/ui/card';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Form from './form.svelte';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import { LoadingIndicator } from '$lib/components/loading';

  export let response: QueryResponseProperties | undefined = undefined;
  export let firstAppointmentResponse: FirstAppointmentQueryResponseProperties;
  export let patientId: ComponentProps<Form>['initialData']['patientId'];
  export let context: NonNullable<ComponentProps<Form>['context']>;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0 })}>
  <Title includeMeta={true} text={m.followUpVisitAfterMonths({ monthsAmount: 3 })} />

  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      {#if context === 'new'}
        {#if firstAppointmentResponse.isLoading}
          <LoadingIndicator />
        {:else if firstAppointmentResponse.isSuccess}
          {#if firstAppointmentResponse.data}
            <Form
              {context}
              initialData={{
                firstAppointment: firstAppointmentResponse.data.appointment_first,
                patientId,
              }}
            />
          {/if}
        {/if}
      {/if}

      {#if context !== 'new'}
        {#if response?.isLoading || firstAppointmentResponse.isLoading}
          <LoadingIndicator />
        {:else if response?.isSuccess && firstAppointmentResponse.isSuccess}
          {#if response.data && firstAppointmentResponse.data}
            <Form
              {context}
              initialData={{
                secondAppointment: response.data.appointment_second,
                firstAppointment: firstAppointmentResponse.data.appointment_first,
                patientId,
              }}
            />
          {/if}
        {/if}
      {/if}
    </Card.Content>
  </Card.Root>
</div>
