<script lang="ts">
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { resetPasswordFormSchema } from './schema';
  import { apiClient } from '$lib/api/api';
  import { goto } from '$app/navigation';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { handleRequest } from '$lib/utils/request';
  import * as m from '$paraglide/messages';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import * as Form from '$lib/components/form';

  export let initialData: {
    token: string | null;
  };

  const form = superForm(defaults(zod(resetPasswordFormSchema)), {
    SPA: true,
    validators: zodClient(resetPasswordFormSchema),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          if (!initialData.token) {
            throw new Error(m.unexpectedError());
          }

          await apiClient.POST('/api/v1/users/password_reset', {
            body: {
              user: {
                ...form.data,
                token: initialData.token,
              },
            },
          });

          await goto(localizeRoute(route('/login')));
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulPasswordReset(),
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0 })} method="POST" use:enhance>
  <FormField name="password" {form} label={m.newPassword()} type="password" />

  <FormField name="password_confirmation" {form} label={m.newPasswordAgain()} type="password" />

  <Button type="submit">
    {m.save()}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>
