/*
    Non standard primitive words.
*/

	/*
		( x1 x2 x3 -- x3 x1 x2 )
		Rotate the top three stack entries.
	*/
	defcode "-ROT",4,,NROT
	pop %rax
	pop %rbx
	pop %rcx
	push %rax
	push %rcx
	push %rbx
	NEXT

	/*
		( x -- flag )
		flag is true if and only if x is less than or equal to zero.
	*/
	defcode "0<=",3,,ZLE
	pop %rax
	test %rax,%rax
	setle %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( x -- flag )
		flag is true if and only if x is greater than or equal to zero.
	*/
	defcode "0>=",3,,ZGE
	pop %rax
	test %rax,%rax
	setge %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( x -- x+8 )
		Add 8 to TOS.
	*/
	defcode "8+",2,,INCR8
	addq $8,(%rsp)
	NEXT

	/*
		( x -- x-8 )
		Subtract 8 from TOS.
	*/
	defcode "8-",2,,DECR8
	subq $8,(%rsp)
	NEXT

/*
	Lots of comparison operations like =, <, >, etc..

	ANS FORTH says that the comparison words should return all (binary) 1's for
	TRUE and all 0's for FALSE.  However this is a bit of a strange convention
	so this FORTH breaks it and returns the more normal (for C programmers ...)
	1 meaning TRUE and 0 meaning FALSE.
*/

	/*
		( n1 n2 -- flag )
		flag is true if and only if n1 is less than or equal than n2.
	*/
	defcode "<=",2,,LE
	pop %rax
	pop %rbx
	cmp %rax,%rbx
	setle %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( n1 n2 -- flag )
		flag is true if and only if n1 is greater than or equal than n2.
	*/
	defcode ">=",2,,GE
	pop %rax
	pop %rbx
	cmp %rax,%rbx
	setge %al
	movzbq %al,%rax
	push %rax
	NEXT
