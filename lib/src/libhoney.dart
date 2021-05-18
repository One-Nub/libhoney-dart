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
/// such as a [dataset] name and [writeKey] - which must be set for proper event sending.
/// [sampleRate] enables the sending of events based off of a 1 / [sampleRate] chance.
/// Sending is enabled by default but can be disabled via the [disabled] option.
class Libhoney {
  /// The default host where events are sent to. Must be URI parsable
  ///
  /// Events will be sent to "/1/events/" on this host.
  String apiHost;

  /// The name of a default [dataset](https://docs.honeycomb.io/getting-data-in/best-practices/#use-datasets-to-group-data) for events to be sent to.
  ///
  /// Must be set in Libhoney or on an [Event] or else [MissingDatasetName] will be thrown.
  String? dataset;

  /// API key for Honeycomb.io. Keep this a secret.
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
  Map<String, dynamic> _globalFields = {};

  /// Maximum size of the response queue.
  int maxResponseQueueSize;

  /// Queue of responses from sent events.
  ///
  /// Will increase up to [maxResponseQueueSize] where new responses
  /// will be dropped.
  Queue<EventResponse> responseQueue = Queue();

  /// Adds a response to the response queue.
  void _addResponse(EventResponse eventResponse) {
    if(responseQueue.length < maxResponseQueueSize) {
      responseQueue.add(eventResponse);
    }
  }

  /// Creates a new Libhoney client.
  ///
  /// [httpClient] presents the opportunity to set the Client that [Transmission]
  /// will use, enabling testing or custom Client implementations. For events to
  /// be sent without an error, [dataset] and [writeKey] MUST be assigned. According
  /// to the SDK spec these can be null by default. [maxResponseQueueSize] is
  /// the maximum size of the response queue, and [disableResponseQueue] will
  /// disable the queueing of responses altogether.
  Libhoney(
      {this.apiHost = _apiHost,
      this.dataset,
      this.writeKey,
      this.sampleRate = 1,
      this.disabled = false,
      this.maxResponseQueueSize = 1000,
      bool disableResponseQueue = false,
      Client? httpClient}) {
    if (!disabled) _transmission = Transmission();
    if (disableResponseQueue) maxResponseQueueSize = 0;

    if(httpClient != null && !disabled) {
      _transmission!.client = httpClient;
    }
  }

  /// Sends a specific [Event] to internal [Transmission].
  ///
  /// Validates an [Event]'s required arguments.
  /// Throws [MissingApiHost] when [Event.apiHost] is null or empty.
  /// Throws [MissingDatasetName] when [Event.dataset] is null or empty.
  /// Throws [MissingWriteKey] when [Event.writeKey] is null or empty.
  /// A default sample rate of `1` and a timestamp of the current time will be
  /// defined if they are not predefined. If there is no event
  /// data [MissingData] will be thrown.
  Future<void> sendEvent(Event event) async {
    Event validatedEvent = _validateEvent(event);
    if(_transmission != null) {
      _transmission!.send(validatedEvent);
    }
  }

  /// Sets a field globally for all further events to inherit when being sent.
  void addGlobalField(String key, dynamic val) {
    _globalFields[key] = val;
  }

  /// Get a Map of all the set global fields that events will inherit.
  Map<String, dynamic> getGlobalFields() {
    return _globalFields;
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
