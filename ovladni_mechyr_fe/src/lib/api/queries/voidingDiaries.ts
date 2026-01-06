import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';
import { DEFAULT_ITEMS_PER_PAGE } from './constants';

export const voidingDiaries = createQueryKeys('voidingDiaries', {
  list: (
    queryParameters?: UpdatedPaths['/api/v1/voiding_diaries']['get']['parameters']['query']
  ) => {
    const {
      page_param = 1,
      items_per_page = DEFAULT_ITEMS_PER_PAGE,
      ...restQueryParameters
    } = queryParameters ?? {};

    return {
      // eslint-disable-next-line @tanstack/query/exhaustive-deps
      queryKey: [page_param, { items_per_page, ...restQueryParameters }],
      queryFn: async () => {
        const { data } = await apiClient.GET('/api/v1/voiding_diaries', {
          params: { query: { ...queryParameters, page_param, items_per_page } },
        });
        return data;
      },
    };
  },
  latest: {
    queryKey: null,
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/voiding_diaries/latest_diary');
      return data;
    },
  },
  detail: (
    diaryId: UpdatedPaths['/api/v1/voiding_diaries/{id}']['get']['parameters']['path']['id']
  ) => ({
    queryKey: [diaryId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/voiding_diaries/{id}', {
        params: { path: { id: diaryId } },
      });
      return data;
    },
    contextQueries: {
      records: (
        queryParameters?: UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records']['get']['parameters']['query']
      ) => {
        const {
          page_param = 1,
          items_per_page = DEFAULT_ITEMS_PER_PAGE,
          ...restQueryParameters
        } = queryParameters ?? {};

        return {
          // eslint-disable-next-line @tanstack/query/exhaustive-deps
          queryKey: [page_param, { items_per_page, ...restQueryParameters }],
          queryFn: async () => {
            const { data } = await apiClient.GET(
              '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records',
              {
                params: {
                  path: { voiding_diary_id: diaryId },
                  query: { ...queryParameters, page_param, items_per_page },
                },
              }
            );
            return data;
          },
        };
      },
      recordDetail: (
        recordId: UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}']['get']['parameters']['path']['id']
      ) => ({
        // eslint-disable-next-line @tanstack/query/exhaustive-deps
        queryKey: [recordId],
        queryFn: async () => {
          const { data } = await apiClient.GET(
            '/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}',
            {
              params: { path: { voiding_diary_id: diaryId, id: recordId } },
            }
          );
          return data;
        },
      }),
    },
  }),
});
