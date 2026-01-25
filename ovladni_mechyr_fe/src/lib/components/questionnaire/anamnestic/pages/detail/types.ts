import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/anamnestic_forms']['get']>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type AnamnesticForm = ResponseData['anamnestic_forms'][number];

export type DetailResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/anamnestic_forms/{id}']['get']
>;
export type DetailQueryResponseProperties = Simplify<Response<DetailResponseData>>;

export type IciqResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/iciq_forms']['get']>;
export type IciqQueryResponseProperties = Simplify<Response<IciqResponseData>>;
export type IciqForm = IciqResponseData['iciq_forms'][number];

export type IpssResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/ipss_forms']['get']>;
export type IpssQueryResponseProperties = Simplify<Response<IpssResponseData>>;
export type IpssForm = IpssResponseData['ipss_forms'][number];
