import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/ipss_forms']['get']>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type IpssForm = ResponseData['ipss_forms'][number];

export type DetailResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/ipss_forms/{id}']['get']
>;
export type DetailQueryResponseProperties = Simplify<Response<DetailResponseData>>;
