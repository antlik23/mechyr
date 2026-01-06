import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type DetailResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/users/{id}']['get']>;
export type DetailQueryResponseProperties = Simplify<Response<DetailResponseData>>;
export type Patient = DetailResponseData['user'];

export type VoidingDiariesResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/users/{id}/diaries']['get']
>;
export type VoidingDiariesQueryResponseProperties = Simplify<Response<VoidingDiariesResponseData>>;

export type LatestVoidingDiaryResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries/{id}']['get']
>;
export type LatestVoidingDiaryQueryResponseProperties = Simplify<
  Response<LatestVoidingDiaryResponseData>
>;

export type QuestionnairesResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/users/{id}/forms']['get']
>;
export type QuestionnairesQueryResponseProperties = Simplify<Response<QuestionnairesResponseData>>;
