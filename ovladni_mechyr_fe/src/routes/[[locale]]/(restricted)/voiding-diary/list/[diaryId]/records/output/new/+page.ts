import { queryClient, queries } from '$lib/api/queries';

export async function load({ params }) {
  const diaryId = Number(params.diaryId);

  queryClient.prefetchQuery(queries.voidingDiaries.detail(diaryId));

  return {
    pageParams: {
      ...params,
      diaryId,
    },
  };
}
