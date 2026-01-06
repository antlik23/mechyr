import type { Simplify } from 'type-fest';
import type { SuccessResponseJSON } from 'openapi-typescript-helpers';
import type { UpdatedPaths } from '$lib/api/api';
import type { Response } from '$lib/types/Response';
import type { Patient as PatientNew } from './types';
import type { Patient as PatientEdit } from '../detail/types';

export type ResponseData = SuccessResponseJSON<
  UpdatedPaths['/api/v1/patients/list_to_be_approved']['get']
>;
export type QueryResponseProperties = Simplify<Response<ResponseData>>;
export type Patients = ResponseData['patients'];
export type Patient = Patients[number];
export type PatientUnified = PatientNew & Partial<PatientEdit>;
