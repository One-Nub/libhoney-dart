import '../lib/libhoney-dart.dart';

import 'package:test/test.dart';

void main() {
  Libhoney honey = Libhoney();
  honey.addGlobalField("global-key", "global-val");

  DateTime testTime = DateTime.now();
  Event testEventInheritance = Event(honey, timestamp: testTime);

  group("Event Inheritance from Libhoney.", () {
    test("Inherit apiHost", () {
      expect(testEventInheritance.apiHost, equals(honey.apiHost));
    });

    test("Inherit dataset", () {
      expect(testEventInheritance.dataset, equals(honey.dataset));
    });

    test("Inherit writeKey", () {
      expect(testEventInheritance.writeKey, equals(honey.writeKey));
    });

    test("Inherit sampleRate", () {
      expect(testEventInheritance.sampleRate, equals(honey.sampleRate));
    });

    test("Inherit fields", () {
      expect(testEventInheritance.getFields(), equals(honey.getGlobalFields()));
    });
  });

  Event testEvent = Event(honey,
      apiHost: "https://example.com/",
      dataset: "event_dataset",
      writeKey: "TOKEN_2",
      sampleRate: 5,
      timestamp: testTime,
      fields: {"a": "b"});

  testEvent.addField("x", "y");
  testEvent.addMap({"x": "z", "bool": false});

  // Tests that event values is set correctly and that it does not match
  // Libhoney properties.
  group("Event creation without inheritance.", () {
    test("apiHost assignment", () {
      expect(testEvent.apiHost, equals("https://example.com/"));
      expect(testEvent.apiHost, isNot(equals(honey.apiHost)));
    });

    test("dataset assignment", () {
      expect(testEvent.dataset, equals("event_dataset"));
      expect(testEvent.dataset, isNot(equals(honey.dataset)));
    });

    test("writeKey assignment", () {
      expect(testEvent.writeKey, equals("TOKEN_2"));
      expect(testEvent.writeKey, isNot(equals(honey.writeKey)));
    });

    test("sampleRate assignment", () {
      expect(testEvent.sampleRate, equals(5));
      expect(testEvent.sampleRate, isNot(equals(honey.sampleRate)));
    });

    test("timestamp assignment", () {
      expect(testEvent.timestamp, equals(testTime));
    });

    test("fields assignment", () {
      Map<String, dynamic> correctFields = {"global-key": "global-val", "a": "b", "x": "z", "bool": false};

      expect(testEvent.getFields(), equals(correctFields));
      expect(testEvent.getFields(), isNot(equals(honey.getGlobalFields())));
    });
  });
}
