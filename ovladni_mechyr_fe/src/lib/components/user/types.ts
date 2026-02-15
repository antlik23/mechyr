import type { UpdatedPaths } from '$lib/api/api';
import type { RequestBodyJSON, SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { Merge } from 'type-fest';

export type LoginResponse = SuccessResponseJSON<UpdatedPaths['/api/v1/login']['post']>;
export type FullUserResponse = SuccessResponseJSON<UpdatedPaths['/api/v1/users/{id}']['get']>;

export type UserRole = LoginResponse['user']['roles'][number];
export type UserGender = NonNullable<LoginResponse['user']['gender']> | 'other';
export type UserGenderWithOther = NonNullable<UserGender | 'other'>;
export type UserProstate = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/signup']['post']
  >['user']['patient_attributes']['other_gender']
>;

// User can be either basic login response or full user data
export type User =
  | LoginResponse
  | (Omit<LoginResponse, 'user'> & { user: FullUserResponse['user'] })
  | null;
export type CurrentUser = NonNullable<User>;
export type CurrentUserData = Merge<
  CurrentUser['user'],
  {
    gender: NonNullable<CurrentUser['user']['gender']>;
    isAdmin: boolean;
    isPatient: boolean;
    isDoctor: boolean;
    role: 'admin' | 'doctor' | 'patient';
  }
>;
