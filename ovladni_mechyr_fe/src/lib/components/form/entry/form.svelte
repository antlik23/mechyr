<script lang="ts">
  import type { EntryFormResponse } from './types';
  import type { RadioGroupData } from '$lib/components/form/types';
  import { createEventDispatcher } from 'svelte';
  import { slide } from 'svelte/transition';
  import { superForm, defaults } from 'sveltekit-superforms';
  import { zod, zodClient } from 'sveltekit-superforms/adapters';
  import { assert } from 'tsafe';
  import { entryFormSchema, type EntryFormSchemaTypes } from './schema';
  import { localizeRoute } from '$lib/i18n';
  import { apiClient } from '$lib/api/api';
  import { handleRequest } from '$lib/utils/request';
  import { DEFAULT_STRING_VALUE, prepareSuperFormDefaultFormData } from '$lib/utils/superForm';
  import { goto } from '$app/navigation';
  import { route } from '$lib/ROUTES';
  import * as m from '$paraglide/messages';
  import { columnsVariants } from '$lib/components/common/Columns.svelte';
  import FormField from '$lib/components/forms/wrappers/FormField.svelte';
  import Button from '$lib/components/common/Button.svelte';
  import RadioGroupField from '$lib/components/forms/wrappers/RadioGroupField.svelte';
  import TaintedFormAlertDialog from '$lib/components/dialogs/TaintedFormAlertDialog.svelte';
  import * as Form from '$lib/components/form';
  import * as Card from '$lib/components/ui/card';
  import * as Questionnaire from '$lib/components/questionnaire';
  import { labelVariants } from '$lib/components/ui/label/label.svelte';
  import * as RadioGroup from '$lib/components/ui/radio-group';
  import { Label } from '$lib/components/ui/label';

  const dispatch = createEventDispatcher<{
    success: EntryFormResponse;
  }>();

  const defaultFormData = prepareSuperFormDefaultFormData<EntryFormSchemaTypes>({
    urination_frequency_issue: DEFAULT_STRING_VALUE,
    urinations_per_day: DEFAULT_STRING_VALUE,
    fluid_intake_volume: DEFAULT_STRING_VALUE,
  });

  let issuePresent: boolean | undefined = undefined;

  let taintedFormAlertDialogRef: TaintedFormAlertDialog;

  const form = superForm(defaults(defaultFormData, zod(entryFormSchema)), {
    SPA: true,
    resetForm: false,
    validators: zodClient(entryFormSchema),
    taintedMessage: () => taintedFormAlertDialogRef.taintedMessage(),
    async onUpdate({ form, cancel }) {
      if (!form.valid) return;

      await handleRequest(
        async () => {
          const { data } = await apiClient.POST('/api/v1/entry_forms', {
            body: { entry_form: form.data },
          });

          assert(data, 'Available data');

          dispatch('success', data);

          issuePresent = data.entry_form.issue_present;
        },
        {
          onError: cancel,
          toastSuccessText: m.successfulEntryFormComplete(),
        }
      );
    },
  });

  const { enhance } = form;

  // TODO: move to paraglide messages
  const hasIssuesSignUpOptions: RadioGroupData[] = [
    { value: 'true', label: 'Mám problém, chci se účastnit projektu' },
    {
      value: 'false',
      label: 'Mám problém, nechci se účastnit projektu.',
    },
  ];

  const noIssuesSignUpOptions: RadioGroupData[] = [
    { value: 'true', label: 'Nemám problém, chci se preventivně otestovat' },
    {
      value: 'false',
      label: 'Nemám problém, nechci se preventivně otestovat',
    },
  ];

  function handleSignUpOptionsValueChange(selectedValue: string) {
    if (selectedValue === 'true') {
      goto(localizeRoute(route('/sign-up')));
    } else if (issuePresent) {
      window.location.href = 'https://www.urogynekologie.com';
    }
  }
</script>

<form class={columnsVariants({ number: 0, useSpacing: true })} method="POST" use:enhance>
  <RadioGroupField
    name="urination_frequency_issue"
    coerceTo="boolean"
    data={[
      { value: 'true', label: m.yes() },
      { value: 'false', label: m.no() },
    ]}
    {form}
    label={m.hasFrequentUrinationBeenBotheringYouForALongTime()}
  />

  <FormField
    name="urinations_per_day"
    {form}
    label={m.pleaseEstimateHowManyTimesYouUrinateIn24Hours()}
    type="number"
  />

  <FormField
    name="fluid_intake_volume"
    {form}
    label={m.pleaseEstimateHowManyLitersOfAllLiquidsYouDrinkIn24Hours()}
    type="number"
  />

  <!-- TODO: move to paraglide messages -->
  {#if issuePresent === undefined}
    <Button type="submit">
      {'Vyhodnotit'}
    </Button>

    <p class="text-sm text-muted-foreground">
      Kliknutím na tlačítko souhlasíte se sdílením zadaných údajů.
    </p>
  {/if}

  {#if issuePresent !== undefined}
    <div transition:slide>
      <Card.Root>
        <Card.Content>
          <Questionnaire.Results.Explanations.Description>
            {#if issuePresent}
              Na základě Vámi vyplněných otázek se může jednat o Syndrom hyperaktivního močového
              měchýře (OAB). Prosíme o registraci do projektu. V případě, že se podezření na OAB v
              následujících dotaznících potvrdí, budete mít možnost se přednostně objednat k lékaři.
              Prosíme o vyplnění všech těchto dotazníků, které jsou důležité pro případné stanovení
              diagnózy lékařem.
            {:else}
              Na základě Vámi vyplněných otázek zde není podezření na Syndrom hyperaktivního
              močového měchýře (OAB). V případě jakýchkoliv pochybností konzultujte Váš zdravotní
              stav s lékařem.
            {/if}
          </Questionnaire.Results.Explanations.Description>
        </Card.Content>
      </Card.Root>
    </div>

    <div class="grid gap-2" transition:slide>
      <fieldset class={columnsVariants({ number: 0, gap: 2, useSpacing: true })}>
        <legend class={labelVariants()}>
          {'Přejete si pokračovat?'}
        </legend>

        <RadioGroup.Root onValueChange={handleSignUpOptionsValueChange}>
          {#each issuePresent ? hasIssuesSignUpOptions : noIssuesSignUpOptions as { value, label }}
            {@const radioGroupItemId = `sign-up-${value}`}

            <div class="flex items-center">
              <RadioGroup.Item id={radioGroupItemId} {value} />
              <RadioGroup.Input {value} />

              <Label for={radioGroupItemId}>{label}</Label>
            </div>
          {/each}
        </RadioGroup.Root>
      </fieldset>

      {#if issuePresent}
        <p class="text-sm text-muted-foreground">
          Pokud nemáte zájem o účast v projektu, i tak vám doporučujeme absolvovat konzultaci u
          odborníka, viz
          <a class="underline" href="https://www.urogynekologie.com" target="_blank">
            urogynekologie.com
          </a>
        </p>
      {/if}
    </div>
  {/if}

  <Form.RequiredIndicatorInfo />
</form>

<TaintedFormAlertDialog bind:this={taintedFormAlertDialogRef} />
