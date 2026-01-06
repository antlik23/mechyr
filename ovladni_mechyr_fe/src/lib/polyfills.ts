// TODO: remove when using node 22+ and browser support is good
if (typeof Promise.withResolvers === 'undefined') {
  Promise.withResolvers = function <T>() {
    let resolve: ((value: T | PromiseLike<T>) => void) | undefined;
    let reject: ((reason: unknown) => void) | undefined;

    const promise = new Promise<T>((res, rej) => {
      resolve = res;
      reject = rej;
    });

    return {
      promise,
      resolve: resolve!,
      reject: reject!,
    };
  };
}
