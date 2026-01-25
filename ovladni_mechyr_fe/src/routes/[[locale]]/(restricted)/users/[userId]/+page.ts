import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const userId = Number(params.userId);

  queryClient.prefetchQuery(queries.users.detail(userId));

  return {
    pageParams: {
      ...params,
      userId,
    },
  };
}
