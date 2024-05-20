class CantFetchFromServer implements Exception {
  final String serviceName;

  const CantFetchFromServer({required this.serviceName});

  @override
  String toString() => "Was't possible to fetch from $serviceName";
}
