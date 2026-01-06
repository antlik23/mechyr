import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records/{id}']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type VoidingDiaryRecord = ResponseData['voiding_record'];

export type VoidingDiaryResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/{id}']['get']
>;
export type VoidingDiaryQueryResponseProperties = Simplify<Response<VoidingDiaryResponseData>>;
export type VoidingDiary = VoidingDiaryResponseData['voiding_diary'];
