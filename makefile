PROJECT = Fueling

buildServer.json:	Build
	xcode-build-server config -scheme "$(PROJECT)" -project *.xcodeproj

Build:	$(PROJECT).xcodeproj/project.pbxproj
	xcodebuild -scheme $(PROJECT)

$(PROJECT).xcodeproj/project.pbxproj:	project.yml
	xcodegen -c

# Unit tests
test:
	xcodebuild -scheme $(PROJECT) test | tee .test.out | xcbeautify

# UI tests fail. Probably because of improper phone app setup. The
# xcrun ... lines are an attempt to fix that.
watchtest:
	xcrun simctl shutdown 983670CF-B633-47E1-81E5-5B42688D0F5B
	xcrun simctl boot 983670CF-B633-47E1-81E5-5B42688D0F5B
	xcrun simctl launch 983670CF-B633-47E1-81E5-5B42688D0F5B org.snafu.Fueling -TESTING -UITEST
	xcodebuild -scheme 'Fueling Watch App' \
		-destination id=D428AA79-89F5-42CC-A19C-F02E757AFD07 \
		test | tee .test.out | xcbeautify

# force project file rebuild
proj:
	xcodegen

# remove files created during the build process
# do **not** use the -d option to git clean without excluding .jj
clean:
	xcodebuild clean
	jj status
	git clean -dfx -e .jj -e notes
