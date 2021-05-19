part of '../libhoney-dart.dart';

/// Event to be sent to the upstream [apiHost].
class Event {
  // TODO: Consider making libhoney public and define a setter to update all instance vars after Event creation.

  /// A Libhoney class, used for getting default variables and sending Events.
  Libhoney _libhoney;

  /// The host url where events are sent to. If not defined will inherit Libhoney parameter's [Libhoney.apiHost].
  String? apiHost;

  /// The [Dataset](https://docs.honeycomb.io/getting-data-in/best-practices/#use-datasets-to-group-data) for an event to be defined to be a part of.
  String? dataset;

  /// The API key given to a user by Honeycomb.
  String? writeKey;

  /// The sample rate for the event.
  ///
  /// Chance of being sent is 1 / sampleRate.
  int? sampleRate;

  /// The time that the event was occurred at.
  ///
  /// If there is no time set, the event will be set to the current time
  /// when it is sent.
  DateTime? timestamp;

  /// The fields that the event holds.
  ///
  /// Will be defined to [Libhoney._globalFields] if not set upon event creation.
  Map<String, dynamic> _fields = {};

  /// Metadata used to identify event in [EventResponse] queue.
  dynamic? metadata;

  /// Creates an Event.
  Event(this._libhoney,
      {this.apiHost,
      this.dataset,
      this.writeKey,
      this.sampleRate,
      this.timestamp,
      this.metadata,
      Map<String, dynamic>? fields}) {
    apiHost ??= _libhoney.apiHost;

    dataset ??= _libhoney.dataset;

    writeKey ??= _libhoney.writeKey;

    sampleRate ??= _libhoney.sampleRate;

    if (fields == null && _libhoney._globalFields.isNotEmpty) {
      _fields.addAll(_libhoney._globalFields);
    } else {
      // Combines global and parameter fields, empty map if both null
      _fields = {..._libhoney._globalFields, ...?fields};
    }
  }

  /// Adds a field to the Event.
  void addField(String key, Object val) {
    _fields[key] = val;
  }

  /// Adds a map of values to the Event fields.
  void addMap(Map<String, dynamic> newVals) {
    _fields.addAll(newVals);
  }

  /// Get all fields this Event holds.
  Map<String, dynamic> getFields() {
    return _fields;
  }

  /// Sends this event. Equivalent to [Libhoney.sendEvent()].
  Future<void> send() async {
    await _libhoney.sendEvent(this);
  }

  /// Sends this event without performing sampling internally.
  Future<void> sendPresampled() async {
    await _libhoney.sendEvent(this, presampled: true);
  }
}
