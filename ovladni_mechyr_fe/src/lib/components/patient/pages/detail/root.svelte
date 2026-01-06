<script lang="ts">
  import { goto } from '$app/navigation';
  import Button from '$lib/components/common/Button.svelte';
  import Columns, { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import QuestionnairesTable from '$lib/components/entry/pages/list/questionnaires-table.svelte';
  import VoidingDiariesTable from '$lib/components/entry/pages/list/voiding-diaries-table.svelte';
  import { LoadingIndicator } from '$lib/components/loading';
  import Breadcrumbs from '$lib/components/ui-wrappers/Breadcrumbs.svelte';
  import * as Card from '$lib/components/ui/card';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import { getTranslatedGender } from '$lib/components/user/genders';
  import Stats from '$lib/components/voiding-diary/pages/overview/stats.svelte';
  import Table from '$lib/components/voiding-diary/pages/overview/table.svelte';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { cn } from '$lib/utils';
  import * as m from '$paraglide/messages';
  import { languageTag } from '$paraglide/runtime';
  import type { ComponentProps } from 'svelte';
  import type {
    DetailQueryResponseProperties,
    LatestVoidingDiaryQueryResponseProperties,
    QuestionnairesQueryResponseProperties,
    VoidingDiariesQueryResponseProperties,
  } from './types';
  import { PencilIcon } from 'lucide-svelte';
  import Dialog from '$lib/components/dialogs/Dialog.svelte';
  import Form from '../list-to-be-approved/form.svelte';
  import type { PatientUnified } from '../list-to-be-approved/types';
  import { currentUser } from '$lib/components/user/data';

  export let detailResponse: DetailQueryResponseProperties;
  export let voidingDiariesResponse: VoidingDiariesQueryResponseProperties;
  export let latestVoidingDiaryResponse: LatestVoidingDiaryQueryResponseProperties;
  export let questionnairesResponse: QuestionnairesQueryResponseProperties;
  export let breadcrumbs: ComponentProps<Breadcrumbs>['breadcrumbs'];

  const EMPTY_VALUE_INDICATOR = '-';

  // TODO: move to UserData component
  let patientData: { value: string; label: string; class?: string; isEditable?: boolean }[] = [];
  $: if (detailResponse.data) {
    const patient = detailResponse.data.user;

    patientData = [
      {
        value: patient.next_appointment
          ? new Date(patient.next_appointment).toLocaleString(languageTag(), {
              dateStyle: 'medium',
              timeStyle: 'short',
            })
          : EMPTY_VALUE_INDICATOR,
        label: m.firstPersonalVisitDate(),
        isEditable: !!patient.next_appointment,
      },
      { value: patient.email, label: m.email() },
      {
        value: patient.gender ? getTranslatedGender(patient.gender) : EMPTY_VALUE_INDICATOR,
        label: m.gender(),
      },
    ];

    if (patient.other_gender) {
      patientData.push({
        value: [m.no(), m.yes()][Number(patient.other_gender === 'with_prostate')],
        label: m.personWithProstate(),
      });
    }

    patientData.push({
      value: patient.doctor_name ?? EMPTY_VALUE_INDICATOR,
      label: m.doctor(),
    });
  }

  let questionnairesTableData: ComponentProps<QuestionnairesTable>['responseData'] = [];
  $: {
    questionnairesTableData = [];
    if (Array.isArray(questionnairesResponse.data?.forms.oab_forms)) {
      questionnairesTableData.push(
        ...transformToTableResponse('oab_form', questionnairesResponse.data.forms.oab_forms)
      );
    }

    if (Array.isArray(questionnairesResponse.data?.forms.iciq_forms)) {
      questionnairesTableData.push(
        ...transformToTableResponse('iciq_form', questionnairesResponse.data.forms.iciq_forms)
      );
    }

    if (Array.isArray(questionnairesResponse.data?.forms.ipss_forms)) {
      questionnairesTableData.push(
        ...transformToTableResponse('ipss_form', questionnairesResponse.data.forms.ipss_forms)
      );
    }

    if (Array.isArray(questionnairesResponse.data?.forms.anamnestic_forms)) {
      questionnairesTableData.push(
        ...transformToTableResponse(
          'anamnestic_form',
          questionnairesResponse.data.forms.anamnestic_forms.map((anamnesticForm) => ({
            ...anamnesticForm,
            total_score: null,
          }))
        )
      );
    }

    questionnairesTableData = questionnairesTableData;
  }

  let initialPatientData: PatientUnified | null = null;
  $: {
    if (detailResponse?.data?.user?.patient_id !== undefined) {
      initialPatientData = detailResponse.data.user as PatientUnified;
    } else {
      initialPatientData = null;
    }
  }

  let isEditModalOpen = false;

  function transformToTableResponse(
    type: (typeof questionnairesTableData)[number]['type'],
    questionnaire:
      | NonNullable<(typeof questionnairesResponse)['data']>['forms']['oab_forms']
      | NonNullable<(typeof questionnairesResponse)['data']>['forms']['iciq_forms']
      | NonNullable<(typeof questionnairesResponse)['data']>['forms']['ipss_forms']
      | (NonNullable<
          (typeof questionnairesResponse)['data']
        >['forms']['anamnestic_forms'][number] & {
          total_score: null;
        })[]
  ) {
    return questionnaire.map(({ completion_timestamp, total_score, id }) => ({
      type,
      completion_timestamp,
      total_score,
      id,
    })) satisfies typeof questionnairesTableData;
  }
</script>

<Breadcrumbs {breadcrumbs} />

<div class={columnsVariants({ number: 0, gap: 6 })}>
  {#if detailResponse.isLoading || voidingDiariesResponse.isLoading || latestVoidingDiaryResponse.isLoading || questionnairesResponse.isLoading}
    <LoadingIndicator />
  {:else if detailResponse.isSuccess && voidingDiariesResponse.isSuccess && questionnairesResponse.isSuccess}
    {#if detailResponse.data && voidingDiariesResponse.data && questionnairesResponse.data}
      {@const patient = detailResponse.data.user}
      {@const voidingDiary = latestVoidingDiaryResponse.data?.voiding_diary}
      {@const initialAppointmentLink = patient.appointment_initial_id
        ? localizeRoute(
            route('/patients/approved/[patientId]/initial-appointment/[initialAppointmentId]', {
              patientId: patient.id,
              initialAppointmentId: patient.appointment_initial_id,
            })
          )
        : localizeRoute(
            route('/patients/approved/[patientId]/initial-appointment/new', {
              patientId: patient.id,
            })
          )}
      {@const firstAppointmentLink = patient.appointment_first_id
        ? localizeRoute(
            route('/patients/approved/[patientId]/first-appointment/[firstAppointmentId]', {
              patientId: patient.id,
              firstAppointmentId: patient.appointment_first_id,
            })
          )
        : localizeRoute(
            route('/patients/approved/[patientId]/first-appointment/new', {
              patientId: patient.id,
            })
          )}
      {@const secondAppointmentLink = patient.appointment_second_id
        ? localizeRoute(
            route('/patients/approved/[patientId]/second-appointment/[secondAppointmentId]', {
              patientId: patient.id,
              secondAppointmentId: patient.appointment_second_id,
            })
          )
        : localizeRoute(
            route('/patients/approved/[patientId]/second-appointment/new', {
              patientId: patient.id,
            })
          )}

      <Title
        includeMeta={true}
        text={m.detailOfPatientIdX({
          patientId: patient.patient_public_id || EMPTY_VALUE_INDICATOR,
        })}
      />

      <Columns gap={8} number={2}>
        <div class={columnsVariants({ number: 0, gap: 2 })}>
          {#each patientData as item}
            <div class="flex gap-6">
              <span class="min-w-56 text-lg/6 font-semibold">{item.label}</span>

              {#if item.isEditable}
                <div class="flex gap-2">
                  <span class={cn('text-lg', item.class)}>{item.value}</span>
                  <Button
                    class="min-h-full justify-start p-0 text-primary"
                    variant="none"
                    on:click={() => {
                      isEditModalOpen = true;
                    }}
                  >
                    <PencilIcon class="size-4 shrink-0" />
                  </Button>
                </div>
              {:else}
                <span class={cn('text-lg', item.class)}>{item.value}</span>
              {/if}
            </div>
          {/each}
        </div>

        <div class={cn(columnsVariants({ number: 0, gap: 0.5 }), 'justify-items-end self-end')}>
          <Button
            disabled={detailResponse.data.user.appointment_initial_id != undefined &&
              $currentUser.role !== 'admin'}
            on:click={() => goto(initialAppointmentLink)}>{m.remotePatientDiagnostics()}</Button
          >

          <Tooltip.Root openDelay={100}>
            <Tooltip.Trigger asChild let:builder>
              <Button
                builders={[builder]}
                disabled={detailResponse.data.user.appointment_initial_id == undefined}
                on:click={() => goto(firstAppointmentLink)}
                >{m.personalVisitDiagnostics()}
              </Button>
            </Tooltip.Trigger>
            <Tooltip.Content
              class={cn(detailResponse.data.user.appointment_initial_id !== undefined && 'hidden')}
            >
              <p>Není vyplněna vzdálená diagnostika pacietna</p>
            </Tooltip.Content>
          </Tooltip.Root>

          <Tooltip.Root openDelay={100}>
            <Tooltip.Trigger asChild let:builder>
              <Button
                builders={[builder]}
                disabled={detailResponse.data.user.appointment_first_id == undefined ||
                  !detailResponse.data.user.allowed_to_create_second_appointment}
                on:click={() => goto(secondAppointmentLink)}
              >
                {m.followUpVisitAfterMonths({ monthsAmount: 3 })}
              </Button>
            </Tooltip.Trigger>
            <Tooltip.Content
              class={cn(
                detailResponse.data.user.appointment_first_id !== undefined &&
                  detailResponse.data.user.allowed_to_create_second_appointment &&
                  'hidden'
              )}
            >
              {#if detailResponse.data.user.appointment_first_id == undefined}
                <p>Není vyplněna diagnostika pacienta při první osobní návštěvě</p>
              {:else if !detailResponse.data.user.allowed_to_create_second_appointment}
                <p>Diagnóza pacienta je bez OAB</p>
              {/if}
            </Tooltip.Content>
          </Tooltip.Root>
        </div>
      </Columns>

      {#if voidingDiary}
        <Title text={m.evaluationOfVoiding()} />

        <Stats
          data={[
            {
              value: voidingDiary.max_voided_volume,
              unit: 'ml',
              title: m.maximumVoidingVolume(),
            },
            {
              value: voidingDiary.median_voided_volume,
              unit: 'ml',
              title: m.medianVoidingVolume(),
            },
            {
              value: voidingDiary.average_voided_volume,
              unit: 'ml',
              title: m.meanVoidingVolume(),
            },
          ]}
        />

        <!-- TODO: move to paraglide messages -->
        <Table
          responseData={[
            {
              label: m.date(),
              value: new Date(voidingDiary.diary_start_date).toLocaleDateString(languageTag()),
            },
            {
              label: 'Objem - příjem',
              value: `${voidingDiary.fluid_intake_volume.toLocaleString(languageTag())} ml`,
              tooltipText:
                'Celkový příjem tekutin dosažený od první zaznamenané mikce až do následující ranní mikce. Pokud nastal příjem méně než 30 minut před první zaznamenanou ranní mikcí, započítává se již do dalšího dne.',
            },
            {
              label: 'Objem - mikce',
              value: `${voidingDiary.voided_volume.toLocaleString(languageTag())} ml`,
              tooltipText:
                'Zobrazuje celkový objem mikce od druhé mikce po první ranní mikci následujícího dne (včetně).',
            },
            {
              label: 'Objem - mikce noc',
              value: `${voidingDiary.nocturnal_voided_volume.toLocaleString(languageTag())} ml`,
              tooltipText:
                'Zobrazuje celkový objem mikcí, které proběhly v noci, respektive pacient před i po močení spal (v noci se probudil a šel na záchod a znovu spát) a k tomu navíc první ranní mikce.',
            },
            {
              label: 'Polyurie',
              value: voidingDiary.polyuria,
              tooltipText:
                'Nadměrné vylučování moči, které vede k hojné a časté mikci. Byla definována jako více než 40 ml/kg tělesné hmotnosti během 24 h.',
            },
            {
              label: 'Index noční polyurie',
              value: `${voidingDiary.nocturnal_polyuria_index}%`,
              tooltipText: 'Podíl noční mikce na celkové mikci.',
            },
            {
              label: 'Frekvence',
              value: voidingDiary.frequency,
              tooltipText:
                'Počet mikcí v průběhu celého dne (den i noc) od první mikce v daném dni do poslední mikce, která nastala v průběhu spánku a první mikce po probuzení.',
            },
            {
              label: 'Nykturie',
              value: voidingDiary.nocturnal_voids,
              tooltipText:
                'Počet mikcí, které proběhly v průběhu spánku, tj. pacient se probudí, jde se vymočit a poté znovu usne.',
            },
            {
              label: 'Urgence',
              value: voidingDiary.urgencies,
              tooltipText:
                'Počet mikcí v průběhu celého dne (den i noc) od první ranní mikce v daném dni do poslední mikce, která nastala v průběhu spánku a první po probuzení.',
            },
            { label: 'Urgence s únikem moči', value: voidingDiary.urgent_incontinence },
            {
              label: 'Inkontinence',
              value: voidingDiary.incontinence_episodes,
              tooltipText:
                'Počet úniků moči bez varování během celého dne a noci, nezapočítávají se urgence, jedná se výhradně o počet úniků bez varování.',
            },
          ]}
        />
      {/if}

      <Title text={m.entries()} />

      <Columns number={2} verticalAlign="start">
        <Card.Root>
          <Card.Header>
            <Title text={m.questionnaires()} />
          </Card.Header>

          <Card.Content>
            <QuestionnairesTable
              patientId={patient.id}
              responseData={questionnairesTableData}
              userContext="doctor"
            />
          </Card.Content>
        </Card.Root>

        <Card.Root>
          <Card.Header>
            <Title text={m.voidingDiary()} />
          </Card.Header>

          <Card.Content>
            <VoidingDiariesTable
              patientId={patient.id}
              responseData={voidingDiariesResponse.data.voiding_diaries}
              userContext="doctor"
            >
              <svelte:fragment slot="paginationRow">
                <Button
                  href={localizeRoute(
                    route('/patients/approved/[patientId]/voiding-diary/new', {
                      patientId: patient.id,
                    })
                  )}
                  variant="outline"
                >
                  {m.enterDataFromPaperDiary()}
                </Button>
              </svelte:fragment>
            </VoidingDiariesTable>
          </Card.Content>
        </Card.Root>
      </Columns>
    {/if}
  {/if}
</div>

{#if initialPatientData}
  <Dialog open={isEditModalOpen} on:close={() => (isEditModalOpen = false)}>
    <svelte:fragment slot="header">Upravit</svelte:fragment>

    <Form
      context="edit"
      initialData={{ patient: initialPatientData }}
      on:success={() => (isEditModalOpen = false)}
    />
  </Dialog>
{/if}
