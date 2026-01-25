import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { Simplify } from 'type-fest';

export type ResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/voiding_diaries']['get']>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;

export type LatestVoidingDiaryResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/latest_diary']['get']
>;
export type LatestVoidingDiaryQueryResponseProperties = Simplify<
  Response<LatestVoidingDiaryResponseData>
>;
