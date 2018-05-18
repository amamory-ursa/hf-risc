	.text
	.align 2

	.global _entry
_entry:
	la	a3, _bss_start
	la	a2, _end
	la	gp, _gp
	la	sp, _stack
	la	tp, _end + 63
	and	tp, tp, -64

BSS_CLEAR:
	# clear the .bss
	sw	zero, 0(a3)
	addi	a3, a3, 4
	blt	a3, a2, BSS_CLEAR

	# configure IRQ_VECTOR
	la	s11, _isr
	li	s10, 0xf0000000
	sw	s11, 0(s10)
	
	li	s10, 0xf00000d0
	li	s0, 65
	sw	s0, 0(s10)
	li	s0, 0xa
	sw	s0, 0(s10)
	

	li	s10, 0xe0000000		# this will interrupt the simulation (assertion)
	sw	zero, 0(s10)

L1:
	beq	zero, zero, L1

_isr:
	nop
