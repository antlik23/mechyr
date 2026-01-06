import type { InputConstraint } from 'sveltekit-superforms';
import { tv } from 'tailwind-variants';
import RequiredIndicator from './required-indicator.svelte';
import RequiredIndicatorInfo from './required-indicator-info.svelte';
import Login from './login/form.svelte';
import ForgotPassword from './forgot-password/form.svelte';
import ResetPassword from './reset-password/form.svelte';
import Entry from './entry/form.svelte';

export const fieldErrorsVariants = tv({
  base: 'text-sm text-destructive',
});

export function determineIsRequired(constraints: InputConstraint | undefined) {
  return constraints?.required;
}

export { RequiredIndicator, RequiredIndicatorInfo, Login, ForgotPassword, ResetPassword, Entry };
