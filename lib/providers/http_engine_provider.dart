import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final httpEngineProvider = Provider<Client>((ref) => Client());
