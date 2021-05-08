part of "../../libhoney-dart.dart";

class MissingWritekey implements Exception {
  String cause;

  MissingWritekey(
    {this.cause = "No Team Writekey was defined upon sending an event."});
}
