<script lang="ts">
  import { createQuery } from '@tanstack/svelte-query';
  import { queries } from '$lib/api/queries';
  import { currentUser } from '$lib/components/user/data.js';
  import * as Questionnaire from '$lib/components/questionnaire';

  export let data;

  const oabQuery = createQuery(queries.oab.list());
</script>

<Questionnaire.Oab.Pages.Detail
  continueLink={data.continueLink}
  formGender={$currentUser.gender}
  response={{
    data: $oabQuery.data,
    isLoading: $oabQuery.isLoading,
    isSuccess: $oabQuery.isSuccess,
    isError: $oabQuery.isError,
  }}
/>
