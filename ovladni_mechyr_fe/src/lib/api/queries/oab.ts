import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';
import { DEFAULT_ITEMS_PER_PAGE } from './constants';

export const oab = createQueryKeys('oab', {
  list: (queryParameters?: UpdatedPaths['/api/v1/oab_forms']['get']['parameters']['query']) => {
    const {
      page_param = 1,
      items_per_page = DEFAULT_ITEMS_PER_PAGE,
      ...restQueryParameters
    } = queryParameters ?? {};

    return {
      // eslint-disable-next-line @tanstack/query/exhaustive-deps
      queryKey: [page_param, { items_per_page, ...restQueryParameters }],
      queryFn: async () => {
        const { data } = await apiClient.GET('/api/v1/oab_forms', {
          params: { query: { ...queryParameters, page_param, items_per_page } },
        });
        return data;
      },
    };
  },
  detail: (oabId: UpdatedPaths['/api/v1/oab_forms/{id}']['get']['parameters']['path']['id']) => ({
    queryKey: [oabId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/oab_forms/{id}', {
        params: { path: { id: oabId } },
      });
      return data;
    },
  }),
});
