import 'package:flutter/foundation.dart';

void debugPrinter(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}