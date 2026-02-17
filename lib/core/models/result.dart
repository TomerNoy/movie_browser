import 'package:equatable/equatable.dart';

enum AppErrorType { network, noResults, tooManyResults, api, unknown }

class Result<T> extends Equatable {
  final T? data;
  final String? error;
  final AppErrorType? errorType;

  const Result._({this.data, this.error, this.errorType});

  static Result<T> success<T>(T data) => Result._(data: data);

  static Result<T> failure<T>(String error,
      [AppErrorType type = AppErrorType.unknown]) =>
      Result._(error: error, errorType: type);

  bool get isSuccess => !isFailure;

  bool get isFailure => error != null;

  @override
  List<Object?> get props => [data, error, errorType];
}
