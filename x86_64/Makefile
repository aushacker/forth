all : jonesforth run

forth : jonesforth.S
	gcc -nostdlib -static -g -o jonesforth jonesforth.S

run :
	cat jonesforth.f - | ./jonesforth

clean :
	rm *.o
