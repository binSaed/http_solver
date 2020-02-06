class Failure implements Exception {
  final String message;
  final int code;

  Failure(this.message, {this.code = 0});

  @override
  String toString() => message;
}
