import type { PartialValues } from '$lib/types/PartialValues';
import { filterUndefinedObjectValues } from '$lib/utils/object';

/**
 * To keep field required and prevent default value.
 *
 * {@link https://superforms.rocks/default-values#changing-a-default-value Docs}
 */
export const DEFAULT_STRING_VALUE = '' as unknown as undefined;

/**
 * To ensure field's default values.
 *
 * {@link https://superforms.rocks/default-values Docs}
 */
export function prepareSuperFormDefaultFormData<TSchema extends Record<string, unknown>>(
  initialFormData: PartialValues<TSchema>
) {
  return filterUndefinedObjectValues(initialFormData) as TSchema;
}
