import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/appointment_seconds/{id}']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type SecondAppointment = ResponseData['appointment_second'];

export type FirstAppointmentResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/appointment_firsts/{id}']['get']
>;
export type FirstAppointmentQueryResponseProperties = Simplify<
  Response<FirstAppointmentResponseData>
>;
export type FirstAppointment = FirstAppointmentResponseData['appointment_first'];
