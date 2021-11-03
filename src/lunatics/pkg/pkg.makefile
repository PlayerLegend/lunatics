sbin/pkg-tar-install: src/lunatics/pkg/pkg-tar-install.util.o src/lunatics/pkg/path.o src/lunatics/pkg/logfile.o src/tar/tar.o src/buffer_io/buffer_io.o src/log/log.o src/immutable/immutable.o
sbin/pkg-tar-getfile: src/lunatics/pkg/pkg-tar-getfile.util.o src/tar/tar.o src/buffer_io/buffer_io.o src/log/log.o
sbin/pkg-uninstall: src/lunatics/pkg/pkg-uninstall.util.o src/lunatics/pkg/path.o src/lunatics/pkg/logfile.o src/buffer_io/buffer_io.o src/log/log.o src/immutable/immutable.o
sbin/pkg-install: src/lunatics/pkg/pkg-install.sh
sbin/pkg-info: src/lunatics/pkg/pkg-info.sh
sbin/pkg-repos: src/lunatics/pkg/pkg-repos.sh
sbin/pkg-depends: src/lunatics/pkg/pkg-depends.sh
sbin/pkg-host: src/lunatics/pkg/pkg-host.sh
sbin/pkg-get: src/lunatics/pkg/pkg-get.sh
sbin/pkg-build-autotools: src/lunatics/pkg/pkg-build-autotools.sh
sbin/pkg-makepkg: src/lunatics/pkg/pkg-makepkg.sh
sbin/pkg-build: src/lunatics/pkg/pkg-build.sh
sbin/pkg-gen-script: src/lunatics/pkg/pkg-gen-script.sh
sbin/pkg-script: src/lunatics/pkg/pkg-script.sh
sbin/pkg-source: src/lunatics/pkg/pkg-source.sh
sbin/pkg-tar: src/lunatics/pkg/pkg-tar.sh

UTILS_C += sbin/pkg-tar-install sbin/pkg-uninstall sbin/pkg-tar-getfile
UTILS_SH +=  sbin/pkg-makepkg sbin/pkg-build-autotools sbin/pkg-gen-script sbin/pkg-build sbin/pkg-install sbin/pkg-info sbin/pkg-repos sbin/pkg-depends sbin/pkg-host sbin/pkg-get sbin/pkg-script sbin/pkg-source sbin/pkg-tar

INITRD_UTILS += sbin/pkg-makepkg sbin/pkg-build-autotools sbin/pkg-gen-script sbin/pkg-build sbin/pkg-tar-install sbin/pkg-install sbin/pkg-uninstall sbin/pkg-tar-getfile sbin/pkg-info sbin/pkg-repos sbin/pkg-depends sbin/pkg-host sbin/pkg-get sbin/pkg-script sbin/pkg-source sbin/pkg-tar
