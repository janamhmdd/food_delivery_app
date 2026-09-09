class ApiResult<T> {
  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  ApiResult.success(this.data)
      : errorMessage = null,
        isSuccess = true;

  ApiResult.failure(this.errorMessage)
      : data = null,
        isSuccess = false;
}