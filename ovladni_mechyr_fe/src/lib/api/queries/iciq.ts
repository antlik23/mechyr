import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';
import { DEFAULT_ITEMS_PER_PAGE } from './constants';

export const iciq = createQueryKeys('iciq', {
  list: (queryParameters?: UpdatedPaths['/api/v1/iciq_forms']['get']['parameters']['query']) => {
    const {
      page_param = 1,
      items_per_page = DEFAULT_ITEMS_PER_PAGE,
      ...restQueryParameters
    } = queryParameters ?? {};

    return {
      // eslint-disable-next-line @tanstack/query/exhaustive-deps
      queryKey: [page_param, { items_per_page, ...restQueryParameters }],
      queryFn: async () => {
        const { data } = await apiClient.GET('/api/v1/iciq_forms', {
          params: { query: { ...queryParameters, page_param, items_per_page } },
        });
        return data;
      },
    };
  },
  detail: (iciqId: UpdatedPaths['/api/v1/iciq_forms/{id}']['get']['parameters']['path']['id']) => ({
    queryKey: [iciqId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/iciq_forms/{id}', {
        params: { path: { id: iciqId } },
      });
      return data;
    },
  }),
});
