part of '../libhoney-dart.dart';

/// Useragent for the library.
const _userAgent = "libhoney-dart/$_version";

/// Default content type for the library.
const _contentType = "application/json";

/// Manages all sending of [Event]s.
class Transmission {
  /// Http client which events are sent through.
  /// Can be defined when instantiating [Libhoney] class
  /// enabling use of custom Http client implementation.
  Client client = Client();

  /// Creates new Transmission handler.
  Transmission();

  /// Sends an event.
  ///
  /// Requires an [event] to send. Utilizes values set on the event to then send upstream.
  /// Sampling will not be performed on the event if it is [presampled], but is
  /// not required is the sample rate is already `1`.
  Future<void> send(Event event, {bool presampled: false}) async {
    //Stop if event is not to be sent
    if (!presampled && !_sampleEvent(event.sampleRate!)) return;

    Uri url = Uri.parse("${event.apiHost!}$_eventEndpoint${event.dataset}");
    var headers = _generateHeaders(event);

    Stopwatch timer = Stopwatch()..start();
    Response postResponse = await client.post(url, headers: headers, body: json.encode(event._fields));
    timer.stop();

    EventResponse eventResponse = EventResponse(postResponse, event, timer.elapsedMilliseconds);
    event._libhoney._addResponse(eventResponse);
  }

  /// Performs sampling on an event.
  ///
  /// When false is returned, the event will not be sent.
  bool _sampleEvent(int sampleRate) {
    if (sampleRate <= 1) return true;
    return Random.secure().nextDouble() < 1 / sampleRate;
  }

  /// Generates the headers required for post request in [send()]
  ///
  /// Utilizes variables set on event to create required headers.
  Map<String, String> _generateHeaders(Event event) {
    Map<String, String> headers = {};

    headers["X-Honeycomb-Team"] = event.writeKey!;
    headers["Content-Type"] = _contentType;
    headers["User-Agent"] = _userAgent;
    headers["X-Honeycomb-Event-Time"] = event.timestamp!.toIso8601String();
    headers["X-Honeycomb-Samplerate"] = event.sampleRate.toString();

    return headers;
  }
}
