# see: https://www.youtube.com/watch?v=IzMa-f6u_YM

export PREFIX=$(HOME)/libimobiledevice
export PKG_CONFIG_LIBDIR=$(PREFIX)/lib:/usr/lib64
export PKG_CONFIG_PATH=$(PREFIX)/lib/pkgconfig:/usr/lib64/pkgconfig

.PHONY: help
help:
	@echo "clean    Clean environment"
	@echo "deps     Install and prepare dependencies"
	@echo "build    Build and install in the local environment"

.PHONY: clean
clean:
	rm -rf "$(PREFIX)"
	cd idevicerestore         && ( [ ! -e Makefile ] || make clean )
	cd libirecovery           && ( [ ! -e Makefile ] || make clean )
	cd libimobiledevice-glue  && ( [ ! -e Makefile ] || make clean )
	cd libusbmuxd             && ( [ ! -e Makefile ] || make clean )
	cd libtatsu               && ( [ ! -e Makefile ] || make clean )
	cd libimobiledevice       && ( [ ! -e Makefile ] || make clean )
	cd libplist               && ( [ ! -e Makefile ] || make clean )
	cd usbmuxd                && ( [ ! -e Makefile ] || make clean )

.PHONY: custom
custom:
	sudo dnf install powerline-go powerline-fonts neovim --exclude=nodejs --exclude=gcc

.PHONY: deps
deps: custom
	sudo dnf install -y libtool clang autoconf automake libusb1-devel libcurl-devel libzip-devel
	git submodule init
	[ -e usbmuxd ] || git submodule add -b master https://github.com/libimobiledevice/usbmuxd.git usbmuxd
	[ -e idevicerestore ] || git submodule add -b master https://github.com/libimobiledevice/idevicerestore.git idevicerestore
	[ -e libirecovery ] || git submodule add -b master https://github.com/libimobiledevice/libirecovery.git libirecovery
	[ -e libimobiledevice-glue ] || git submodule add -b master https://github.com/libimobiledevice/libimobiledevice-glue.git libimobiledevice-glue
	[ -e libusbmuxd ] || git submodule add -b master https://github.com/libimobiledevice/libusbmuxd.git libusbmuxd
	[ -e libtatsu ] || git submodule add -b master https://github.com/libimobiledevice/libtatsu.git libtatsu
	[ -e libimobiledevice ] || git submodule add -b master https://github.com/libimobiledevice/libimobiledevice.git libimobiledevice
	[ -e libplist ] || git submodule add -b master https://github.com/libimobiledevice/libplist.git libplist
	git submodule update

.PHONY: build
build:
	$(MAKE) build-libplist
	$(MAKE) build-libimobiledevice-glue
	$(MAKE) build-libirecovery
	$(MAKE) build-libusbmuxd
	$(MAKE) build-libtatsu
	$(MAKE) build-libimobiledevice
	$(MAKE) build-idevicerestore
	$(MAKE) build-usbmuxd

.PHONY: build-libtatsu
build-libtatsu:
	cd libtatsu && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-libusbmuxd
build-libusbmuxd:
	cd libusbmuxd && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-libimobiledevice
build-libimobiledevice:
	cd libimobiledevice && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-libplist
build-libplist:
	cd libplist && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-idevicerestore
build-libimobiledevice-glue:
	cd libimobiledevice-glue && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-libirecovery
build-libirecovery:
	cd libirecovery && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-idevicerestore
build-idevicerestore:
	cd idevicerestore && ./autogen.sh && ./configure --prefix="$(PREFIX)" && make && make install

.PHONY: build-usbmuxd
build-usbmuxd:
	cd usbmuxd && ./autogen.sh PACKAGE_VERSION="1.0.2" && ./configure --prefix="$(PREFIX)" PACKAGE_VERSION="1.0.2" && make

