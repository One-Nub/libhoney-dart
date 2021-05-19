import 'package:libhoney_dart/libhoney_dart.dart';
import 'package:test/test.dart';

void main() {
  group("Default instance variables.", () {
    Libhoney honey = Libhoney();
    test("Default apiHost is equal to library constant", () {
      expect(honey.apiHost, equals("https://api.honeycomb.io"));
    });

    test("Default dataset is null", () {
      expect(honey.dataset, equals(null));
    });

    test("Default writeKey is null", () {
      expect(honey.writeKey, equals(null));
    });

    test("Default sample rate is 1", () {
      expect(honey.sampleRate, equals(1));
    });

    test("Library is enabled", () {
      expect(honey.disabled, false);
    });
  });

  group("Custom instance variables.", () {
    Libhoney honey = Libhoney(
        apiHost: "https://example.com", dataset: "dataset_1", writeKey: "TOKEN", sampleRate: 2, disabled: true);
    test("apiHost is equal to parameter", () {
      expect(honey.apiHost, equals("https://example.com"));
    });

    test("Dataset name is dataset_1", () {
      expect(honey.dataset, equals("dataset_1"));
    });

    test("writeKey is TOKEN", () {
      expect(honey.writeKey, equals("TOKEN"));
    });

    test("Sample rate is 2", () {
      expect(honey.sampleRate, equals(2));
    });

    test("Library is disabled", () {
      expect(honey.disabled, true);
    });
  });

  Libhoney honey = Libhoney();
  honey.addGlobalField("key", "LIB-TEST");
  test("Key added to global fields", () {
    expect(honey.getGlobalFields(), equals({"key": "LIB-TEST"}));
  });
}
