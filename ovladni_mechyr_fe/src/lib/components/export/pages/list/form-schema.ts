import { z } from 'zod';
import * as m from '$paraglide/messages';
import { MODEL_NAME } from './constants';

export const exportDataFormSchema = z.object({
  model_name: z.enum(MODEL_NAME, { message: m.fieldIsRequired() }),
});

export type ExportDataFormSchema = typeof exportDataFormSchema;
export type ExportDataFormSchemaTypes = z.infer<ExportDataFormSchema>;
