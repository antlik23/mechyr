<script lang="ts">
  import type { ComponentProps } from 'svelte';
  import type { QueryResponseProperties } from './types';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Button from '$lib/components/common/Button.svelte';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Card from '$lib/components/ui/card';
  import Form from './form.svelte';
  import { PencilIcon } from 'lucide-svelte';
  import DoctorImg from '$lib/assets/images/doktorka.png?url';

  export let response: QueryResponseProperties | undefined = undefined;
  export let patientId: NonNullable<ComponentProps<Form>['initialData']>['patientId'] = undefined;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];
  export let context: NonNullable<ComponentProps<Form>['context']>;
  export let userContext: ComponentProps<Form>['userContext'] = 'patient';

  const titleNames: Record<typeof context, () => string> = {
    new: m.newVoidingDiary,
    read: m.voidingDiary,
    edit: m.editVoidingDiary,
  };
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 5 })}>
  <Title containerClasses="justify-between" includeMeta={true} text={titleNames[context]()}>
    {@const diaryId = response?.data?.voiding_diary.id}

    {#if context === 'read' && diaryId}
      {@const editLink =
        userContext !== 'patient' && patientId
          ? localizeRoute(
              route('/patients/approved/[patientId]/voiding-diary/[diaryId]/edit', {
                patientId,
                diaryId,
              })
            )
          : localizeRoute(
              route('/voiding-diary/list/[diaryId]/edit', {
                diaryId,
              })
            )}

      <Button
        href={editLink}
        prependIcon={PencilIcon}
        prependIconProps={{ class: 'size-4 [&_svg]:size-[inherit]' }}
      >
        {m.edit()}
      </Button>
    {/if}
  </Title>

  <Card.Root class="uzis-border max-w-prose">
    <Card.Content>
      {#if context === 'new'}
        <Form initialData={{ patientId }} {userContext} />
      {/if}

      {#if context !== 'new'}
        {#if response?.isLoading}
          <LoadingIndicator />
        {:else if response?.isSuccess}
          {#if response.data}
            <Form
              {context}
              initialData={{ voidingDiary: response.data.voiding_diary, patientId }}
              {userContext}
            />
          {/if}
        {/if}
      {/if}
    </Card.Content>
  </Card.Root>
  <!-- svelte-ignore a11y-invalid-attribute -->
  <a class="bottom-0 ml-auto block md:sticky" href="#" title="Nahoru"
    ><img
      class="pointer-events-none w-80 max-w-full transition-all lg:w-96 2xl:w-[553px]"
      alt="illustr"
      src={DoctorImg}
    /></a
  >
</div>
