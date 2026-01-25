import type { Merge, Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';
import type { OabForm } from '$lib/components/questionnaire/oab/pages/detail/types';

export type QuestionnairesTableData = Simplify<
  Merge<
    Pick<OabForm, 'completion_timestamp' | 'id'>,
    { type: 'oab_form' | 'iciq_form' | 'ipss_form' | 'anamnestic_form'; total_score: number | null }
  >
>;

export type VoidingDiariesResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/voiding_diaries']['get']
>;
export type VoidingDiariesQueryResponseProperties = Simplify<Response<VoidingDiariesResponseData>>;
