# generate xcodeproj and build the apps
default:
	xcodegen -c
	xcodebuild -scheme Fueling
	buildserver Fueling

# Get rid of everything that can be generated
clean:
	git clean -dfx
