import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/latest_diary']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;

export type AnamnesticResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/anamnestic_forms']['get']
>;
export type AnamnesticQueryResponseProperties = Simplify<Response<AnamnesticResponseData>>;
export type AnamnesticForm = AnamnesticResponseData['anamnestic_forms'][number];
