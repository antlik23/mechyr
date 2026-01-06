import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/appointment_initials/{id}']['get']
>;
export type UserResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/users/{id}']['get']>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type InitialAppointment = ResponseData['appointment_initial'];
export type QueryUserResponseProperties = Simplify<Response<UserResponseData>>;
export type User = UserResponseData['user'];
