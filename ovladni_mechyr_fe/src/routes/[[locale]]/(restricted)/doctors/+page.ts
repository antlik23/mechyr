import { queries, queryClient } from '$lib/api/queries';
import { get } from 'svelte/store';
import { persistedUser, updateUser } from '$lib/components/user/data';
import { apiClient } from '$lib/api/api';

export async function load() {
  const doctorsFilters: NonNullable<Parameters<typeof queries.doctors.availableList>['0']> = {};

  queryClient.prefetchQuery(queries.doctors.availableList(doctorsFilters));

  // Fetch full user data to get doctor_id and doctor_name if not already present
  const currentUser = get(persistedUser);
  if (currentUser?.user?.id && !('doctor_id' in currentUser.user)) {
    const { data } = await apiClient.GET('/api/v1/users/{id}', {
      params: { path: { id: currentUser.user.id } },
    });

    if (data) {
      updateUser({
        ...currentUser,
        user: data.user,
      });
    }
  }

  return {
    doctorsFilters,
  };
}
