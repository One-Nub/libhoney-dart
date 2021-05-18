import '../lib/libhoney-dart.dart';

import 'dart:collection';
import 'dart:convert' show json;

import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  group("Send expecting errors.", () {
    Libhoney honey = Libhoney();
    Event event = Event(honey, apiHost: "");
    test("Missing or empty apiHost", () async {
      //Sending with event.send() causes the test case to not recognize the exception.
      expect(event.send(), throwsA(isA<MissingApiHost>()));
      expect(event.sendPresampled(), throwsA(isA<MissingApiHost>()));
      event.apiHost = honey.apiHost;
    });


    test("Missing or empty dataset", () async {
      expect(event.send(), throwsA(isA<MissingDatasetName>()));
      expect(event.sendPresampled(), throwsA(isA<MissingDatasetName>()));
      event.dataset = "dataset";
    });

    test("Missing or empty writeKey", () async {
      expect(event.send(), throwsA(isA<MissingWriteKey>()));
      expect(event.sendPresampled(), throwsA(isA<MissingWriteKey>()));
      event.writeKey = "TOKEN";
    });

    test("Missing payload data", () {
      expect(event.send(), throwsA(isA<MissingData>()));
      expect(event.sendPresampled(), throwsA(isA<MissingData>()));
    });
  });

  group("Sending event.", () {
    MockClient mockClient = MockClient((request) async {
      return Response(request.body, 200, headers: request.headers);
    });

    Map<String, dynamic> fields = {
      "key" : "value",
      "number" : 5234,
      "bool" : false
    };

    Libhoney honey = Libhoney(httpClient: mockClient,
        dataset: "testing",
        writeKey: "TOKEN",
        sampleRate: 2);
    Queue responseQueue = honey.responseQueue;

    test("Send with inheritance", () async {
      Event event = Event(honey, metadata: "eventOne", fields: fields);
      await event.sendPresampled();

      expect(responseQueue.length, equals(1));
      if(responseQueue.length == 1) {
        EventResponse er = responseQueue.removeFirst();
        expect(er.body, equals(json.encode(event.getFields())));
        expect(er.metadata, equals(event.metadata));

        expect(er.event.apiHost, equals(honey.apiHost));
        expect(er.event.dataset, equals(honey.dataset));
        expect(er.event.writeKey, equals("TOKEN"));
        expect(er.event.sampleRate, equals(2));
      }
      expect(responseQueue.length, equals(0));
    });

    test("Send with event overrides", () async {
      Event event = Event(honey, apiHost: "https://example.com", dataset: "cookieset",
        writeKey: "DEV_TOKEN", sampleRate: 5, metadata: "eventTwo", fields: fields);
      await event.sendPresampled();

      expect(responseQueue.length, equals(1));
      if(responseQueue.length == 1) {
        EventResponse er = responseQueue.removeFirst();
        expect(er.body, equals(json.encode(event.getFields())));
        expect(er.metadata, equals(event.metadata));

        expect(er.event.apiHost, isNot(equals(honey.apiHost)));
        expect(er.event.apiHost, equals("https://example.com"));

        expect(er.event.dataset, isNot(equals(honey.dataset)));
        expect(er.event.dataset, equals("cookieset"));

        expect(er.event.writeKey, isNot(equals("TOKEN")));
        expect(er.event.writeKey, equals("DEV_TOKEN"));

        expect(er.event.sampleRate, isNot(equals(1)));
        expect(er.event.sampleRate, equals(5));
      }
      expect(responseQueue.length, equals(0));
    }, skip: false);
  });
}