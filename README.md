# Fueling

A play app to keep track of vehicle fuel use.  I'm using it to learn Apple
phone/watch interaction. All data is owned/persisted by the phone using
SwiftData.  SwiftData is used in a way that is not dependent upon SwiftUI.

Data flow between the watch and the companion app is described in comments
at the top of the file named MessageKey.swift.

I don't pretend to know what I'm doing.  The purpose of this app is as much
for me to learn as it is to do something useful.

## Requirements

- I am now using `xcodegen` to build the xcodeproj used to create this app.
  If needed install using brew.

- I use `xcode-build-server` to allow use of the Swift LSP inside neovim.
  `xcode-build-server` gets the root wrong since I use Build and DerivedData
  folders inside of the project folder. I've a script named `buildserver`
  that runs xcode-build-server then modifies the output as needed.

- I have a makefile to run `xcodegen`, do a build using `xcodebuild`,
  then run `buildserver`.  It prepares the project for edits/updates.
  Running `make clean` will remove all folders/files that `make` generates.
