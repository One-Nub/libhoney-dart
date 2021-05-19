# libhoney-dart 
A Dart library for sending events to [Honeycomb](https://www.honeycomb.io/). Built to follow the [SDK](https://docs.honeycomb.io/api/sdk-spec/) spec presented by Honeycomb. Currently meets the minimum specifications with Response support.

I have not tested to see if this works in Flutter, although I have no reason to believe why it wouldn't. Any insight on that would be appreciated! 

# Usage
The sample usage seen below is the same as usage in [this](https://github.com/One-Nub/libhoney-dart/blob/main/example/example.dart) example file

```dart
import "package:libhoney_dart/libhoney-dart.dart";

// Main function
void main() {
  Libhoney honey = Libhoney(writeKey: "API_KEY", dataset: "your_dataset");

  Event event = Event(honey);
  event.addField("user ID", 4829034023923094);
  event.addMap({
    "access": "member", 
    "crashed": false
  });
  event.metadata = "EVENT_1";

  // Awaiting this will force the code to wait for the response in honey.responseQueue
  event.send();
}
```

# Contributing
Features, bug fixes and other changes to libhoney-dart are gladly accepted. Please open issues or a pull request with your change.

All contributions will be released under the Apache License 2.0.

This library attempts to conform to the [Effective Dart](https://dart.dev/guides/language/effective-dart/style) styling where possible. The **primary exception** is that the line limit is at 120 characters. This can be enforced through `dart format --line-length 120`

## Testing
Tests can be ran from the root directory with `dart test`. The test cases do not fully replicate responses from [Honeycomb](https://honeycomb.io) and as such any tests that require publishing upstream will need to be performed locally with your own API key and dataset.

The current test cases do not send any data upstream to Honeycomb, resulting in the necessity of locally testing any changes relating to upstream sending.

# License
libhoney-dart is released under the Apache 2.0 license as outlined in the [README.md](https://github.com/One-Nub/libhoney-dart/blob/main/LICENSE)