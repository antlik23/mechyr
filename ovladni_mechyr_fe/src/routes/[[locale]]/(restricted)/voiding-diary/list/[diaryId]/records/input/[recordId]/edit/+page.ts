import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const diaryId = Number(params.diaryId);
  const recordId = Number(params.recordId);

  queryClient.prefetchQuery(queries.voidingDiaries.detail(diaryId));
  queryClient.prefetchQuery(queries.voidingDiaries.detail(diaryId)._ctx.recordDetail(recordId));

  return {
    pageParams: {
      ...params,
      diaryId,
      recordId,
    },
  };
}
