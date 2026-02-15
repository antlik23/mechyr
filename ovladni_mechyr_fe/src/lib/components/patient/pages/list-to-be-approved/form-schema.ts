import { z } from 'zod';
import * as m from '$paraglide/messages';

export const approvePatientFormSchema = z.object({
  next_appointment: z
    .string()
    .date(m.fieldIsRequired())
    .refine(
      (dateStr) => {
        const selectedDate = new Date(dateStr);
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        return selectedDate >= today;
      },
      { message: 'Datum návštěvy nemůže být v minulosti' }
    ),
  nextAppointmentTime: z.string().time({ message: m.fieldIsRequired() }),
});

export type ApprovePatientFormSchema = typeof approvePatientFormSchema;
export type ApprovePatientFormSchemaTypes = z.infer<ApprovePatientFormSchema>;
