/*
    Primitive words that are part of the core ANS-FORTH 2012 specification.
*/

	/*
		( n1 | u1 n2 | u2 -- n3 | u3 )
		Multiply n1 | u1 by n2 | u2 giving the product n3 | u3.
		[ans-forth 2012] maybe non standard
	*/
	defcode "*",1,,MUL
	pop %rax
	pop %rbx
	imul %rbx,%rax
	push %rax		// ignore overflow
	NEXT

	/*
		( n1 | u1 n2 | u2 -- n3 | u3 )
		Add n2 | u2 to n1 | u1, giving the sum n3 | u3.
		[ans-forth 2012] maybe non standard
	*/
	defcode "+",1,,ADD
	pop %rax		// get top of stack
	add %rax,(%rsp)		// and add it to next word on stack
	NEXT

	/*
		( n1 | u1 n2 | u2 -- n3 | u3 )
		Subtract n2 | u2 from n1 | u1, giving the difference n3 | u3.
		[ans-forth 2012] maybe non standard
	*/
	defcode "-",1,,SUB
	pop %rax		// get top of stack
	sub %rax,(%rsp)		// and subtract it from next word on stack
	NEXT

/*
	In this FORTH, only /MOD is primitive.  Later we will define the / and MOD words in
	terms of the primitive /MOD.  The design of the x86_64 assembly instruction idiv which
	leaves both quotient and remainder makes this the obvious choice.
*/

	/*
		( n1 n2 -- n3 n4 )
		Divide n1 by n2, giving the single-cell remainder n3 and the single-cell quotient n4.
		An ambiguous condition exists if n2 is zero. If n1 and n2 differ in sign,
		the implementation-defined result returned will be the same as that returned by
		either the phrase >R S>D R> FM/MOD or the phrase >R S>D R> SM/REM.
	*/
	defcode "/MOD",4,,DIVMOD
	xor %rdx,%rdx
	pop %rbx
	pop %rax
	idiv %rbx
	push %rdx		// push remainder
	push %rax		// push quotient
	NEXT

	/*
		( n -- flag )
		flag is true if and only if n is less than zero.
	*/
	defcode "0<",2,,ZLT
	pop %rax
	test %rax,%rax
	setl %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( x -- flag )
		flag is true if and only if x is equal to zero.
	*/
	defcode "0=",2,,ZEQU
	pop %rax
	test %rax,%rax
	setz %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( n1 | u1 -- n2 | u2 )
		Add one (1) to n1 | u1 giving the sum n2 | u2.
		[ans-forth 2012] maybe non-standard
	*/
	defcode "1+",2,,INCR
	incq (%rsp)
	NEXT

	/*
		( n1 | u1 -- n2 | u2 )
		Subtract one (1) from n1 | u1 giving the difference n2 | u2.
		[ans-forth 2012] maybe non-standard
	*/
	defcode "1-",2,,DECR
	decq (%rsp)
	NEXT

	/*
		( x1 x2 -- )
		Drop cell pair x1 x2 from the stack.
	*/
	defcode "2DROP",5,,TWODROP
	pop %rax
	pop %rax
	NEXT

	/*
		( x1 x2 -- x1 x2 x1 x2 )
		Duplicate cell pair x1 x2.
	*/
	defcode "2DUP",4,,TWODUP
	mov (%rsp),%rax
	mov 8(%rsp),%rbx
	push %rbx
	push %rax
	NEXT

	/*
		( x1 x2 x3 x4 -- x3 x4 x1 x2 )
		Exchange the top two cell pairs.
	*/
	defcode "2SWAP",5,,TWOSWAP
	pop %rax
	pop %rbx
	pop %rcx
	pop %rdx
	push %rbx
	push %rax
	push %rdx
	push %rcx
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
		flag is true if and only if n1 is less than n2.
	*/
	defcode "<",1,,LT
	pop %rax
	pop %rbx
	cmp %rax,%rbx
	setl %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( x1 x2 -- flag )
		flag is true if and only if x1 is bit-for-bit the same as x2.
	*/
	defcode "=",1,,EQU
	pop %rax
	pop %rbx
	cmp %rbx,%rax
	sete %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( n1 n2 -- flag )
		flag is true if and only if n1 is greater than n2.
	*/
	defcode ">",1,,GT
	pop %rax
	pop %rbx
	cmp %rax,%rbx
	setg %al
	movzbq %al,%rax
	push %rax
	NEXT

	/*
		( x -- 0 | x x )
		Duplicate x if it is non-zero.
	*/
	defcode "?DUP",4,,QDUP
	mov (%rsp),%rax
	test %rax,%rax
	jz 1f
	push %rax
1:	NEXT

	/*
		( x1 x2 -- x3 )
		x3 is the bit-by-bit logical "and" of x1 with x2.
	*/
	defcode "AND",3,,AND
	pop %rax
	and %rax,(%rsp)
	NEXT

	/*
		( x -- )
		Remove x from the stack
	*/
	defcode "DROP",4,,DROP
	pop %rax
	NEXT

	/*
		( x -- x x )
		Duplicate x.
	*/
	defcode "DUP",3,,DUP
	mov (%rsp),%rax
	push %rax
	NEXT

	/*
		( x1 -- x2 )
		Invert all bits of x1, giving its logical inverse x2.
	*/
	defcode "INVERT",6,,INVERT // this is the FORTH bitwise "NOT" function (cf. NEGATE and NOT)
	notq (%rsp)
	NEXT

	/*
                ( x1 x2 -- x3 )
                x3 is the bit-by-bit inclusive-or of x1 with x2.
	*/
	defcode "OR",2,,OR
	pop %rax
	or %rax,(%rsp)
	NEXT

	/*
		( x1 x2 -- x1 x2 x1 )
		Place a copy of x1 on top of the stack.
	*/
	defcode "OVER",4,,OVER
	mov 8(%rsp),%rax
	push %rax
	NEXT

	/*
		( x1 x2 x3 -- x2 x3 x1 )
		Rotate the top three stack entries.
	*/
	defcode "ROT",3,,ROT
	pop %rax
	pop %rbx
	pop %rcx
	push %rbx
	push %rax
	push %rcx
	NEXT

	/*
		( x1 x2 -- x2 x1 )
		Exchange the top two stack items.
	*/
	defcode "SWAP",4,,SWAP
	pop %rax
	pop %rbx
	push %rax
	push %rbx
	NEXT

	/*
                ( x1 x2 -- x3 )
                x3 is the bit-by-bit exclusive-or of x1 with x2.
	*/
	defcode "XOR",3,,XOR
	pop %rax
	xor %rax,(%rsp)
	NEXT
