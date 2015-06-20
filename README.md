# Overview
The goal of this project is to download and display the current position of the International Space Station (ISS) on a map.

1. Download current latitude/longitude from the ISS open API (no authentication is required).
2. Translate the latitude/longitude to a spaceship annotation within a MKMapView (MapKit Framework).
3. Automatically update the annotation every second
4. By tapping on the annotation, the closest city mapping to the latitude/longitude is displayed in a popover. 

#The follow techniques used
1. Objective-C
2. MVC patterns
3. Core location, MapKit Framework
4. KVO
5. GCD
6. Asynchronous networking (Third party for free use)