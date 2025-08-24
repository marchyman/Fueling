PROJECT = Fueling

buildServer.json:	Build
	xcode-build-server config -scheme "$(PROJECT)" -project *.xcodeproj
	sed -i '~' "/\"build_root\"/s/: \"\(.*\)\"/: \"\1\/DerivedData\/$(PROJECT)\"/" buildServer.json

Build:	$(PROJECT).xcodeproj/project.pbxproj
	xcodebuild -scheme $(PROJECT)

$(PROJECT).xcodeproj/project.pbxproj:	project.yml
	xcodegen -c

# Unit tests
test:
	xcodebuild -scheme $(PROJECT) test | tee .test.out | xcbeautify

# UI tests fail.
watchtest:
	xcodebuild -scheme 'Fueling Watch App' \
		-destination id=D428AA79-89F5-42CC-A19C-F02E757AFD07 \
		test | tee .test.out | xcbeautify

# force project file rebuild
proj:
	xcodegen

# remove files created during the build process
# do **not** use the -d option to git clean without excluding .jj
clean:
	jj status
	git clean -dfx -e .jj -e notes
