import { get, type Writable } from 'svelte/store';
import { toast } from 'svelte-sonner';
import { AssertionError } from 'tsafe';
import * as m from '$paraglide/messages';

export type HandleRequestOptions = {
  toastSuccessText?: string | Writable<string>;
  onError?: () => void;
  rethrowError?: boolean;
};

/**
 * Displays loading notification at start.
 * Displays error notification when `fn` throws.
 */
export async function handleRequest(
  fn: (data: {
    toastId: string | number;
  }) => Promise<Pick<HandleRequestOptions, 'toastSuccessText'> | void>,
  { toastSuccessText, onError, rethrowError }: HandleRequestOptions = {}
) {
  const toastId = toast.loading(m.loading(), { duration: Infinity });
  let success = true;

  try {
    const fnData = await fn({ toastId });

    let toastText: string | undefined;
    if (fnData && fnData.toastSuccessText) {
      toastText =
        typeof fnData.toastSuccessText === 'string'
          ? fnData.toastSuccessText
          : get(fnData.toastSuccessText);
    } else if (toastSuccessText) {
      toastText = typeof toastSuccessText === 'string' ? toastSuccessText : get(toastSuccessText);
    }

    if (toastText) {
      toast.success(toastText, {
        id: toastId,
        duration: undefined,
      });
    }
  } catch (error) {
    console.error(error);

    success = false;

    let errorMessage: string | undefined;
    if (error instanceof AssertionError) {
      errorMessage = m.unexpectedError();
    } else if (error instanceof Error) {
      errorMessage = error.message;
    }

    if (errorMessage) {
      toast.error(errorMessage, { id: toastId, duration: undefined });
    }

    onError?.();

    if (rethrowError) {
      throw error;
    }
  }

  return {
    toastId,
    success,
  };
}
