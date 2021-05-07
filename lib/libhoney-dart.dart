/// Client library for honeycomb.io for Dart
/// 
/// Main library which contains all necessary things to interact with honeycomb.io
library libhoney;

import 'dart:convert' show json;
import 'dart:math';

import 'package:http/http.dart' as http;

part 'src/libhoney.dart';
part 'src/event.dart';
part 'src/transmission.dart';

part "src/exceptions/MissingApiHost.dart";
part "src/exceptions/MissingData.dart";
part "src/exceptions/MissingDatasetName.dart";
part "src/exceptions/MissingWritekey.dart";
