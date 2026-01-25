export type Response<TData> = {
  data?: TData;
  isLoading?: boolean;
  isSuccess?: boolean;
  isError?: boolean;
};
