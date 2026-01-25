import type { RequestBodyJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';

export type UrineLeakageType = NonNullable<
  RequestBodyJSON<
    UpdatedPaths['/api/v1/voiding_diaries/{voiding_diary_id}/voiding_records']['post']
  >['voiding_record']['urine_leakage_type']
>;

export const URINE_LEAKAGE_TYPE = ['stressful', 'urgent'] as const satisfies UrineLeakageType[];
assert<Equals<(typeof URINE_LEAKAGE_TYPE)[number], UrineLeakageType>>();
assert<Equals<IsUnique<typeof URINE_LEAKAGE_TYPE>, true>>();
