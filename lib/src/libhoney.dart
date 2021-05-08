part of '../libhoney-dart.dart';

/// Default Honeycomb api host URL.
const _apiHost = "https://api.honeycomb.io";

/// Default event endpoint for Honeycomb.
const _eventEndpoint = "/1/events/";

/// Version of the library.
const _version = "0.1.0";

/// Entry point of package for setting send defaults and sending [Event]s.
///
/// Allows for setting of non default [apiHost], along with user specific options
/// such as a [dataset] name and [writeKey] which must be set for proper event sending.
/// [sampleRate] enables the sending of events based off of a 1 / [sampleRate] chance.
/// Sending is enabled by default but can be disabled via the [disabled] option.
class Libhoney {
  /// The default host where events are sent to.
  ///
  /// Events will be sent to "/1/events/" on this host.
  String apiHost;

  /// The name of a default [dataset](https://docs.honeycomb.io/getting-data-in/best-practices/#use-datasets-to-group-data) for events to be sent to.
  ///
  /// Must be set in Libhoney or on an [Event] or else [MissingDatasetName] will be thrown.
  String? dataset;

  /// Known to Honeycomb as an API key. Keep this a secret.
  ///
  /// Required on Libhoney or on an [Event] or else [MissingWriteKey] will be thrown.
  String? writeKey;

  /// The default sampling rate. Chance of an event being sent is 1 / [sampleRate].
  int sampleRate;

  /// Sets if events will be sent upsteam to [apiHost] or not. False by default.
  ///
  /// `True`: Do **not** send events.
  /// `False`: Do send events.
  bool disabled;

  /// Transmission object used for sending events to [apiHost]. Null if Libhoney
  /// is disabled on instantiation.
  Transmission? _transmission;

  /// Contains fields set globally which will be given to all events.
  Map _globalFields = {};

  /// Creates a new Libhoney client.
  Libhoney(
      {this.apiHost = _apiHost,
      dataset,
      writeKey,
      this.sampleRate = 1,
      this.disabled = false}) {
    if (!disabled) _transmission = Transmission();
  }

  /// Sends a specific [Event] to internal [Transmission].
  ///
  /// Validates an [Event]'s required arguments.
  /// Will throw [MissingApiHost] if an Event's [Event.apiHost] is null or empty.
  /// Will throw [MissingDatasetName] if an Event's [Event.dataset] is null or empty.
  /// Will throw [MissingWriteKey] if an Event's [Event.writeKey] is null or empty.
  /// Defines a default sample rate of 1 and a timestamp of the current time if they
  /// are not predefined. If there is no event data [MissingData] will be thrown.
  Future<void> sendEvent(Event event) async {
    Event validatedEvent = _validateEvent(event);
    if(_transmission != null) {
      _transmission!.send(validatedEvent);
    }
  }

  /// Sets a field globally for all further events to inherit when being sent.
  void addGlobalField(String key, Object val) {
    _globalFields[key] = val;
  }

  /// Internal validation logic.
  ///
  /// Follows the schema for exceptions being thrown as defined in the documentation
  /// for [sendEvent()]
  Event _validateEvent(Event event) {
    Event validatedEvent = event;

    if (event.apiHost == null || event.apiHost!.isEmpty) throw MissingApiHost();

    if (event.dataset == null || event.dataset!.isEmpty) throw MissingDatasetName();

    if (event.writeKey == null || event.writeKey!.isEmpty) throw MissingWriteKey();

    validatedEvent.sampleRate ??= 1;

    validatedEvent.timestamp ??= DateTime.now();

    if (event._fields.isEmpty) throw MissingData();

    return validatedEvent;
  }
}
