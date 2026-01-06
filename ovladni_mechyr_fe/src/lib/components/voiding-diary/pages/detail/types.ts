import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';

export type ResponseData = SuccessResponseJSON<UpdatedPaths['/api/v1/voiding_diaries/{id}']['get']>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type VoidingDiary = ResponseData['voiding_diary'];
