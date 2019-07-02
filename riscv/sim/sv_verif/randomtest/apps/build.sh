#!/bin/bash

# architecture: mips or riscv
ARCH="riscv"
F_CLK=25000000

LIB_PATH="/software/lib"
LIB_PATH="../../../../../../software/lib"

CRR_PATH="/hf-riscv/verif/randomtest/apps/"

# compiler flags
CFLAGS_STRIP="-fdata-sections -ffunction-sections"
LDFLAGS_STRIP="--gc-sections"

CFLAGS_NO_HW_MULDIV="-mnohwmult -mnohwdiv -ffixed-lo -ffixed-hi"

GCC_riscv="riscv32-unknown-elf-gcc -march=rv32i -mabi=ilp32 -Wall -O2 -c -ffreestanding -nostdlib -ffixed-s10 -ffixed-s11 -I ./include -DCPU_SPEED=${F_CLK} -DLITTLE_ENDIAN $CFLAGS_STRIP -DDEBUG_PORT"

AS_riscv="riscv32-unknown-elf-as -march=rv32i -mabi=ilp32"
LD_riscv="riscv32-unknown-elf-ld -melf32lriscv $LDFLAGS_STRIP"
DUMP_riscv="riscv32-unknown-elf-objdump -Mno-aliases"
READ_riscv="riscv32-unknown-elf-readelf"
OBJ_riscv="riscv32-unknown-elf-objcopy"
SIZE_riscv="riscv32-unknown-elf-size"

#generate object code for app
#hahahahah
ASNAME="AS_${ARCH}"
${!ASNAME} -o test.o *.S

#lot of stuff
LDNAME="LD_${ARCH}"
${!LDNAME} -T$LIB_PATH/$ARCH/hf-risc.ld -Map test.map -N -o test.elf *.o

DUMPNAME="DUMP_${ARCH}"
${!DUMPNAME} --disassemble --reloc test.elf > test.lst
${!DUMPNAME} -h test.elf > test.sec
${!DUMPNAME} -s test.elf > test.cnt

OBJNAME="OBJ_${ARCH}" 
${!OBJNAME} -O binary test.elf test.bin

SIZENAME="SIZE_${ARCH}"
${!SIZENAME} test.elf

mv test.elf code.elf
mv test.bin code.bin
mv test.lst code.lst
mv test.sec code.sec
mv test.cnt code.cnt
mv test.map code.map
hexdump -v -e '4/1 "%02x" "\n"' code.bin > code.txt