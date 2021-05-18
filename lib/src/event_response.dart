part of '../libhoney-dart.dart';

class EventResponse {
  /// Response body of the request.
  late String body;

  /// Original Event that was sent.
  Event event;

  /// Error that the library encountered while sending the event.
  /// 
  /// Currently unused, if the currently thrown exceptions are phased out
  /// upon validating, this will be populated.
  String? libError;

  /// [Event.metadata], used to identify the event.
  dynamic? metadata;

  /// Raw response from post request sent upstream.
  Response rawResponse;

  /// Resulting status code of sent event.
  late int statusCode;

  /// Time in milliseconds it took for the event to send.
  int submitDuration;

  EventResponse(this.rawResponse, this.event, this.submitDuration, {this.libError}) {
    statusCode = rawResponse.statusCode;
    body = rawResponse.body;
    metadata = event.metadata;
  }
}
