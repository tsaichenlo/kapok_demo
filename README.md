# kapok_demo

Feature: Real-time patient tracking & dynamic marker update.

## Implementation Breakdown

The feature I was responsible for in this project is real-time patient tracking and dynamic marker updates on the UI.

To achieve this, and to ensure compatibility on both iOS and Android mobile devices, I used Flutter as the frontend framework.

The google_maps_flutter package is the tool that bridges Flutter with the native Google Maps view on Android and iOS. Someone else on the team handled the backend Firebase logic, so for my local testing, I set up a mock data stream using Dart’s Stream.periodic() to simulate incoming backend updates. This stream periodically emits new coordinate data (LatLng objects) that represent patient movement.

I attached a listener to this stream to receive each new position update. Inside that listener, I used setState() to update the patient’s marker position stored in a map structure (Map<String, Marker>). Flutter’s setState() mechanism triggers a rebuild of the GoogleMap widget, which makes the marker move smoothly on the screen to the new coordinates.

The main widget, PatientMapScreen, is a stateful widget responsible for maintaining the marker state. The _markers map keeps track of each patient’s current position. When the data stream emits new coordinates, the corresponding marker in this map is updated. If we wanted to monitor multiple patients simultaneously, we could store multiple entries in the _markers map, each labeled with a different patient ID and coordinate set.

The UI is built using a Scaffold widget, which provides the basic page layout. Inside its body, the GoogleMap widget renders the map interface. The initialCameraPosition defines the starting viewpoint (latitude, longitude, and zoom level) when the map first loads — basically, where the camera should focus before any dynamic updates occur.
