all: build

# generate a new xcode project
generate:
	swift package generate-xcodeproj

# build the project
build:
	swift build

# build and test the project
test: build
	swift test

# build and run the project
run: build
	./.build/debug/Rox