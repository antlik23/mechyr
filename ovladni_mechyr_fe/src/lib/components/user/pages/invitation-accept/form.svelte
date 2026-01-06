<script lang="ts">
  import type { RequestBodyJSON } from 'openapi-typescript-helpers';
  import type { User } from './types';
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { assert } from 'tsafe';
  import { invitationAcceptFormSchema, type InvitationAcceptFormSchemaTypes } from './form-schema';
  import { apiClient, type UpdatedPaths } from '$lib/api/api';
  import { handleRequest } from '$lib/utils/request';
  import { updateUser } from '../../data';
  import { goto } from '$app/navigation';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';

  export let initialData: {
    invitationToken:
      | RequestBodyJSON<UpdatedPaths['/api/v1/invitation']['put']>['user']['invitation_token']
      | null;
    user: User;
  };

  const defaultFormData: Partial<InvitationAcceptFormSchemaTypes> = {
    email: initialData.user.email,
  };

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(invitationAcceptFormSchema)), {
    SPA: true,
    validators: zodClient(invitationAcceptFormSchema),
    taintedMessage: () => taintedFormAlertDialogRef.taintedMessage(),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          assert(initialData.invitationToken, 'Available invitation token');

          const { data } = await apiClient.PUT('/api/v1/invitation', {
            body: {
              user: {
                password: form.data.password,
                password_confirmation: form.data.password_confirmation,
                doctor_attributes: { full_name: form.data.full_name },
                invitation_token: initialData.invitationToken,
              },
            },
          });

          if (!data) {
            throw new Error(m.unexpectedError());
          }

          updateUser(data);
          await goto(localizeRoute(route('/users/[userId]', { userId: data.user.id })));
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulInvitationAccept(),
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0 })} method="POST" use:enhance>
  <FormField name="email" disabled={true} {form} label={m.email()} type="email" />

  <FormField name="full_name" {form} label={'Jméno a Příjmení'} type="text" />

  <FormField name="password" {form} label={m.password()} type="password" />

  <FormField name="password_confirmation" {form} label={m.passwordAgain()} type="password" />

  <Button type="submit">{m.toSignUp()}</Button>

  <Form.RequiredIndicatorInfo />
</form>

<TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
