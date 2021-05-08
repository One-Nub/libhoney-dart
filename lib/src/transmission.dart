part of '../libhoney-dart.dart';

/// Useragent for the library.
const _userAgent = "libhoney-dart/$_version";

/// Default content type for the library.
const _contentType = "application/json";

/// Manages all sending of [Event]s.
class Transmission {
  /// Creates new Transmisson handler.
  Transmission();

  /// Sends an event.
  ///
  /// Requires an [event] to send. Utilizes values set on the event to then send upstream.
  Future<void> send(Event event) async {
    //Stop if event is not to be sent
    if(!_sampleEvent(event.sampleRate!)) return;

    Uri url = Uri.parse("${event.apiHost!}$_eventEndpoint/${event.dataset}");
    var headers = _generateHeaders(event);

    http.Response resp = await http.post(url, headers: headers, body: json.encode(event._fields));

    // TODO: Log the response with the logging package
    // (?) Until responses are implemented. Or integrate a toggle for print logging.
    print(resp);
  }

  /// Performs sampling on an event.
  ///
  /// When false is returned, the event will not be sent.
  bool _sampleEvent(int sampleRate) {
    if(sampleRate <= 1) return true;
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
