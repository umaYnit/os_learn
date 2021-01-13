IMG=os.img
IPL=ipl.bin
 
all : ipl.s
	make ipl
	make img
	make run
 
os.img : $(IPL)
	mformat -f 1440 -C -B $(IPL) -i $(IMG) ::
 
ipl.bin : ipl.s ipl.ld
	gcc ipl.s -nostdlib -Tipl.ld -o $(IPL)
 
run : $(IMG)
	qemu -m 32 -localtime -vga std -fda $(IMG)
 
ipl :;  make ipl.bin
img :;  make os.img