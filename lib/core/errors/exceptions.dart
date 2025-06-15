class PresensiServiceException implements Exception {
  final String message;

  PresensiServiceException(this.message);

  @override
  String toString() => 'PresensiServiceException: $message';
}
