/// System-level exceptions thrown during network or storage operations.
class ServerException implements Exception {
  final String? message;
  final int? statusCode;

  const ServerException({this.message, this.statusCode});
}

class CacheException implements Exception {
  final String? message;

  const CacheException({this.message});
}