part of '../libhoney-dart.dart';

class Event {
  Libhoney _libhoney;
  String? apiHost;
  String? dataset;
  String? writeKey;
  int? sampleRate;
  DateTime? timestamp;

  late Map _fields;

  Event(this._libhoney, 
      {this.apiHost,
      this.dataset,
      this.writeKey,
      this.sampleRate,
      this.timestamp,
      Map? fields}) {
    if (apiHost == null) apiHost = _libhoney.apiHost;

    if (dataset == null) dataset = _libhoney.dataset;

    if (writeKey == null) writeKey = _libhoney.writeKey;

    if (sampleRate == null) sampleRate = _libhoney.sampleRate;

    if (timestamp == null) timestamp = DateTime.now();

    if (fields == null) {
      //Assigns fields to global (since global is empty by default)
      _fields = _libhoney._globalFields;
    }
    else {
      //Combines global and parameter fields.
      _fields = {
        ..._libhoney._globalFields,
        ...fields
      };
    }
  }

  addField(String key, Object val) {
    _fields[key] = val;
  }

  send() {
    _libhoney.sendEvent(this);
  }
}
