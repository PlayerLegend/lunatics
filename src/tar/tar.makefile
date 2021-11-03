test/tar-dump-posix-header: src/tar/tar-dump-posix-header.test.o src/buffer_io/buffer_io.o src/log/log.o
test/list-tar: src/tar/list-tar.test.o src/buffer_io/buffer_io.o src/log/log.o

TESTS_C += test/tar-dump-posix-header test/list-tar
