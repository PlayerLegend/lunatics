test/buffer_io: src/buffer_io/buffer_io.test.o src/buffer_io/buffer_io.o
test/run-buffer_io: src/buffer_io/run-buffer_io.test.sh

TESTS_C += test/buffer_io
TESTS_SH += test/run-buffer_io
RUN_TESTS += test/run-buffer_io
