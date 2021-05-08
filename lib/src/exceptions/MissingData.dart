part of "../../libhoney-dart.dart";

/// Thrown when sending an event with no data to send.
class MissingData implements Exception {
  String cause;

  MissingData({this.cause = "No data was defined upon sending an event."});
}
