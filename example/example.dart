import 'package:libhoney_dart/libhoney_dart.dart';

// Main function
void main() {
  Libhoney honey = Libhoney(writeKey: "API_KEY", dataset: "your_dataset");

  Event event = Event(honey);
  event.addField("user ID", 4829034023923094);
  event.addMap({"access": "member", "crashed": false});
  event.metadata = "EVENT_1";

  // Awaiting this will force the code to wait for the response in honey.responseQueue
  event.send();
}
