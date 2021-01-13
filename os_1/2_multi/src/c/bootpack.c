#include "func.h"

void Main() {
	char *p = (char *)0xa0000;
	int i;
	for( i = 0x0000; i < 0xffff; i++ ) {
		p[i] = 15;
	}
	
	while(1) { io_hlt(); }
}
