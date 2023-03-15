/*
    Primitive words that are part of the core extension ANS-FORTH 2012 specification.
*/

/*
	Lots of comparison operations like =, <, >, etc..

	ANS FORTH says that the comparison words should return all (binary) 1's for
	TRUE and all 0's for FALSE.  However this is a bit of a strange convention
	so this FORTH breaks it and returns the more normal (for C programmers ...)
	1 meaning TRUE and 0 meaning FALSE.
*/

	/*
		( x -- flag )
		flag is true if and only if x is not equal to zero.
	*/
	defcode "0<>",3,,ZNEQU	// top of stack not 0?
	pop %rax
	test %rax,%rax
	setnz %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( n -- flag )
		flag is true if and only if n is greater than zero.
	*/
	defcode "0>",2,,ZGT
	pop %rax
	test %rax,%rax
	setg %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( x1 x2 -- flag )
		flag is true if and only if x1 is not bit-for-bit the same as x2.
	*/
	defcode "<>",2,,NEQU	// top two words are not equal?
	pop %rax
	pop %rbx
	cmp %rbx,%rax
	setne %al
	movzbq %al,%rax
	push %rax
	NEXT
