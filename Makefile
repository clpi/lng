OBJ_ROOT=dist/obj
PYTHON_EXECUTABLE=x.py

CC=clang
CXX=clang++
CFLAGS=`llvm-config --cflags`
LDFLAGS=`llvm-config --ldflags`
LDLIBBS= -lm
CXXFLAGS=`llvm-config --cxxflags`
XFLAGS=-ffast-math

SRC=src
OUT=dist
BIN=idx
SRCFLE=$(SRC)/idx.c
OUTBIN=$(OUT)/bin
OUTOBJ=$(OUT)/obj
OUTTMP=$(OUT)/tmp

CCFILES = $(wildcard *.cc)

all: setup build-llvm-bc build-llvm-ll view-llvm-asm compile-llvm-asm run-llvm

setup:
	rm -rf $(OUT)/*
	mkdir -p $(OUTBIN)
	mkdir -p $(OUTOBJ)
	mkdir -p $(OUTTMP)

list:
	@echo "Listing..."


build:
	${CC} $(CFLAGS) $(SRCFLE) -o $(OUTBIN)/$(BIN)

build-llvm-bc:
	$(CC) $(CFLAGS) -O3 -emit-llvm $(SRCFLE) -c -o $(OUTOBJ)/$(BIN).bc

build-llvm-ll:
	$(CC) $(CFLAGS) -O3 -emit-llvm $(SRCFLE) -S -o $(OUTOBJ)/$(BIN).ll

view-llvm-asm:
	llvm-dis < $(OUTOBJ)/$(BIN).bc | less

compile-llvm-asm:
	llc $(OUTOBJ)/$(BIN).bc -o $(OUTTMP)/$(BIN).s
	gcc $(OUTTMP)/$(BIN).s -o $(OUTBIN)/$(BIN)-llvm

run:
	./$(OUTBIN)/$(BIN)

run-llvm:
	./$(OUTBIN)/$(BIN)-llvm

run-llvm-bc:
	lli ./$(OUTOBJ)/$(BIN).bc
