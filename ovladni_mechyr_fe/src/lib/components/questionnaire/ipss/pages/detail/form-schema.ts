import { z } from 'zod';
import * as m from '$paraglide/messages';

export const ipssFormSchema = z.object({
  incomplete_emptying: z.number({ message: m.fieldIsRequired() }),
  frequency: z.number({ message: m.fieldIsRequired() }),
  intermittent_urination: z.number({ message: m.fieldIsRequired() }),
  urgency: z.number({ message: m.fieldIsRequired() }),
  weak_stream: z.number({ message: m.fieldIsRequired() }),
  straining: z.number({ message: m.fieldIsRequired() }),
  nocturnal_urination: z.number({ message: m.fieldIsRequired() }),
  quality_of_life: z.number({ message: m.fieldIsRequired() }),
});

export type IpssFormSchema = typeof ipssFormSchema;
export type IpssFormSchemaTypes = z.infer<IpssFormSchema>;
