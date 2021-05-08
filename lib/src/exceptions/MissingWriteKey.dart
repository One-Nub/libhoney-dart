part of "../../libhoney-dart.dart";

class MissingWriteKey implements Exception {
  String cause;

  MissingWriteKey(
    {this.cause = "No Team WriteKey was defined upon sending an event."});
}
