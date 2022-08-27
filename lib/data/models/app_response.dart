import '../utils/app_logger.dart';
import '../utils/methods.dart';

/// Custom status code for the app.
enum AppStatusCode {
  success,
  error,
  notFound,
}

/// The class to represent the response of any services.
class AppResponse {
  AppStatusCode statusCode;
  String message;
  Map<String, dynamic> data;

  bool get isSuccess => statusCode == AppStatusCode.success;

  bool get isError => statusCode == AppStatusCode.error;

  bool get isNotFound => statusCode == AppStatusCode.notFound;

  AppResponse({
    required this.statusCode,
    this.message = '',
    this.data = const {},
  });

  factory AppResponse.success({
    String message = '',
    Map<String, dynamic> data = const {},
  }) =>
      AppResponse(
        statusCode: AppStatusCode.success,
        message: message,
        data: data,
      )..log();

  factory AppResponse.notFound({
    String message = '',
    Map<String, dynamic> data = const {},
  }) =>
      AppResponse(
        statusCode: AppStatusCode.notFound,
        message: message,
        data: data,
      )..log();

  factory AppResponse.error({
    String? message,
    Map<String, dynamic> data = const {},
    dynamic error,
    StackTrace? stackTrace,
  }) {
    return AppResponse(
      statusCode: AppStatusCode.error,
      message: getExceptionMessage(message, error, stackTrace),
      data: data,
    )..log();
  }

  log() {
    logger.d(
      '$statusCode\n'
      '$message\n'
      '$data',
    );
  }
}
