/* file:          hf_riscv_sim.c
 * description:   HF-RISCV simulator
 * date:          11/2015
 * author:        Sergio Johann Filho <sergio.filho@pucrs.br>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define MEM_SIZE			0x00100000
#define SRAM_BASE			0x40000000
#define EXIT_TRAP			0xe0000000
#define IRQ_VECTOR			0xf0000000
#define IRQ_CAUSE			0xf0000010
#define IRQ_MASK			0xf0000020
#define IRQ_STATUS			0xf0000030
#define IRQ_EPC				0xf0000040
#define COUNTER				0xf0000050
#define COMPARE				0xf0000060
#define COMPARE2			0xf0000070
#define EXTIO_IN			0xf0000080
#define EXTIO_OUT			0xf0000090
#define DEBUG_ADDR			0xf00000d0
#define UART_WRITE			0xf00000e0
#define UART_READ			0xf00000e0
#define UART_DIVISOR			0xf00000f0

#define ntohs(A) ( ((A)>>8) | (((A)&0xff)<<8) )
#define htons(A) ntohs(A)
#define ntohl(A) ( ((A)>>24) | (((A)&0xff0000)>>8) | (((A)&0xff00)<<8) | ((A)<<24) )
#define htonl(A) ntohl(A)

#define min(A, B) ((A) < (B) ? (A) : (B))
#define max(A, B) ((A) > (B) ? (A) : (B))

int8_t sram[MEM_SIZE];

typedef struct {
	int32_t r[32];
	uint32_t pc, pc_next;
	int8_t *mem;
	uint32_t vector, cause, mask, status, status_dly[4], epc, counter, compare, compare2;
	uint64_t cycles;
} state;

state context;

// Interface with simulator
extern void terminate(int errcode);
extern void log_branch(uint32_t pc);
extern void log_reg(uint8_t reg, uint32_t content);
extern void log_mwrite32(uint32_t addr, uint32_t content);
extern void log_mwrite16(uint32_t addr, uint16_t content);
extern void log_mwrite8(uint32_t addr, uint8_t content);
extern void log_uart(uint8_t c);

void dump_sram(uint32_t *dst, int size) {
  memcpy(dst, context.mem, min(size, MEM_SIZE));
}

void dumpregs(){
	int32_t i;
  state *s = &context;
	
	for (i = 0; i < 32; i+=4){
		printf("\nr%02d [%08x] r%02d [%08x] r%02d [%08x] r%02d [%08x]", \
		i, s->r[i], i+1, s->r[i+1], i+2, s->r[i+2], i+3, s->r[i+3]);
	}
	printf("\n");
}

void bp(uint32_t ir){
  state *s = &context;
	printf("\npc: %08x, ir: %08x", s->pc, ir);
	dumpregs();
}

void set_io(int pin, int val) {
  pin &= 0x7;
  
  if (val) {
    context.cause |= 1 << (pin + 16);
    context.cause &= ~(1 << (pin + 24));
  } else {
    context.cause &= ~(1 << (pin + 16));
    context.cause |= 1 << (pin + 24);
  }
}

static int32_t mem_fetch(uint32_t address){
	uint32_t value=0;
	uint32_t *ptr;

  state *s = &context;

	ptr = (uint32_t *)(s->mem + (address % MEM_SIZE));
	value = *ptr;

	return(value);
}

static int32_t mem_read(int32_t size, uint32_t address){
	uint32_t value=0;
	uint32_t *ptr;

  state *s = &context;

	switch(address){
		case IRQ_VECTOR:	return s->vector;
		case IRQ_CAUSE:		return s->cause | 0x0080 | 0x0040;
		case IRQ_MASK:		return s->mask;
		case IRQ_STATUS:	return s->status;
		case IRQ_EPC:		return s->epc;
		case COUNTER:		return s->counter;
		case COMPARE:		return s->compare;
		case COMPARE2:		return s->compare2;
  case UART_READ:		return getchar(); // TODO UART_IN
		case UART_DIVISOR:	return 0;
	}

	ptr = (uint32_t *)(s->mem + (address % MEM_SIZE));

	switch(size){
		case 4:
			if(address & 3){
				printf("\nunaligned access (load word) pc=0x%x addr=0x%x", s->pc, address);
				dumpregs();
				terminate(1);
			}else{
				value = *(int32_t *)ptr;
			}
			break;
		case 2:
			if(address & 1){
				printf("\nunaligned access (load halfword) pc=0x%x addr=0x%x", s->pc, address);
				dumpregs();
				terminate(1);
			}else{
				value = *(int16_t *)ptr;
			}
			break;
		case 1:
			value = *(int8_t *)ptr;
			break;
		default:
			printf("\nerror");
	}

	return(value);
}

static void mem_write(int32_t size, uint32_t address, uint32_t value){
	uint32_t i;
	void *ptr;

  state *s = &context;

	switch(address){
		case IRQ_VECTOR:	s->vector = value; return;
		case IRQ_CAUSE:		s->cause = value; return;
		case IRQ_MASK:		s->mask = value; return;
		case IRQ_STATUS:	if (value == 0){ s->status = 0; for (i = 0; i < 4; i++) s->status_dly[i] = 0; }else{ s->status_dly[3] = value; } return;
		case IRQ_EPC:		s->epc = value; return;
		case COUNTER:		s->counter = value; return;
		case COMPARE:		s->compare = value; s->cause &= 0xffef; return;
		case COMPARE2:		s->compare2 = value; s->cause &= 0xffdf; return;
		case EXIT_TRAP:
			fflush(stdout);
			printf("\nend of simulation - %ld cycles.\n", s->cycles);
			terminate(0);
		case DEBUG_ADDR:
		case UART_WRITE:
			log_uart((uint8_t)(value & 0xef));
			return;
		case UART_DIVISOR:
			return;
	}

  address %= MEM_SIZE;

	ptr = s->mem + address;
	
	switch(size){
		case 4:
			if(address & 3){
				printf("\nunaligned access (store word) pc=0x%x addr=0x%x", s->pc, address);
				dumpregs();
				terminate(1);
			}else{
				*(int32_t *)ptr = value;
        log_mwrite32(address, value);
			}
			break;
		case 2:
			if(address & 1){
				printf("\nunaligned access (store halfword) pc=0x%x addr=0x%x", s->pc, address);
				dumpregs();
				terminate(1);
			}else{
				*(int16_t *)ptr = (uint16_t)value;
        log_mwrite16(address, (uint16_t)value);
			}
			break;
		case 1:
			*(int8_t *)ptr = (uint8_t)value;
      log_mwrite8(address, (uint8_t)value);
			break;
		default:
			printf("\nerror");
	}
}

void cycle(){
	uint32_t inst, i;
	uint32_t opcode, rd, rs1, rs2, funct3, funct7, imm_i, imm_s, imm_sb, imm_u, imm_uj;
  uint32_t prev_rd;

  state *s = &context;
  
	int32_t *r = s->r;
	uint32_t *u = (uint32_t *)s->r;
	uint32_t ptr_l, ptr_s;
	
	if (s->status && (s->cause & s->mask)){
		s->epc = s->pc_next;
		s->pc = s->vector;
		s->pc_next = s->vector + 4;
		s->status = 0;
		for (i = 0; i < 4; i++)
			s->status_dly[i] = 0;
	}

	inst = mem_fetch(s->pc);

	opcode = inst & 0x7f;
	rd = (inst >> 7) & 0x1f;
	rs1 = (inst >> 15) & 0x1f;
	rs2 = (inst >> 20) & 0x1f;
	funct3 = (inst >> 12) & 0x7;
	funct7 = (inst >> 25) & 0x7f;
	imm_i = (inst & 0xfff00000) >> 20;
	imm_s = ((inst & 0xf80) >> 7) | ((inst & 0xfe000000) >> 20);
	imm_sb = ((inst & 0xf00) >> 7) | ((inst & 0x7e000000) >> 20) | ((inst & 0x80) << 4) | ((inst & 0x80000000) >> 19);
	imm_u = inst & 0xfffff000;
	imm_uj = ((inst & 0x7fe00000) >> 20) | ((inst & 0x100000) >> 9) | (inst & 0xff000) | ((inst & 0x80000000) >> 11); 
	if (inst & 0x80000000){
		imm_i |= 0xfffff000;
		imm_s |= 0xfffff000;
		imm_sb |= 0xffffe000;
		imm_uj |= 0xffe00000;
	}
	ptr_l = r[rs1] + (int32_t)imm_i;
	ptr_s = r[rs1] + (int32_t)imm_s;
	r[0] = 0;

  prev_rd = r[rd];

	switch(opcode){
		case 0x37: r[rd] = imm_u; break;										/* LUI */
		case 0x17: r[rd] = s->pc + imm_u; break;									/* AUIPC */
		case 0x6f: r[rd] = s->pc_next; s->pc_next = s->pc + imm_uj; break;						/* JAL */
		case 0x67: r[rd] = s->pc_next; s->pc_next = (r[rs1] + imm_i) & 0xfffffffe; break;				/* JALR */
		case 0x63:
			switch(funct3){
				case 0x0: if (r[rs1] == r[rs2]){ s->pc_next = s->pc + imm_sb; } break;				/* BEQ */
				case 0x1: if (r[rs1] != r[rs2]){ s->pc_next = s->pc + imm_sb; } break;				/* BNE */
				case 0x4: if (r[rs1] < r[rs2]){ s->pc_next = s->pc + imm_sb; } break;				/* BLT */
				case 0x5: if (r[rs1] >= r[rs2]){ s->pc_next = s->pc + imm_sb; } break;				/* BGE */
				case 0x6: if (u[rs1] < u[rs2]){ s->pc_next = s->pc + imm_sb; } break;				/* BLTU */
				case 0x7: if (u[rs1] >= u[rs2]){ s->pc_next = s->pc + imm_sb; } break;				/* BGEU */
				default: goto fail;
			}
			break;
		case 0x3:
			switch(funct3){
				case 0x0: r[rd] = (int8_t)mem_read(1,ptr_l); break;						/* LB */
				case 0x1: r[rd] = (int16_t)mem_read(2,ptr_l); break;						/* LH */
				case 0x2: r[rd] = mem_read(4,ptr_l); break;							/* LW */
				case 0x4: r[rd] = (uint8_t)mem_read(1,ptr_l); break;						/* LBU */
				case 0x5: r[rd] = (uint16_t)mem_read(2,ptr_l); break;						/* LHU */
				default: goto fail;
			}
			break;
		case 0x23:
			switch(funct3){
				case 0x0: mem_write(1,ptr_s,r[rs2]); break;							/* SB */
				case 0x1: mem_write(2,ptr_s,r[rs2]); break;							/* SH */
				case 0x2: mem_write(4,ptr_s,r[rs2]); break;							/* SW */
				default: goto fail;
			}
			break;
		case 0x13:
			switch(funct3){
				case 0x0: r[rd] = r[rs1] + (int32_t)imm_i; break;						/* ADDI */
				case 0x2: r[rd] = r[rs1] < (int32_t)imm_i; break;		 				/* SLTI */
				case 0x3: r[rd] = u[rs1] < (uint32_t)imm_i; break;						/* SLTIU */
				case 0x4: r[rd] = r[rs1] ^ (int32_t)imm_i; break;						/* XORI */
				case 0x6: r[rd] = r[rs1] | (int32_t)imm_i; break;						/* ORI */
				case 0x7: r[rd] = r[rs1] & (int32_t)imm_i; break;						/* ANDI */
				case 0x1: r[rd] = u[rs1] << (rs2 & 0x3f); break;						/* SLLI */
				case 0x5:
					switch(funct7){
						case 0x0: r[rd] = u[rs1] >> (rs2 & 0x3f); break;				/* SRLI */
						case 0x20: r[rd] = r[rs1] >> (rs2 & 0x3f); break;				/* SRAI */
						default: goto fail;
					}
					break;
				default: goto fail;
			}
			break;
		case 0x33:
			switch(funct3){
				case 0x0:
					switch(funct7){
						case 0x0: r[rd] = r[rs1] + r[rs2]; break;					/* ADD */
						case 0x20: r[rd] = r[rs1] - r[rs2]; break;					/* SUB */
						default: goto fail;
					}
					break;
				case 0x1: r[rd] = r[rs1] << r[rs2]; break;							/* SLL */
				case 0x2: r[rd] = r[rs1] < r[rs2]; break;		 					/* SLT */
				case 0x3: r[rd] = u[rs1] < u[rs2]; break;		 					/* SLTU */
				case 0x4: r[rd] = r[rs1] ^ r[rs2]; break;							/* XOR */
				case 0x5:
					switch(funct7){
						case 0x0: r[rd] = u[rs1] >> u[rs2]; break;					/* SRL */
						case 0x20: r[rd] = r[rs1] >> r[rs2]; break;					/* SRA */
						default: goto fail;
					}
					break;
				case 0x6: r[rd] = r[rs1] | r[rs2]; break;							/* OR */
				case 0x7: r[rd] = r[rs1] & r[rs2]; break;							/* AND */
				default: goto fail;
			}
			break;
		default: goto fail;
	}

  if(r[rd] != prev_rd)
    log_reg(rd, r[rd]);

  if (s->pc_next != s->pc + 4)
    log_branch(s->pc_next);
	
	s->pc = s->pc_next;
	s->pc_next = s->pc_next + 4;
	s->status = s->status_dly[0];
	for (i = 0; i < 3; i++)
		s->status_dly[i] = s->status_dly[i+1];
	
	s->cycles++;
	s->counter++;
	if ((s->compare2 & 0xffffff) == (s->counter & 0xffffff)) s->cause |= 0x20;		/*IRQ_COMPARE2*/
	if (s->compare == s->counter) s->cause |= 0x10;						/*IRQ_COMPARE*/
	if (!(s->counter & 0x10000)) s->cause |= 0x8; else s->cause &= 0xfff7;			/*IRQ_COUNTER2_NOT*/
	if (s->counter & 0x10000) s->cause |= 0x4; else s->cause &= 0xfffb;			/*IRQ_COUNTER2*/
	if (!(s->counter & 0x40000)) s->cause |= 0x2; else s->cause &= 0xfffd;			/*IRQ_COUNTER_NOT*/
	if (s->counter & 0x40000) s->cause |= 0x1; else s->cause &= 0xfffe;			/*IRQ_COUNTER*/
	
	return;
fail:
	printf("\ninvalid opcode (pc=0x%x opcode=0x%x)", s->pc, inst);
	terminate(1);
}

uint32_t setup (uint32_t *src, uint32_t size){
	state *s;
  int i;

  size = min(size, MEM_SIZE);

	s = &context;
	memset(s, 0, sizeof(state));
	bzero(sram, MEM_SIZE);

	s->pc = SRAM_BASE;
	s->pc_next = s->pc + 4;
	s->mem = &sram[0];
	s->vector = 0;
	s->cause = 0xFF000000;
	s->mask = 0;
	s->status = 0;
	for (i = 0; i < 4; i++)
		s->status_dly[i] = 0;
	s->epc = 0;
	s->counter = 0;
	s->compare = 0;
	s->compare2 = 0;
	s->cycles = 0;

  memcpy(sram, src, size);

  return size;
}

