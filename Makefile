# SPDX-License-Identifier: MIT
# Copyright (c) 2018-2020 Iruatã Martins dos Santos Souza

NOPSYS != ./getsys.sh

ASFLAGS += -Isrc

SRC=\
	src/arch.ns\
	src/comments.ns\
	src/dictionary.ns\
	src/file.ns\
	src/flowcontrol.ns\
	src/go.ns\
	src/interactive.ns\
	src/interpreter.ns\
	src/loadpaths.ns\
	src/memory.ns\
	src/pictured.ns\
	src/shell.ns\
	src/string.ns\
	src/boot.s\
	src/dicts.s\
	src/${NOPSYS}/boot.s\
	src/${NOPSYS}/os.s\
	src/${NOPSYS}/nop.s\

all: bin/nop

bin/nop: bin/nop.o
	${CC} -ggdb -o $@ $^ -ldl
	@bin/nop /dev/null   # test the bootstrap

bin/nop.o: ${SRC}
	mkdir -p bin
	${AS} -ggdb ${ASFLAGS} -o $@ src/${NOPSYS}/nop.s

d: all
	gdb -x cmd.gdb bin/nop

test: bin/nop
	bin/nop test/logic.ns
	bin/nop test/fileio.ns && rm -f test.out
	bin/nop test/clib.ns
	bin/nop test/endian.ns

.PHONY: test

clean:
	rm -f bin/*.o bin/nop
