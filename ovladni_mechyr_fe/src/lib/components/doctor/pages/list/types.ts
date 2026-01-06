import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/doctors/available_doctors']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type Doctor = ResponseData['doctors'][number];
