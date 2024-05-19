class UnexpectedResponse implements Exception {
  final int statusCode;

  String get _message => "Unexpected response: $statusCode";

  UnexpectedResponse(this.statusCode);

  @override
  String toString() => _message;
}
