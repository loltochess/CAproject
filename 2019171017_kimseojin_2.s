
		AREA text, CODE
		ENTRY
		
start
	mov	r1, #0
    mov	r2, #0	 
	mov	r3, #0	 
	mov	r4, #0
	mov	r5, #0
    mov r6, #0
    mov r11, #0
    mov r10, #10
 
num1
    bl	scan
    CMP	r0, #32	
    beq	num2	
    sub	r0, r0, #'0'	
    mul	r11, r1, r10
    add	r1, r11, r0		
    bl	num1

num2
    bl	scan
	CMP	r0, #32		
	beq	num3	
	sub	r0, r0, #'0'	
	mul	r11, r2, r10
	add	r2, r11, r0		
	bl	num2

num3
    bl	scan
	CMP	r0, #32		
	beq	num4	
	sub	r0, r0, #'0'	
	mul	r11, r3, r10
	add	r3, r11, r0		
	bl	num3

num4
    bl scan
	CMP	r0, #32		
	beq	num5	
	sub	r0, r0, #'0'	
	mul	r11, r4, r10
	add	r4, r11, r0		
	bl	num4

num5
    bl	scan
	CMP	r0, #32		
	beq	array
	sub	r0, r0, #'0'	
	mul	r11, r5, r10
	add	r5, r11, r0		
	bl	num5

array
    ldr r6, =0x8000
    str r1, [r6] 
    str r2, [r6, #4] 
    str r3, [r6, #8]
    str r4, [r6, #12]
    str r5, [r6, #16]

parameter_set
    mov r10, #0 ; r10 is number of primes.
    mov r7, #0 ;start of r6
    mov r8, #16 ; end of r6

array_loop
    cmp r7, r8
    bgt print_prime
    ldr r0, [r6, r7]
    mov r2, r0 ;r2 is temporary value of r0
    mov r1, #2 ;divide from 2~ r0-1
    mov lr, pc
    mov r9, lr
    add r9, r9, #8
    bl isprime
    add r7, r7, #4
    bl array_loop

isprime
    cmp r0, r1
    blt zero_one
    cmp r0, r1
    beq correct
    sub r2, r2, r1
    cmp r2, r1
    blt increment_divider
    cmp r2, r1
    beq fail
    bl isprime
    
zero_one
    mov pc, r9

increment_divider
	stmfd	sp!, {lr}
    add r1, r1, #1
    mov r2, r0
    bl isprime
    ldmfd	sp!, {pc}

correct
    add r10, r10, #1
    mov pc, r9

fail
    mov pc, r9

print_prime
	add r10, r10, #'0'
    mov r0, r10
	bl print_char
    bl finish


scan
	stmfd	sp!, {lr}
	mov		r0, #7
	swi		0x123456
	ldmfd	sp!, {pc}
	
print_char
	stmfd	sp!, {r0-r1,lr}
	adr		r1, char
	strb	r0, [r1]
	mov		r0, #3
	swi		0x123456
	ldmfd	sp!, {r0-r1,pc}
	
char	DCB		0

finish
		;Standard exit code : SWI 0x123456, calling routine 0x18
		; with argument 0x20026
		mov		r0, #0x18
		mov		r1, #0x20000		;build the "difficult" number..
		add		r1, r1, #0x26		; in two steps
		SWI		0x123456			;; "software interrupt" = syscall
			
		END  

    
