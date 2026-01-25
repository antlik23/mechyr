import { z } from 'zod';
import * as m from '$paraglide/messages';

export const oabFormSchema = z.object({
  daytime_urination_frequency: z.number({ message: m.fieldIsRequired() }),
  unpleasant_urination_urge: z.number({ message: m.fieldIsRequired() }),
  sudden_urination_urge: z.number({ message: m.fieldIsRequired() }),
  occasional_leak: z.number({ message: m.fieldIsRequired() }),
  nighttime_urination: z.number({ message: m.fieldIsRequired() }),
  waking_up_to_urinate: z.number({ message: m.fieldIsRequired() }),
  uncontrollable_urge: z.number({ message: m.fieldIsRequired() }),
  leak_due_to_intense_urge: z.number({ message: m.fieldIsRequired() }),
});

export type OabFormSchema = typeof oabFormSchema;
export type OabFormSchemaTypes = z.infer<OabFormSchema>;
