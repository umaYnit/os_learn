IMG=os.img
IPL=ipl.bin
 
all : ipl.s
	make img
	make run
 
img : $(IPL)
	gcc -nostdlib -o os.img temp.s -Tlnk.ls
	
run : $(IMG)
	qemu -m 32 -localtime -vga std -fda $(IMG)