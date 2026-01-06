<script lang="ts">
  import type { User } from './types';
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { doctorFormSchema, type DoctorFormSchemaTypes } from './doctor-form-schema';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import { handleRequest } from '$lib/utils/request';
  import { queries, queryClient } from '$lib/api/queries';
  import { apiClient } from '$lib/api/api';
  import * as m from '$paraglide/messages';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import TextareaField from '$lib/components/forms/wrappers/TextareaField.svelte';
  import * as Form from '$lib/components/form';
  import { goto } from '$app/navigation';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';

  export let initialData: {
    user: User;
  };
  export let context: 'read' | 'edit';

  const defaultFormData = prepareSuperFormDefaultFormData<DoctorFormSchemaTypes>({
    full_name: initialData.user.full_name ?? undefined,
    workplace: initialData.user.workplace ?? undefined,
    contact_email: initialData.user.contact_email ?? undefined,
    contact_phone: initialData.user.contact_phone ?? undefined,
    web: initialData.user.web ?? undefined,
    city: initialData.user.city ?? undefined,
    working_hours: initialData.user.working_hours ?? undefined,
    postal_code: initialData.user.postal_code ?? DEFAULT_STRING_VALUE,
    street_and_number: initialData.user.street_and_number ?? undefined,
  });

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(doctorFormSchema)), {
    SPA: true,
    resetForm: false,
    validators: zodClient(doctorFormSchema),
    taintedMessage: () => taintedFormAlertDialogRef.taintedMessage(),
    async onUpdate({ form, cancel }) {
      if (!form.valid || context === 'read') return;

      await handleRequest(
        async () => {
          await apiClient.PATCH('/api/v1/users/{id}', {
            params: { path: { id: initialData.user.id } },
            body: { user: { doctor_attributes: form.data } },
          });

          queryClient.invalidateQueries({ queryKey: queries.users._def });
          await goto(localizeRoute(route('/patients/approved')));
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulDataChange(),
        }
      );
    },
  });

  const { enhance } = form;

  $: disabled = context === 'read';
</script>

<form class={columnsVariants({ number: 0, gap: 6 })} method="POST" use:enhance>
  <!-- TODO: move to paraglide messages -->
  <FormField name="full_name" {disabled} {form} label={m.name()} type="text" />

  <FormField name="contact_email" {disabled} {form} label={'Kontaktní e-mail'} type="email" />

  <FormField name="contact_phone" {disabled} {form} label={m.phoneNumber()} type="tel" />

  <FormField name="web" {disabled} {form} label={'Web'} type="text" />

  <FormField name="workplace" {disabled} {form} label={'Pracoviště'} type="text" />

  <TextareaField name="working_hours" {disabled} {form} label={m.officeHours()} />

  <FormField name="city" {disabled} {form} label={m.city()} type="text" />

  <FormField name="street_and_number" {disabled} {form} label={m.address()} type="text" />

  <FormField name="postal_code" {disabled} {form} label={'PSČ'} type="number" />

  <Button {disabled} type="submit">
    {m.save()}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>

<TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
