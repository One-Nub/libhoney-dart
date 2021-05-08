part of "../../libhoney-dart.dart";

class MissingApiHost implements Exception {
  String cause;

  MissingApiHost(
    {this.cause = "No API host was defined upon sending an event."});
}
