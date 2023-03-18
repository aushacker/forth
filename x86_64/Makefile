all : jonesforth run

jonesforth : jonesforth.S
	gcc -nostdlib -static -g -o jonesforth jonesforth.S

run :
	cat jonesforth.f - | ./jonesforth

clean :
	rm jonesforth
