all: build

# generate a new xcode project
project:
	swift package generate-xcodeproj

# build the project
build:
	swift build

# build and test the project
test: build
	swift test
	
test2: build
	node ./Tests/test.js

# build and run the project
run: build
	./.build/debug/Rox

# execute a file
execute: build
	./.build/debug/Rox $(filter-out $@,$(MAKECMDGOALS))

%:
	@: