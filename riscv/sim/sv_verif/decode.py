#!/usr/bin/env python3
import sys

opcode = {'0110111':'LUI',
    '0010111':'AUIPC',
    '1101111':'JAL',
    '1100111':'JALR',
    '1100011':'BRANCH',
    '0000011':'LOAD',
    '0100011':'STORE',
    '0010011':'OP_IMM',
    '0110011':'OP',
    '1110011':'SYSTEM'}

def reorderbits(hexa):
    parts = [hexa[6:8], hexa[4:6], hexa[2:4], hexa[0:2]]
    binary = ''.join([format(int(y,16), '#010b')[2:] for y in parts])
    return binary

def rd(bits):
    return int(bits[31-11:32-7],2)

def rs1(bits):
    return int(bits[31-19:32-15],2)

def rs2(bits):
    return int(bits[31-24:32-20],2)
def imm_11_0(bits):
    #print(20*bits[31]+bits[31-31:32-20])
    return int(20*bits[0]+bits[31-31:32-20],2)

def process(f):
    for line in f:
        line = line.strip()
        if line and line != '00000000':
            bits = reorderbits(line)
            if opcode[bits[25:32]] == 'LUI':
                print('LUI',rd(bits))
            if opcode[bits[25:32]] == 'AUIPC':
                print('AUIPC',)
            if opcode[bits[25:32]] == 'JAL':
                print('JAL',)
            if opcode[bits[25:32]] == 'JALR':
                print('JALR',)
            if opcode[bits[25:32]] == 'BRANCH':
                if bits[31-14:32-12] == '000':
                    print('BEQ',)
                if bits[31-14:32-12] == '001':
                    print('BNE',)
                if bits[31-14:32-12] == '100':
                    print('BLT',)
                if bits[31-14:32-12] == '101':
                    print('BGE',)
                if bits[31-14:32-12] == '110':
                    print('BLTU',)
                if bits[31-14:32-12] == '111':
                    print('BGEU',)
            if opcode[bits[25:32]] == 'LOAD':
                if bits[31-14:32-12] == '000':
                    print('LB',)
                if bits[31-14:32-12] == '001':
                    print('LH',)
                if bits[31-14:32-12] == '010':
                    print('LW',)
                if bits[31-14:32-12] == '100':
                    print('LBU',)
                if bits[31-14:32-12] == '101':
                    print('LHU',)
            if opcode[bits[25:32]] == 'STORE':
                if bits[31-14:32-12] == '000':
                    print('SB',)
                if bits[31-14:32-12] == '001':
                    print('SH',)
                if bits[31-14:32-12] == '010':
                    print('SW',)
            if opcode[bits[25:32]] == 'OP_IMM':
                if bits[31-14:32-12] == '000':
                    print('ADDI',rd(bits), rs1(bits), imm_11_0(bits))
                if bits[31-14:32-12] == '010':
                    print('SLTI',)
                if bits[31-14:32-12] == '011':
                    print('SLTIU',)
                if bits[31-14:32-12] == '100':
                    print('XORI',)
                if bits[31-14:32-12] == '110':
                    print('ORI',)
                if bits[31-14:32-12] == '111':
                    print('ANDI',)
                if bits[31-14:32-12] == '001':
                    print('SLLI',)
                if bits[31-14:32-12] == '101':
                    if bits[1] == '0':
                        print('SRLI',)
                if bits[31-14:32-12] == '101':
                    if bits[1] == '1':
                        print('SRAI',)
            if opcode[bits[25:32]] == 'OP':
                if bits[31-14:32-12] == '000':
                    if bits[1] == '0':
                        print('ADD',)
                if bits[31-14:32-12] == '000':
                    if bits[1] == '1':
                        print('SUB',)
                if bits[31-14:32-12] == '001':
                    print('SLL',)
                if bits[31-14:32-12] == '010':
                    print('SLT',)
                if bits[31-14:32-12] == '011':
                    print('SLTU',)
                if bits[31-14:32-12] == '100':
                    print('XOR',)
                if bits[31-14:32-12] == '101':
                    if bits[1] == '0':
                        print('SRL',)
                if bits[31-14:32-12] == '101':
                    if bits[1] == '1':
                        print('SRA',)
                if bits[31-14:32-12] == '110':
                    print('OR',)
                if bits[31-14:32-12] == '111':
                    print('AND',)
            if opcode[bits[25:32]] == 'SYSTEM':
                if bits[31-14:32-12] == '000':
                    if bits[31-20] == '0':
                        print('ECALL',)
                if bits[31-14:32-12] == '000':
                    if bits[31-20] == '1':
                        print('EBREAK',)

if len(sys.argv[1:]) < 1:
    process(sys.stdin)
else:
    with open(sys.argv[1:][0]) as f:
        process(f)
    