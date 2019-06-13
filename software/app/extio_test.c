#include <hf-risc.h>

volatile int32_t io_count=0, extio_in=0;


void porta_handler(void)
{
	printf("PAIN: %04x\n", PAIN);
	uint32_t m=0;

	io_count++;
	//extio_in = EXTIO_IN;							// read extio_in value 
	extio_in = PAIN;
	//m = (~extio_in)<<16;							// toggle interrupt mask
	//m ^= (~extio_in)<<24;							// toggle interrupt mask
	//IRQ_MASK = m;
}

void timer0a_handler(void)
{
	printf("TIMER0A\n");
}


/*
void extio_handler(void){
	uint32_t m=0;

	io_count++;
	extio_in = EXTIO_IN;							// read extio_in value 
	m = (~extio_in)<<16;							// toggle interrupt mask
	m ^= (~extio_in)<<24;							// toggle interrupt mask
	IRQ_MASK = m;									// write to irq mask register
}
*/

void swap(int v[], int i, int j){
	int temp;

	temp = v[i];
	v[i] = v[j];
	v[j] = temp;
}

void qsort(int v[], int left, int right){
	int i, last;

	if (left >= right)
		return;
	swap(v, left, (left + right) >> 1);
	last = left;
	for (i = left + 1; i <= right; i++)
		if (v[i] < v[left])
			swap(v, ++last, i);
	swap(v, left, last);
	qsort(v, left, last-1);
	qsort(v, last+1, right);
}

int main(void){
	int i, num_io;
/*
	// register ISRs
	interrupt_register(EXT_IRQ0, extio_handler);
	interrupt_register(EXT_IRQ1, extio_handler);
	interrupt_register(EXT_IRQ2, extio_handler);
	interrupt_register(EXT_IRQ3, extio_handler);
	interrupt_register(EXT_IRQ4, extio_handler);
	interrupt_register(EXT_IRQ5, extio_handler);
	interrupt_register(EXT_IRQ6, extio_handler);
	interrupt_register(EXT_IRQ7, extio_handler);
	interrupt_register(EXT_IRQ0_NOT, extio_handler);
	interrupt_register(EXT_IRQ1_NOT, extio_handler);
	interrupt_register(EXT_IRQ2_NOT, extio_handler);
	interrupt_register(EXT_IRQ3_NOT, extio_handler);
	interrupt_register(EXT_IRQ4_NOT, extio_handler);
	interrupt_register(EXT_IRQ5_NOT, extio_handler);
	interrupt_register(EXT_IRQ6_NOT, extio_handler);
	interrupt_register(EXT_IRQ7_NOT, extio_handler);
*/

	GPIOMASK |= MASK_PAIN;
	GPIOMASK |= MASK_TIMER0A;
	/* enable PORTA input pin 3 mask */
	//PAINMASK |= (MASK_P0 | MASK_P1 | MASK_P2 | MASK_P3 | MASK_P4 | MASK_P5 | MASK_P6 | MASK_P7);
	PAINMASK |= MASK_P0;
	
	// set interrupt mask (unmask peripheral interrupts)
	//IRQ_MASK = (EXT_IRQ0 | EXT_IRQ1 | EXT_IRQ2 | EXT_IRQ3 | EXT_IRQ4 | EXT_IRQ5 | EXT_IRQ6 | EXT_IRQ7);

	// global interrupts enable
	//IRQ_STATUS = 1;

	io_count=0;
	while (io_count == 0){ }
	num_io = extio_in;

	int v[num_io];
	printf("io_num = %d\n", num_io);
	
	io_count=0;
	i = 0;
	printf("\n\nreceived values: ");
	while (i < num_io){
		io_count=0;
		while (io_count == 0){ }
		printf("%d ", extio_in);
		v[i] = extio_in;
		i++;
	}

	qsort(v, 0, num_io-1);

	printf("\n\nsorted elements: ");
	for(i=0; i<num_io; i++){
		//printf("%d ", v[i]);
		//EXTIO_OUT = v[i];
		printf("%d ",v[i]);

	}

}