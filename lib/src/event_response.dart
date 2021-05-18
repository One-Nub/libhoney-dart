part of '../libhoney-dart.dart';

class EventResponse {
  /// Resulting status code of sent event.
  late int statusCode;

  /// Response body of the request.
  late String body;

  /// Original Event that was sent.
  Event event;

  /// Time in milliseconds it took for the event to send.
  int submitDuration;

  /// [Event.metadata], used to identify the event.
  dynamic? metadata;

  /// Error that the library encountered while sending the event.
  /// 
  /// Currently unused, if the currently thrown exceptions are phased out
  /// upon validating, this will be populated.
  String? libError;

  EventResponse(Response response, this.event, this.submitDuration, {this.libError}) {
    statusCode = response.statusCode;
    body = response.body;
    metadata = event.metadata;
  }
}
