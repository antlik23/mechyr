import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/appointment_firsts/{id}']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type FirstAppointment = ResponseData['appointment_first'];

export type InitialAppointmentResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/appointment_initials/{id}']['get']
>;
export type InitialAppointmentQueryResponseProperties = Simplify<
  Response<InitialAppointmentResponseData>
>;
export type InitialAppointment = InitialAppointmentResponseData['appointment_initial'];
