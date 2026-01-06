import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';

export type EntryFormResponse = SuccessResponseJSON<UpdatedPaths['/api/v1/entry_forms']['post']>;
