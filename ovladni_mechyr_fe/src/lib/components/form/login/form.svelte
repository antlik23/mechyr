<script lang="ts">
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { loginFormSchema } from './schema';
  import { apiClient } from '$lib/api/api';
  import { redirectAfterLogin } from '$lib/utils/routing';
  import { updateUser } from '$lib/components/user/data';
  import { handleRequest } from '$lib/utils/request';
  import * as m from '$paraglide/messages';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';

  const form = superForm(defaults(zod(loginFormSchema)), {
    SPA: true,
    validators: zodClient(loginFormSchema),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          const { data } = await apiClient.POST('/api/v1/login', {
            body: form.data,
          });

          if (!data) {
            throw new Error(m.unexpectedError());
          }

          updateUser(data);
          await redirectAfterLogin();
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulLogin(),
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0 })} method="POST" use:enhance>
  <FormField name="email" {form} label={m.email()} type="email" />

  <FormField name="password" {form} label={m.password()} type="password" />

  <Button type="submit">{m.logIn()}</Button>

  <Form.RequiredIndicatorInfo />
</form>
