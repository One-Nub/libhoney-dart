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
  /// Will be set to the time the event was instantiated if not passed in Event constructor.
  DateTime? timestamp;

  /// The fields that the event holds.
  ///
  /// Will be defined to [Libhoney._globalFields] if not set upon event creation.
  late Map<String, dynamic> _fields;

  /// Creates an Event.
  Event(this._libhoney,
      {this.apiHost,
      this.dataset,
      this.writeKey,
      this.sampleRate,
      this.timestamp,
      Map<String, dynamic>? fields}) {
    apiHost ??= _libhoney.apiHost;

    dataset ??= _libhoney.dataset;

    writeKey ??= _libhoney.writeKey;

    sampleRate ??= _libhoney.sampleRate;

    timestamp ??= DateTime.now();

    if (fields == null) {
      // Assigns fields to global (since global is empty by default)
      _fields = _libhoney._globalFields;
    }
    else {
      // Combines global and parameter fields.
      _fields = {
        ..._libhoney._globalFields,
        ...fields
      };
    }
  }

  /// Adds a field to the Event.
  addField(String key, Object val) {
    _fields[key] = val;
  }

  /// Sends this event. Equivalent to [Libhoney.sendEvent()].
  send() {
    _libhoney.sendEvent(this);
  }
}
