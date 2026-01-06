import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const diaryId = Number(params.diaryId);
  const patientId = Number(params.patientId);

  queryClient.prefetchQuery(queries.voidingDiaries.detail(diaryId));

  return {
    pageParams: {
      ...params,
      diaryId,
      patientId,
    },
  };
}
