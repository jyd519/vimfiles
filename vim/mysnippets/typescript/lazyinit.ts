export const lazyInit = <T, A>(fn: (...args: A[]) => T) => {
  let prom: T = undefined;
  return (...args: A[]) => (prom = prom || fn(...args));
};