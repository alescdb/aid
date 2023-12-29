BINARY  := release/aid
VERSION := $(shell cat pubspec.yaml | grep -E '^version: [0-9|.|r|-]+'  | cut -d ' ' -f 2)
RELEASE := $(shell cat pubspec.yaml | grep -E '^release: [0-9|.|r|-]+'  | cut -d ' ' -f 2)


release: clean ${BINARY}

${BINARY}:
	mkdir -p release
	dart compile exe --output ./release/aid bin/aid.dart

clean:
	rm -rf release archlinux/.SRCINFO

install: clean
	@echo VERSION=$(VERSION) RELEASE=$(RELEASE)
	cd archlinux && \
		sed -i -E "s/^pkgver=([0-9|.|r|-]+)/pkgver=$(VERSION)/g" PKGBUILD && \
		sed -i -E "s/^pkgrel=([0-9|.|r|-]+)/pkgrel=$(RELEASE)/g" PKGBUILD && \
		makepkg --printsrcinfo > .SRCINFO && \
		makepkg -si

install-local: ${BINARY}
	sudo cp -v ${BINARY} /usr/local/bin/
