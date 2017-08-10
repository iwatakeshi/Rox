all: build

build:
	swift build

test: build
	swift test

run: build
	./.build/debug/Rox