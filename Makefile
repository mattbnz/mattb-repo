
N := "$$(find .. -maxdepth 1 -type d -name mattb-repo-* | wc -l)"
D := "$$(find .. -maxdepth 1 -type d -name mattb-repo-*)"

all:
	:

install:
	install -m 644 -D mattb.list \
		$(DESTDIR)/etc/apt/sources.list.d/mattb.list
	install -m 644 -D archive-keyring.gpg \
		$(DESTDIR)/etc/apt/trusted.gpg.d/mattb.gpg

deb:
	@if [ $(N) -gt 0 ]; then \
		echo "Error: previous build directory still present!"; false; fi
	debmake -t
	cd $(D) && \
		sed -i 's/Initial .*/Initial bootstrap package/;s/.*ITP.*//' \
			debian/changelog && \
		dch -D internal -r --force-distribution "" && \
		dpkg-buildpackage -uc -us

.PHONY: all install
