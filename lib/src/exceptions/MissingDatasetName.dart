part of "../../libhoney-dart.dart";

class MissingDatasetName implements Exception {
  String cause;

  MissingDatasetName(
    {this.cause = "There was no defined dataset name upon sending an event."});
}