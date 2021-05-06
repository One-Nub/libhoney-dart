part of '../libhoney-dart.dart';

class Libhoney {
  static const _honeycombHost = "https://api.honeycomb.io";

  String apiHost;
  String? dataset;
  String? writeKey;
  int sampleRate;

  Map _globalFields = {};
  
  Libhoney({this.apiHost = _honeycombHost, dataset, writeKey, this.sampleRate = 1});

  Future<void> sendEvent(Event event) async {
    //TODO: Validate event contents via method
  }

  void addGlobalField(String key, Object val) {
    _globalFields[key] = val;
  }
}
