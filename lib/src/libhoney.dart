part of '../libhoney-dart.dart';

const _apiHost = "https://api.honeycomb.io";
const _eventEndpoint = "/1/events/";
const _version = "0.1.0";

class Libhoney {
  String apiHost;
  String? dataset;
  String? writeKey;
  int sampleRate;

  Map _globalFields = {};
  
  Libhoney({this.apiHost = _apiHost, dataset, writeKey, this.sampleRate = 1});

  Future<void> sendEvent(Event event) async {
    //TODO: Validate event contents via method
  }

  void addGlobalField(String key, Object val) {
    _globalFields[key] = val;
  }
}
