part of "../../libhoney-dart.dart";

/// Thrown when sending an event with no defined [Event.apiHost].
class MissingApiHost implements Exception {
  String cause;

  MissingApiHost({this.cause = "No API host was defined upon sending an event."});
}
