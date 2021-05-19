part of "../../libhoney-dart.dart";

/// Thrown when sending an event with no defined [Event.dataset].
class MissingDatasetName implements Exception {
  String cause;

  MissingDatasetName({this.cause = "There was no defined dataset name upon sending an event."});
}
