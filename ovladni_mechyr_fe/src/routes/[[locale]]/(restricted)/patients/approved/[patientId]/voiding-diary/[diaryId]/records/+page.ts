import { queries, queryClient } from '$lib/api/queries';

export async function load({ params }) {
  const diaryId = Number(params.diaryId);
  const patientId = Number(params.patientId);

  const voidingDiaryRecordsFilters: NonNullable<
    Parameters<ReturnType<typeof queries.voidingDiaries.detail>['_ctx']['records']>['0']
  > = {};

  queryClient.prefetchQuery(queries.voidingDiaries.detail(diaryId));
  queryClient.prefetchQuery(
    queries.voidingDiaries.detail(diaryId)._ctx.records(voidingDiaryRecordsFilters)
  );

  return {
    pageParams: {
      ...params,
      diaryId,
      patientId,
    },
    voidingDiaryRecordsFilters,
  };
}
