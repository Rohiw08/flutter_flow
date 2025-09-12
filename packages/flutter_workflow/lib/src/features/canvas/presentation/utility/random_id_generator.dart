import 'dart:math';

/// Generates a unique node ID. This can remain a utility function.
String generateUniqueId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  final random = Random().nextInt(999999);
  return 'node_${timestamp}_$random';
}
