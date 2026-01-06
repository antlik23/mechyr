<script lang="ts">
  import * as VoidingDiary from '$lib/components/voiding-diary';

  export let data;
</script>

<VoidingDiary.Pages.Detail breadcrumbs={data.breadcrumbs} context="new" />
