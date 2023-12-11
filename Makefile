RELEASE=release/aid

release: clean ${RELEASE}

${RELEASE}:
	mkdir -p release
	dart compile exe --output ./release/aid bin/aid.dart

clean:
	rm -rf release

install: ${RELEASE}
	sudo cp -v ${RELEASE} /usr/local/bin/
