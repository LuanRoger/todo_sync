import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final uuidGeneratorProvier = Provider<Uuid>((_) => const Uuid());
