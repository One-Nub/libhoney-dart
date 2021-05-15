/// Client library for https://honeycomb.io for Dart
///
/// Main library which contains all necessary things to interact with https://honeycomb.io
library libhoney;

import 'dart:convert' show json;
import 'dart:math';

import 'package:http/http.dart';

part 'src/libhoney.dart';
part 'src/event.dart';
part 'src/transmission.dart';

part "src/exceptions/MissingApiHost.dart";
part "src/exceptions/MissingData.dart";
part "src/exceptions/MissingDatasetName.dart";
part "src/exceptions/MissingWriteKey.dart";
