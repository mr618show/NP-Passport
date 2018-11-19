# NPTracker

A lightweight, geo-aware application for keeping track of your visited National Parks in United States 


Completed user stories:
Map View
 - Loading 58 national parks location from coordinates retrieved from NPS API
 - Persist all the park data in Core Data for offline usage
 - Map View reload pins when data in Core Data is changed
 - Search bar with drop down menu shows suggested search result
 - Map view zoom in to selected park location after selection
 - Showing custom annotation with markers with color-coding for parks visited
 - Custom callout accessory views with segue to park detail View

Park Detail View
 - Loading park detail information from fetching data saved in Core Data
 - Image cache to avoid fetching multiple times
 - A switch that provides interation for user to mark the current park as 'visited'
 - Map view annotation color-coding change when a park is marked as 'visited'


Walkthrough of all user stories:

![Video Walkthrough](https://github.com/mr618show/NPTracker/blob/master/nptracker.gif) 



GIF created with [LiceCap](http://www.cockos.com/licecap/).
Copyright 2018 RuiMao
