<script lang="ts">
  import { goto } from '$app/navigation';
  import { apiClient } from '$lib/api/api';
  import { queryClient } from '$lib/api/queries';
  import Button from '$lib/components/common/Button.svelte';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import * as Form from '$lib/components/form';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import TextareaField from '$lib/components/forms/wrappers/TextareaField.svelte';
  import * as Tooltip from '$lib/components/ui/tooltip';
  import * as Card from '$lib/components/ui/card';
  import { localizeRoute } from '$lib/i18n';
  import { route } from '$lib/ROUTES';
  import { handleRequest } from '$lib/utils/request';
  import * as m from '$paraglide/messages';
  import { InfoIcon } from 'lucide-svelte';
  import { defaults, superForm } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { contactDoctorFormSchema, type ContactDoctorFormSchemaTypes } from './form-schema';

  export let initialData: {
    doctorId: number;
  };

  export let hasCompletedDiary: boolean;

  const defaultFormData: Partial<ContactDoctorFormSchemaTypes> = {
    custom_message: `Dobrý den, chtěl/a bych se objednat na vyšetření.`,
    preferred_contact: 'email',
  };

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(contactDoctorFormSchema)), {
    SPA: true,
    validators: zodClient(contactDoctorFormSchema),
    taintedMessage: () => taintedFormAlertDialogRef.taintedMessage(),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          await apiClient.PUT('/api/v1/patients/request_assignment', {
            body: {
              patient: {
                doctor_id: initialData.doctorId,
                agreed_to_share_info: form.data.agreed_to_share_info,
              },
              email: {
                custom_message: form.data.custom_message,
                phone_number: form.data.phone_number,
                preferred_contact: form.data.preferred_contact,
              },
            },
          });

          queryClient.invalidateQueries();

          await goto(localizeRoute(route('/dashboard')));
        },
        {
          onError: cancel,
          toastSuccessText:
            'Váš mail byl odeslán, lékař Vás bude do 14 dní kontaktovat způsobem, který jste preferoval/a',
        }
      );
    },
  });

  const { enhance } = form;
</script>

<form class={columnsVariants({ number: 0, gap: 6 })} method="POST" use:enhance>
  {#if !hasCompletedDiary}
    <Card.Root class="border-amber-500 bg-amber-50">
      <Card.Content class="pt-6">
        <p class="text-sm text-amber-900">
          <strong>Upozornění:</strong> Pro stanovení léčby je nezbytný vyplněný mikční deník – bez toho
          lékař nedokáže stanovit léčbu. Doporučujeme nejprve vytvořit a dokončit mikční deník.
        </p>
      </Card.Content>
    </Card.Root>
  {/if}

  <div class="flex flex-col gap-2">
    <TextareaField
      name="custom_message"
      description={'Vážený pane doktore / Vážená paní doktorko,<br/><br/>v návaznosti na výsledky dotazníkového šetření mi bylo doporučeno odborné vyšetření.<br/>Dovoluji si Vás proto požádat o provedení tohoto vyšetření.'}
      {form}
      label={m.message()}
      placeholder={`Dobrý den, chtěl/a bych se objednat na vyšetření.`}
      rows={8}
    />
  </div>

  <FormField
    name="phone_number"
    {form}
    label={m.phoneNumber()}
    placeholder="+420 123 456 789"
    type="text"
  />

  <RadioGroupField
    name="preferred_contact"
    data={[
      { value: 'email', label: m.email() },
      { value: 'phone', label: m.phone() },
    ]}
    {form}
    label={m.preferredMethodOfContact()}
    showRequiredIndicator={false}
  />

  <p class="text-sm italic text-gray-600">
    Vyplnění telefonního čísla a preferovaného způsobu kontaktu je zcela dobrovolné. Údaje nejsou
    nikde ukládány, slouží pouze pro účely této zprávy a pro usnadnění administrace ze strany
    lékaře.
  </p>

  <div class="flex items-center gap-2">
    <FormField
      name="agreed_to_share_info"
      {form}
      label={m.iAgreeToSharingMyDataToDoctors()}
      type="checkbox"
    />
    <Tooltip.Root openDelay={100}>
      <Tooltip.Trigger class="text-blue-dark-900" aria-label={m.informations()}>
        <InfoIcon class="size-4" strokeWidth={3} />
      </Tooltip.Trigger>
      <Tooltip.Content class="max-w-prose">
        <p>Souhlasím se sdílením zdravotních a kontaktních údajů z tohoto webu vybranému lékaři.</p>
      </Tooltip.Content>
    </Tooltip.Root>
  </div>

  <Button type="submit">{m.send()}</Button>

  <Form.RequiredIndicatorInfo />
</form>

<TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
