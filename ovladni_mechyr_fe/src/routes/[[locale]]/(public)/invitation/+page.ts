import { queries, queryClient } from '$lib/api/queries';

export async function load({ url }) {
  const invitationToken = url.searchParams.get('invitation_token');

  if (invitationToken) {
    queryClient.prefetchQuery(queries.users.findByToken(invitationToken));
  }
}
