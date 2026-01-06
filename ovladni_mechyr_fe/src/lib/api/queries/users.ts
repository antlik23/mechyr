import { createQueryKeys } from '@lukemorales/query-key-factory';
import { apiClient, type UpdatedPaths } from '../api';

export const users = createQueryKeys('users', {
  // TODO: update
  list: (
    page?: NonNullable<UpdatedPaths['/api/v1/users']['get']['parameters']['query']>['page_param'],
    filters?: Omit<
      NonNullable<UpdatedPaths['/api/v1/users']['get']['parameters']['query']>,
      'page_param'
    >
  ) => ({
    queryKey: [page, filters],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/users', {
        params: { query: { page_param: page, ...filters } },
      });
      return data;
    },
  }),
  detail: (userId: UpdatedPaths['/api/v1/users/{id}']['get']['parameters']['path']['id']) => ({
    queryKey: [userId],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/users/{id}', {
        params: { path: { id: userId } },
      });
      return data;
    },
    contextQueries: {
      forms: {
        // eslint-disable-next-line @tanstack/query/exhaustive-deps
        queryKey: null,
        queryFn: async () => {
          const { data } = await apiClient.GET('/api/v1/users/{id}/forms', {
            params: { path: { id: userId } },
          });
          return data;
        },
      },
      diaries: {
        // eslint-disable-next-line @tanstack/query/exhaustive-deps
        queryKey: null,
        queryFn: async () => {
          const { data } = await apiClient.GET('/api/v1/users/{id}/diaries', {
            params: { path: { id: userId } },
          });
          return data;
        },
      },
    },
  }),
  findByToken: (
    invitationToken: UpdatedPaths['/api/v1/users/find_by_token/{invitation_token}']['get']['parameters']['path']['invitation_token']
  ) => ({
    queryKey: [invitationToken],
    queryFn: async () => {
      const { data } = await apiClient.GET('/api/v1/users/find_by_token/{invitation_token}', {
        params: { path: { invitation_token: invitationToken } },
      });
      return data;
    },
  }),
});
