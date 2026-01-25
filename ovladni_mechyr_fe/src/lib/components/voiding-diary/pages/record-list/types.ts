import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { Simplify } from 'type-fest';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;

export type VoidingDiaryResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/{id}']['get']
>;
export type VoidingDiaryQueryResponseProperties = Simplify<Response<VoidingDiaryResponseData>>;
