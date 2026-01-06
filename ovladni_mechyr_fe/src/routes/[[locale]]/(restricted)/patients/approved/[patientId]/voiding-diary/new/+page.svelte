<script lang="ts">
  import * as VoidingDiary from '$lib/components/voiding-diary';

  export let data;
  $: ({ pageParams } = data);
</script>

<VoidingDiary.Pages.Detail
  breadcrumbs={data.breadcrumbs}
  context="new"
  patientId={pageParams.patientId}
  userContext="doctor"
/>
