LD = $(CC)
PREFIX ?= /usr/local
DESTDIR ?= $(PREFIX)
CFLAGS += -std=c99
PATH := $(CURDIR)/bin/:$(CURDIR)/sbin/:$(PATH)

export PATH

all: utils

.PHONY: test bin debug utils install

#include src/*/*.makefile
SUB_MAKEFILES != find src -type f -name '*.makefile'
include $(SUB_MAKEFILES)

debug tests test: CFLAGS += -g -Wall -Werror
utils: CFLAGS += -DNDEBUG

utils debug: $(UTILS_C) $(UTILS_SH)
tests test debug: $(TESTS_C) $(TESTS_SH)

$(UTILS_C) $(TESTS_C):
	@mkdir -p $(@D)
	$(LD) -o $@ $^ $> $(LDLIBS)

$(UTILS_SH) $(TESTS_SH):
	@mkdir -p $(@D)
	cp $< $@
	chmod +x $@

test:
	sh run-tests.sh $(RUN_TESTS)

clean-fast:
	rm -rf test bin sbin init `find src -name '*.o'`

clean: clean-fast
	rm -rf external boot

depend: clean
	makedepend -Y `find src include -name '*.c*' -or -name '*.h*'`

install: utils
	printf '%s\n' $(UTILS_C) $(UTILS_SH) | cpio -pudm $(DESTDIR)/

# DO NOT DELETE

