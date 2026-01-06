import type { UpdatedPaths } from '$lib/api/api';
import type { IsUnique } from '$lib/types/Array';
import { assert, type Equals } from 'tsafe';
import * as m from '$paraglide/messages';

export type ModelName = UpdatedPaths['/api/v1/export']['get']['parameters']['query']['model_name'];

export const MODEL_NAME = [
  'EntryForm',
  'OabForm',
  'IciqForm',
  'IpssForm',
  'AnamnesticForm',
  'VoidingDiary',
  'AppointmentInitial',
  'AppointmentFirst',
  'AppointmentSecond',
] as const satisfies ModelName[];
assert<Equals<(typeof MODEL_NAME)[number], ModelName>>();
assert<Equals<IsUnique<typeof MODEL_NAME>, true>>();

// TODO: move to paraglide messages
const modelNameNames: Record<ModelName, () => string> = {
  EntryForm: m.entryForm,
  OabForm: m.oabV8Form,
  IciqForm: m.iciqForm,
  IpssForm: m.ipssForm,
  AnamnesticForm: m.anamnesticForm,
  VoidingDiary: m.voidingDiary,
  AppointmentInitial: () => 'Prvotní schůzka doktora s pacientem',
  AppointmentFirst: () => 'První schůzka doktora s pacientem',
  AppointmentSecond: () => 'Druhá schůzka doktora s pacientem',
} as const;

export function getModelNameList() {
  return MODEL_NAME.map((modelName) => ({
    value: modelName,
    label: getTranslatedModelNameName(modelName),
  }));
}

export function getTranslatedModelNameName(modelName: ModelName) {
  return modelNameNames[modelName]?.() ?? modelName;
}
