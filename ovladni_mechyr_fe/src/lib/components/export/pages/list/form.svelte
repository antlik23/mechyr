<script lang="ts">
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { assert } from 'tsafe';
  import { exportDataFormSchema, type ExportDataFormSchemaTypes } from './form-schema';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import { handleRequest } from '$lib/utils/request';
  import { getModelNameList, getTranslatedModelNameName } from './constants';
  import { apiClient } from '$lib/api/api';
  import { downloadBlob } from '$lib/utils/blob';
  import * as m from '$paraglide/messages';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import SelectField from '$lib/components/forms/wrappers/SelectField.svelte';
  import * as Form from '$lib/components/form';

  const defaultFormData = prepareSuperFormDefaultFormData<ExportDataFormSchemaTypes>({
    model_name: DEFAULT_STRING_VALUE,
  });

  const form = superForm(defaults(defaultFormData, zod(exportDataFormSchema)), {
    SPA: true,
    validators: zodClient(exportDataFormSchema),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          const { data } = await apiClient.GET('/api/v1/export', {
            params: { query: form.data },
            parseAs: 'blob',
          });

          assert(data, 'Available data');

          downloadBlob(data, getTranslatedModelNameName(form.data.model_name));
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulDataExport(),
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0, gap: 6 })} method="POST" use:enhance>
  <SelectField name="model_name" data={getModelNameList()} {form} label={m.data()} />

  <Button type="submit">
    {m.Export()}
  </Button>

  <Form.RequiredIndicatorInfo />
</form>
