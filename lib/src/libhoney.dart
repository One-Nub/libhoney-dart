part of '../libhoney-dart.dart';

const _apiHost = "https://api.honeycomb.io";
const _eventEndpoint = "/1/events/";
const _version = "0.1.0";

class Libhoney {
  String apiHost;
  String? dataset;
  String? writeKey;
  int sampleRate;
  bool disabled;

  Transmission? _transmission;

  Map _globalFields = {};

  Libhoney(
      {this.apiHost = _apiHost,
      dataset,
      writeKey,
      this.sampleRate = 1,
      this.disabled = false}) {
    if (!disabled) _transmission = Transmission();
  }

  Future<void> sendEvent(Event event) async {
    Event validatedEvent = _validateEvent(event);
    if(_transmission != null) {
      _transmission!.send(validatedEvent);
    }
  }

  void addGlobalField(String key, Object val) {
    _globalFields[key] = val;
  }

  Event _validateEvent(Event event) {
    Event validatedEvent = event;

    if (event.apiHost == null || event.apiHost!.isEmpty) throw MissingApiHost();

    if (event.dataset == null || event.dataset!.isEmpty) throw MissingDatasetName();

    if (event.writeKey == null || event.writeKey!.isEmpty) throw MissingWritekey();

    validatedEvent.sampleRate ??= 1;

    validatedEvent.timestamp ??= DateTime.now();

    if (event._fields.isEmpty) throw MissingData();

    return validatedEvent;
  }
}
