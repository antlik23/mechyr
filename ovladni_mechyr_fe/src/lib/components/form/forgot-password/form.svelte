<script lang="ts">
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { forgotPasswordFormSchema } from './schema';
  import { apiClient } from '$lib/api/api';
  import { handleRequest } from '$lib/utils/request';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';

  const form = superForm(defaults(zod(forgotPasswordFormSchema)), {
    SPA: true,
    validators: zodClient(forgotPasswordFormSchema),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          await apiClient.POST('/api/v1/users/password_forgot', {
            body: {
              user: form.data,
            },
          });
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulForgottenPassword(),
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0 })} method="POST" use:enhance>
  <FormField name="email" {form} label={m.email()} type="email" />

  <Button type="submit">
    {m.sendToEmail()}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>
