import * as m from '$paraglide/messages.js';
import { z } from 'zod';

const minUrinationsPerDay = 1;
const maxUrinationsPerDay = 99;

const minFluidIntakeVolume = 1;
const maxFluidIntakeVolume = 99;

export const entryFormSchema = z.object({
  urination_frequency_issue: z.boolean({ message: m.fieldIsRequired() }),
  urinations_per_day: z
    .number({ message: m.fieldIsRequired() })
    .nonnegative(m.fieldCantBeNegativeNumber())
    .min(minUrinationsPerDay, { message: m.fieldMustBeMin({ minAmount: minUrinationsPerDay }) })
    .max(maxUrinationsPerDay, { message: m.fieldMustBeMax({ maxAmount: maxUrinationsPerDay }) }),
  fluid_intake_volume: z
    .number({ message: m.fieldIsRequired() })
    .nonnegative(m.fieldCantBeNegativeNumber())
    .min(minFluidIntakeVolume, { message: m.fieldMustBeMin({ minAmount: minFluidIntakeVolume }) })
    .max(maxFluidIntakeVolume, { message: m.fieldMustBeMax({ maxAmount: maxFluidIntakeVolume }) }),
});

export type EntryFormSchema = typeof entryFormSchema;
export type EntryFormSchemaTypes = z.infer<typeof entryFormSchema>;
