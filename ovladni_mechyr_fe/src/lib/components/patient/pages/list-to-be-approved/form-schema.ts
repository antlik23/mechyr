import { z } from 'zod';
import * as m from '$paraglide/messages';

export const approvePatientFormSchema = z.object({
  next_appointment: z.string().date(m.fieldIsRequired()),
  nextAppointmentTime: z.string().time({ message: m.fieldIsRequired() }),
});

export type ApprovePatientFormSchema = typeof approvePatientFormSchema;
export type ApprovePatientFormSchemaTypes = z.infer<ApprovePatientFormSchema>;
