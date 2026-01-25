<script lang="ts">
  import { apiClient } from '$lib/api/api';
  import { queries, queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import Title from '$lib/components/common/Title.svelte';
  import * as Form from '$lib/components/form';
  import DatePickerField from '$lib/components/form/form-fields/DatePickerField.svelte';
  import TimePickerField from '$lib/components/form/form-fields/TimePickerField.svelte';
  import * as Card from '$lib/components/ui/card';
  import { handleRequest } from '$lib/utils/request';
  import * as m from '$paraglide/messages';
  import { createEventDispatcher } from 'svelte';
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { approvePatientFormSchema, type ApprovePatientFormSchemaTypes } from './form-schema';
  import { prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import type { PatientUnified } from './types';
  import { format, parseISO } from 'date-fns';

  export let initialData: {
    patient: PatientUnified;
  };
  export let context: 'new' | 'edit' = 'new';

  const dispatch = createEventDispatcher<{
    success: null;
  }>();

  const defaultFormData: ApprovePatientFormSchemaTypes =
    context === 'edit' && initialData && initialData.patient.next_appointment
      ? prepareSuperFormDefaultFormData<ApprovePatientFormSchemaTypes>({
          next_appointment: format(parseISO(initialData.patient.next_appointment), 'yyyy-MM-dd'),
          nextAppointmentTime: format(parseISO(initialData.patient.next_appointment), 'HH:mm:ss'),
        })
      : {
          next_appointment: '',
          nextAppointmentTime: '',
        };

  const form = superForm(defaults(defaultFormData, zod(approvePatientFormSchema)), {
    SPA: true,
    validators: zodClient(approvePatientFormSchema),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          if (!initialData.patient.patient_id) return;
          await apiClient.PUT('/api/v1/patients/approve/{id}', {
            params: { path: { id: initialData.patient.patient_id } },
            body: {
              patient: {
                next_appointment: new Date(
                  `${form.data.next_appointment}T${form.data.nextAppointmentTime}`
                ).toISOString(),
              },
            },
          });

          if (context === 'new') queryClient.invalidateQueries({ queryKey: queries.patients._def });
          if (context === 'edit') queryClient.invalidateQueries({ queryKey: queries.users._def });

          dispatch('success');
        },
        {
          onError: cancel,
          toastSuccessText:
            context === 'new' ? m.successfulPatientAccept() : m.successfulDataChange(),
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0, gap: 6 })} method="POST" use:enhance>
  <Card.Root>
    <Card.Header>
      <Title level="h2" text={m.firstPersonalVisitDate()} />
    </Card.Header>
    <Card.Content class={columnsVariants({ number: 0, gap: 6 })}>
      <DatePickerField
        name="next_appointment"
        {form}
        label={m.date()}
        popoverProps={{ portal: 'body' }}
      />

      <TimePickerField
        name="nextAppointmentTime"
        {form}
        label={m.time()}
        popoverProps={{ portal: 'body' }}
      />
    </Card.Content>
  </Card.Root>

  <Button type="submit">
    {context === 'new' ? m.accept() : m.save()}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>
