// ignore_for_file: constant_identifier_names

abstract class ErrorCode {
  static const int HTTP_OK = 200;
  static const int HTTP_BAD_REQUEST = 400;
  static const int HTTP_UNAUTHORIZED = 401;
  static const int HTTP_FORBIDDEN = 403;
  static const int HTTP_NOT_FOUND = 404;
  static const int HTTP_METHOD_NOT_ALLOWED = 405;
  static const int HTTP_REQUEST_TIMEOUT = 408;
  static const int HTTP_INTERNAL_SERVER_ERROR = 500;
  static const int HTTP_BAD_GATEWAY = 502;
  static const int NO_NETWORK = 702;
}
