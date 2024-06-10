class CustomException implements Exception {
  final String? message;
  final int? code;

  CustomException([this.code, this.message]);

  @override
  String toString() {
    return "$message";
  }
}

class ErrorException extends CustomException {
  ErrorException([int? code, String? message]) : super(code, message);
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(400, "Invalid Request: $message");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(401, "Unauthorised: $message");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: $message");
}