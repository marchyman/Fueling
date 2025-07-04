PROJECT = Fueling

buildServer.json:	Build
	xcode-build-server config -scheme "$(PROJECT)" -project *.xcodeproj
	sed -i '~' "/\"build_root\"/s/: \"\(.*\)\"/: \"\1\/DerivedData\/$(PROJECT)\"/" buildServer.json

Build:	$(PROJECT).xcodeproj/project.pbxproj
	xcodebuild -scheme $(PROJECT)

$(PROJECT).xcodeproj/project.pbxproj:	project.yml
	xcodegen -c

# force project file rebuild
proj:
	xcodegen

# remove files created during the build process
# do **not** use the -d option to git clean without excluding .jj
clean:
	jj status
	git clean -dfx -e .jj
