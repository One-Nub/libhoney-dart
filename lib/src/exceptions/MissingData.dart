part of "../../libhoney-dart.dart";

class MissingData implements Exception {
  String cause;

  MissingData({this.cause = "No data was defined upon sending an event."});
}