import { z } from 'zod';
import * as m from '$paraglide/messages';

export const leakageSeverity = { min: 0, max: 10 };

export const iciqFormSchema = z.object({
  leakage_frequency: z.number({ message: m.fieldIsRequired() }),
  leakage_assessment: z.number({ message: m.fieldIsRequired() }),
  leakage_severity: z
    .number({ message: m.fieldIsRequired() })
    .int({ message: m.fieldMustBeInteger() })
    .min(leakageSeverity.min, { message: m.fieldMustBeMin({ minAmount: leakageSeverity.min }) })
    .max(leakageSeverity.max, { message: m.fieldMustBeMax({ maxAmount: leakageSeverity.max }) }),
  never_leaks: z.boolean().default(false),
  leaks_before_reaching_toilet: z.boolean().default(false),
  leaks_when_coughing_or_sneezing: z.boolean().default(false),
  leaks_during_sleep: z.boolean().default(false),
  leaks_during_physical_activity: z.boolean().default(false),
  leaks_after_urinating_and_dressing: z.boolean().default(false),
  leaks_for_unknown_reasons: z.boolean().default(false),
  constant_leakage: z.boolean().default(false),
});

export type IciqFormSchema = typeof iciqFormSchema;
export type IciqFormSchemaTypes = z.infer<IciqFormSchema>;
