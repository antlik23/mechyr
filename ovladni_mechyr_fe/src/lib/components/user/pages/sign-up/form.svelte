<script lang="ts">
  import type { RequestBodyJSON } from 'openapi-typescript-helpers';
  import { slide } from 'svelte/transition';
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { signUpFormSchema, type SignUpFormSchemaTypes } from './form-schema';
  import { apiClient, type UpdatedPaths } from '$lib/api/api';
  import { handleRequest } from '$lib/utils/request';
  import { persistedConfirmationUser } from '../confirmation';
  import { DEFAULT_STRING_VALUE } from '$lib/utils/superForm';
  import { goto } from '$app/navigation';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import SelectField from '$lib/components/forms/wrappers/SelectField.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import { getGendersList } from '$lib/components/user/genders';
  import { getHasProstatesList } from '$lib/components/user/prostates';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';

  export let initialData: {
    entryFormId?: RequestBodyJSON<UpdatedPaths['/api/v1/signup']['post']>['entry_form'];
  };

  const defaultFormData: Partial<SignUpFormSchemaTypes> = { gender: DEFAULT_STRING_VALUE };

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(signUpFormSchema)), {
    SPA: true,
    validators: zodClient(signUpFormSchema),
    taintedMessage: () => taintedFormAlertDialogRef.taintedMessage(),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          if (!initialData.entryFormId) {
            throw new Error(m.unexpectedError());
          }

          await apiClient.POST('/api/v1/signup', {
            body: {
              user: {
                email: form.data.email,
                password: form.data.password,
                password_confirmation: form.data.password_confirmation,
                roles: ['patient'],
                patient_attributes: { gender: form.data.gender, other_gender: form.data.prostate },
              },
              entry_form: initialData.entryFormId,
            },
          });

          $persistedConfirmationUser = { email: form.data.email };
          await goto(localizeRoute(route('/confirmation')));
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulConfirmationEmailSent(),
        }
      );
    },
  });

  const { enhance, form: formData } = form;

  $: if ($formData.gender !== 'other') {
    $formData.prostate = undefined;
  }
</script>

<form class={columnsVariants({ number: 0, useSpacing: true })} method="POST" use:enhance>
  <FormField name="email" {form} label={m.email()} type="email" />

  <SelectField name="gender" data={getGendersList()} {form} label={m.gender()} />

  {#if $formData.gender === 'other'}
    <div transition:slide>
      <SelectField
        name="prostate"
        data={getHasProstatesList()}
        {form}
        label={m.youArePersonWithProstate()}
      />
    </div>
  {/if}

  <FormField name="password" {form} label={m.password()} type="password" />

  <FormField name="password_confirmation" {form} label={m.passwordAgain()} type="password" />

  <FormField
    name="consent"
    {form}
    label={`Souhlasím se <a class="underline" href="/souhlas-se-zpracovanim-osobnich-udaju.pdf" target="_blank">smluvními podmínkami</a> a se <a class="underline" href="/souhlas-se-zapojenim-do-projektu.pdf" target="_blank">zapojením do projektu</a>`}
    type="checkbox"
  />

  <Button type="submit">{m.toSignUp()}</Button>

  <Form.RequiredIndicatorInfo />
</form>

<TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
