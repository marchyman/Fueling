# Fueling

A play app to keep track of gas mileage.  I'm using it to learn Apple
phone/watch interaction. All data is owned/persisted by the phone using
SwiftData in a manner where it is **not** tied to SwiftUI.

The watch requests data from the phone to show current state. See the comments
in MessageKey.swift to see the data flow between the two devices.

I don't pretend to know what I'm doing.  The purpose of this app is as much
for me to learn as it is to do something useful.

Notes:

- updates from watch seem to be working but...  If the phone app is showing
  the Vehicle view for the vehicle that got a fueling update the new data
  is not shown, e.g. the view is not updating.  Going back then re-selecting
  the vehicle shows current data.
