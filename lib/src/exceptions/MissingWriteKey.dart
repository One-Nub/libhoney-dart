part of "../../libhoney-dart.dart";

/// Thrown when sending an event with no defined [Event.writeKey].
class MissingWriteKey implements Exception {
  String cause;

  MissingWriteKey(
    {this.cause = "No Team WriteKey was defined upon sending an event."});
}
