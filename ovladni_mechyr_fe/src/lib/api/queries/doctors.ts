import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';
import { DEFAULT_ITEMS_PER_PAGE } from './constants';

export const doctors = createQueryKeys('doctors', {
  availableList: (
    queryParameters?: UpdatedPaths['/api/v1/doctors/available_doctors']['get']['parameters']['query']
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
        const { data } = await apiClient.GET('/api/v1/doctors/available_doctors', {
          params: { query: { ...queryParameters, page_param, items_per_page } },
        });
        return data;
      },
    };
  },
});
