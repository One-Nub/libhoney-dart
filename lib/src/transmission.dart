part of '../libhoney-dart.dart';

const _userAgent = "libhoney-dart/$_version";
const _contentType = "application/json";


class Transmission {
  Transmission();

  Future<void> send(Event event) async {
    //Stop if event is not to be sent
    if(!_sampleEvent(event.sampleRate!)) return;

    Uri url = Uri.parse("${event.apiHost!}$_eventEndpoint/${event.dataset}");
    var headers = _generateHeaders(event);
    
    http.Response resp = await http.post(url, headers: headers, body: json.encode(event._fields));

    //Since responses are not implemented yet - I wish to utilize the logging
    //package for this for the time being.
    print(resp);
  }

  bool _sampleEvent(int sampleRate) {
    if(sampleRate <= 1) return true;
    return Random.secure().nextDouble() < 1 / sampleRate;
  }

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