src/tar/tar.o: src/array/range.h src/array/buffer.h src/buffer_io/buffer_io.h
src/tar/tar.o: src/tar/spec.h src/log/log.h src/tar/tar.h
src/tar/tar-dump-posix-header.test.o: src/array/range.h src/array/buffer.h
src/tar/tar-dump-posix-header.test.o: src/buffer_io/buffer_io.h
src/tar/tar-dump-posix-header.test.o: src/tar/spec.h src/log/log.h
src/tar/list-tar.test.o: src/tar/tar.c src/array/range.h src/array/buffer.h
src/tar/list-tar.test.o: src/buffer_io/buffer_io.h src/tar/spec.h
src/tar/list-tar.test.o: src/log/log.h src/tar/tar.h
src/tar/tar.o: src/array/range.h src/array/buffer.h src/buffer_io/buffer_io.h
src/tar/tar.o: src/tar/spec.h src/log/log.h
src/event/event.o: src/event/event.h
src/log/log.o: src/log/log.h
src/log/log.test.o: src/log/log.c src/log/log.h src/test/debug.h
src/vec/vec2.o: src/vec/vec.h
src/vec/mat4.o: src/vec/vec.h src/vec/vec3.h src/vec/vec4.h src/vec/mat4.h
src/vec/vec3.o: src/vec/vec.h
src/vec/vec4.o: src/vec/vec.h
src/vec/mat4.o: src/vec/vec.h src/vec/vec3.h
src/vec/vec.test.o: src/vec/vec.h src/vec/vec2.h src/vec/vec3.h
src/vec/vec.test.o: src/test/debug.h
src/printf_string/print.o: src/array/range.h
src/printf_string/printf_string.test.o: src/printf_string/printf_string.c
src/printf_string/printf_string.test.o: src/printf_string/printf_string.h
src/printf_string/printf_string.test.o: src/test/debug.h
src/printf_string/print.o: src/printf_string/print.h
src/printf_string/printf_string.o: src/printf_string/printf_string.h
src/gltf/gltf.o: src/log/log.h src/array/range.h src/array/buffer.h
src/gltf/gltf.o: src/file/file.h src/json/json.h src/gltf/gltf.h
src/gltf/glb-toc.test.o: src/array/range.h src/json/json.h src/gltf/gltf.h
src/gltf/glb-toc.test.o: src/log/log.h
src/gltf/glb-json.util.o: src/array/range.h src/json/json.h src/gltf/gltf.h
src/gltf/glb-json.util.o: src/log/log.h
src/gltf/gltf.o: src/array/range.h src/json/json.h
src/gltf/glb-info.util.o: src/array/range.h src/json/json.h src/gltf/gltf.h
src/gltf/glb-info.util.o: src/log/log.h
src/buffer_io/buffer_io.o: src/array/range.h src/array/buffer.h
src/buffer_io/buffer_io.o: src/buffer_io/buffer_io.h
src/buffer_io/buffer_io.test.o: src/array/range.h src/array/buffer.h
src/buffer_io/buffer_io.test.o: src/buffer_io/buffer_io.h src/test/debug.h
src/buffer_io/buffer_io.o: src/array/range.h src/array/buffer.h
src/table/table.o: src/array/range.h src/list/list.h
src/table/table.test.o: src/table/table.h src/array/range.h src/list/list.h
src/ipfs/ipfs-ls.test.o: src/log/log.h src/array/range.h src/array/buffer.h
src/ipfs/ipfs-ls.test.o: src/buffer_io/buffer_io.h src/ipfs/ipfs.h
src/ipfs/ipfs.o: src/array/range.h src/array/buffer.h
src/ipfs/ipfs.o: src/buffer_io/buffer_io.h
src/ipfs/ipfs.o: src/log/log.h src/network/network.h src/array/range.h
src/ipfs/ipfs.o: src/array/buffer.h src/buffer_io/buffer_io.h src/ipfs/ipfs.h
src/ipfs/ipfs-get.test.o: src/log/log.h src/array/range.h src/array/buffer.h
src/ipfs/ipfs-get.test.o: src/buffer_io/buffer_io.h src/ipfs/ipfs.h
src/paren-parser/paren-parser.test.o: src/immutable/immutable.h
src/paren-parser/paren-parser.test.o: src/paren-parser/paren-parser.h
src/paren-parser/paren-parser.test.o: src/array/range.h src/array/buffer.h
src/paren-parser/paren-parser.test.o: src/buffer_io/buffer_io.h
src/paren-parser/paren-preprocessor.test.o: src/immutable/immutable.h
src/paren-parser/paren-preprocessor.test.o: src/paren-parser/paren-parser.h
src/paren-parser/paren-preprocessor.test.o: src/paren-parser/paren-preprocessor.h
src/paren-parser/paren-preprocessor.test.o: src/array/range.h
src/paren-parser/paren-preprocessor.test.o: src/array/buffer.h
src/paren-parser/paren-preprocessor.test.o: src/buffer_io/buffer_io.h
src/paren-parser/paren-preprocessor.o: src/immutable/immutable.h
src/paren-parser/paren-preprocessor.o: src/paren-parser/paren-parser.h
src/paren-parser/paren-parser.o: src/immutable/immutable.h
src/paren-parser/paren-parser.o: src/immutable/immutable.h
src/paren-parser/paren-parser.o: src/paren-parser/paren-parser.h
src/paren-parser/paren-parser.o: src/log/log.h src/array/range.h
src/paren-parser/paren-parser.o: src/array/buffer.h
src/paren-parser/paren-preprocessor.o: src/log/log.h src/array/range.h
src/paren-parser/paren-preprocessor.o: src/array/buffer.h
src/paren-parser/paren-preprocessor.o: src/immutable/immutable.h
src/paren-parser/paren-preprocessor.o: src/paren-parser/paren-parser.h
src/paren-parser/paren-preprocessor.o: src/paren-parser/paren-preprocessor.h
src/array/buffer.o: src/array/range.h
src/array/range.test.o: src/array/range.h src/test/debug.h
src/array/buffer.test.o: src/array/buffer.h src/array/range.h
src/array/buffer.test.o: src/test/debug.h
src/immutable/immutable.o: src/immutable/immutable.h src/list/list.h
src/immutable/immutable.o: src/array/range.h src/table/table.h
src/immutable/immutable.test.o: src/immutable/immutable.c
src/immutable/immutable.test.o: src/immutable/immutable.h src/list/list.h
src/immutable/immutable.test.o: src/array/range.h src/table/table.h
src/immutable/immutable.test.o: src/test/debug.h
src/http/http.o: src/array/range.h src/array/buffer.h
src/http/http-cat.test.o: src/array/range.h src/array/buffer.h
src/http/http-cat.test.o: src/http/http.h src/log/log.h
src/http/http.o: src/array/range.h src/array/buffer.h src/http/http.h
src/http/http.o: src/network/network.h src/log/log.h
src/http/http.o: src/buffer_io/buffer_io.h
src/http/http-raw.test.o: src/http/http.c src/array/range.h
src/http/http-raw.test.o: src/array/buffer.h src/http/http.h
src/http/http-raw.test.o: src/network/network.h src/log/log.h
src/http/http-raw.test.o: src/buffer_io/buffer_io.h
src/network/network.o: src/array/range.h src/log/log.h src/network/network.h
src/network/test-tcp/server.test.o: src/network/network.h src/test/debug.h
src/network/test-tcp/server.test.o: src/array/range.h src/array/buffer.h
src/network/test-tcp/server.test.o: src/buffer_io/buffer_io.h src/log/log.h
src/vm/vm.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/vm.o: src/vm/machine-code.h
src/vm/assembler.o: src/immutable/immutable.h src/paren-parser/paren-parser.h
src/vm/assembler.o: src/array/range.h src/array/buffer.h src/log/log.h
src/vm/assembler.o: src/vm/arch.h src/vm/machine-code.h src/vm/assembler.h
src/vm/assembler.o: src/vm/text.h src/vm/constants.h
src/vm/text.o: src/array/range.h src/array/buffer.h src/immutable/immutable.h
src/vm/text.o: src/vm/arch.h src/vm/text.h
src/vm/compiler.o: src/array/range.h src/array/buffer.h
src/vm/compiler.o: src/immutable/immutable.h src/paren-parser/paren-parser.h
src/vm/compiler.o: src/vm/arch.h
src/vm/assembler.test.o: src/immutable/immutable.h
src/vm/assembler.test.o: src/paren-parser/paren-parser.h
src/vm/assembler.test.o: src/paren-parser/paren-preprocessor.h
src/vm/assembler.test.o: src/array/range.h src/array/buffer.h src/log/log.h
src/vm/assembler.test.o: src/vm/arch.h src/vm/machine-code.h
src/vm/assembler.test.o: src/vm/assembler.h
src/vm/vm.test.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/vm.test.o: src/vm/machine-code.h src/vm/vm.h src/log/log.h
src/vm/machine-code.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/constants.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/constants.o: src/vm/constants.h
src/vm/text.o: src/array/range.h src/array/buffer.h src/immutable/immutable.h
src/vm/text.o: src/vm/arch.h
src/vm/assembler.o: src/immutable/immutable.h src/paren-parser/paren-parser.h
src/vm/assembler.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/assembler.o: src/vm/vm.h
src/vm/vm.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/vm.o: src/vm/machine-code.h src/vm/vm.h src/log/log.h
src/vm/constants.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/arch.o: src/array/range.h src/array/buffer.h
src/vm/machine-code.o: src/array/range.h src/array/buffer.h src/vm/arch.h
src/vm/machine-code.o: src/vm/machine-code.h
src/manga-reader/ui.o: src/ipfs/ipfs.h
src/json/json.test.o: src/json/json.c src/array/range.h src/json/json.h
src/json/json.test.o: src/array/buffer.h src/log/log.h src/list/list.h
src/json/json.test.o: src/table/table.h
src/json/json.o: src/array/range.h
src/json/json.o: src/array/range.h src/json/json.h src/array/buffer.h
src/json/json.o: src/log/log.h src/list/list.h src/table/table.h
src/list/list.test.o: src/list/list.h src/test/debug.h
src/file/file.o: src/array/range.h src/array/buffer.h
src/file/file.test.o: src/file/file.c src/array/range.h src/array/buffer.h
src/file/file.test.o: src/file/file.h src/test/debug.h
src/file/file.o: src/array/range.h src/array/buffer.h src/file/file.h
src/pkg-tar/pkg-tar.util.o: src/array/range.h src/array/buffer.h
src/pkg-tar/pkg-tar.util.o: src/buffer_io/buffer_io.h src/tar/spec.h
src/pkg-tar/pkg-tar.util.o: src/log/log.h src/tar/tar.h src/list/list.h
src/pkg-tar/pkg-tar.util.o: src/immutable/immutable.h src/table/table.h
