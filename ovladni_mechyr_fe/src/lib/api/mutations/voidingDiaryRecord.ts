import { createMutation } from '@tanstack/svelte-query';
import { apiClient, type UpdatedPaths } from '../api';
import { queries, queryClient } from '../queries';
import { handleRequest } from '$lib/utils/request';
import * as m from '$paraglide/messages';

export function createDeleteVoidingDiaryRecordMutation() {
  return createMutation({
    mutationFn: async ({
      diaryId,
      recordId,
    }: {
      diaryId: UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}']['delete']['parameters']['path']['voiding_diary_id'];
      recordId: UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}']['delete']['parameters']['path']['id'];
    }) => {
      return await handleRequest(
        async () => {
          await apiClient.DELETE(
            '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}',
            {
              params: { path: { voiding_diary_id: diaryId, id: recordId } },
            }
          );

          queryClient.invalidateQueries({ queryKey: queries.voidingDiaries._def });
        },
        { toastSuccessText: m.successfulEntryDelete() }
      );
    },
  });
}
