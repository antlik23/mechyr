import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/iciq_forms']['get']>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type IciqForm = ResponseData['iciq_forms'][number];

export type DetailResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/iciq_forms/{id}']['get']
>;
export type DetailQueryResponseProperties = Simplify<Response<DetailResponseData>>;
