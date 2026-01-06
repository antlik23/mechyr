<script lang="ts">
  import { persistedEntryForm } from '$lib/components/form/entry';
  import * as User from '$lib/components/user';
</script>

<User.Pages.SignUp entryFormId={$persistedEntryForm?.entry_form.id} />
