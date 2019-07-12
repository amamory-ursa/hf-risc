`ifndef __RANDOM_PROGRAM_SV
`define __RANDOM_PROGRAM_SV
`include "random_instruction.sv"

//this class provides methods for the generation
//of random programs for the RV32I riscv ISA. 
class random_program;
 
  //length of generate program
  int progr_length = 0;
  //this queue stores all generated instructions
  random_instruction instr_queue[$] = {};

  //instruction type is randomized for every new instruction
  random_instruction last;
  rand random_instruction instr;
 

  //ctor.
  function new( int     length,
                itype   instr_type_constraint   = itype'(NULL_TYPE), 
                opcode  instr_opcode_constraint = opcode'(NULL_OPCODE));
    
    this.progr_length = length;

    //generate random instructions until reach the length
    for(int i = 0; i < this.progr_length; i++) begin     
      
      //must use new here! otherwise the initial instance will
      //be randomized several times and the queue will be filled
      //with the same value for all positions.
      instr = new();
      last = instr;

      if((instr_type_constraint != itype'(NULL_TYPE)) && (instr_opcode_constraint != opcode'(NULL_OPCODE)))begin
        if(instr.randomize() with{
        it      == instr_type_constraint;
        opcode  == instr_opcode_constraint;
        }) begin
            instr_queue.push_back(instr);
        end
        else begin
            i--;
        end
      end else if(instr_type_constraint != itype'(NULL_TYPE))begin
        if(instr.randomize() with{
        it      == instr_type_constraint;
        }) begin
            instr_queue.push_back(instr);
        end
        else begin
            i--;
        end
      end else if (instr_opcode_constraint != opcode'(NULL_OPCODE)) begin
        if(instr.randomize() with{
        opcode  == instr_opcode_constraint;
        }) begin
            instr_queue.push_back(instr);
        end
        else begin
            i--;
        end
      end else begin
        if(instr.randomize()) begin
            instr_queue.push_back(instr);
        end
        else begin
            i--;
        end
      end

      
    end

  endfunction
 
  //display program's instructions on screen
  function string toString();

    string s = "";

    //display code's head
    s = {
      "  .text                 \n",
      "  .align 2              \n",
      "  .global _entry        \n",
      "_entry:                 \n",
      "  la a3, _bss_start     \n",
      "  la a2, _end           \n",
      "  la gp, _gp            \n",
      "  la sp, _stack         \n",
      "  la tp, _end + 63      \n",
      "  and tp, tp, -64       \n",
      "                        \n",
      "BSS_CLEAR:              \n",
      "  sw zero, 0(a3)        \n",
      "  addi a3, a3, 4        \n",
      "  blt a3, a2, BSS_CLEAR \n",
      "  la  s11, _isr         \n",
      "  li  s10, 0xf0000000   \n",
      "  sw  s11, 0(s10)       \n",
      "                        \n",
      "PROGRAM:                \n"};

    //generate random code to the program
    for(int i = 0; i < this.progr_length; i++) begin
        s = {s, this.instr_queue[i].toString()};
    end

    //display code's tail
    s = {s, 
      "                      \n",
      "END:                  \n",
      "  li s10, 0xe0000000  \n",
      "  sw zero, 0(s10)     \n",
      "                      \n",
      "L1:                   \n",
      "  beq zero, zero, L1  \n",
      "                      \n",
      "_isr:                 \n",
      "  nop                 \n"};

    return s;

  endfunction  

endclass


`endif //__RANDOM_PROGRAM
