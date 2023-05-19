
		AREA text, CODE
		ENTRY
		
start
	mov	r1, #0
    mov	r2, #0	 
	mov	r3, #0	 
	mov	r4, #0
	mov	r5, #0
    mov r14, #0
    mov r13, #10

num1
    bl	scan
    CMP	r0, #32		
    beq	num2	
    sub	r0, r0, #'0'	
    mul	r14, r1, r13
    add	r1, r14, r0		
    bl	num1

num2
	bl	scan
	CMP	r0, #32		
	beq	num3	
	sub	r0, r0, #'0'	
	mul	r14, r2, r13
	add	r2, r14, r0		
	bl	num2

num3
	bl	scan
	CMP	r0, #32		
	beq	num4	
	sub	r0, r0, #'0'	
	mul	r14, r3, r13
	add	r3, r14, r0		
	bl	num3

num4
	bl	scan
	CMP	r0, #32		
	beq	num5	
	sub	r0, r0, #'0'	
	mul	r14, r4, r13
	add	r4, r14, r0		
	bl	num4

num5
	bl	scan
	CMP	r0, #32		
	beq	array
	sub	r0, r0, #'0'	
	mul	r14, r5, r13
	add	r5, r14, r0		
	bl	num5

array
    ldr r6, =0x8000
    str r1, [r6] 
    str r2, [r6, #4] 
    str r3, [r6, #8]
    str r4, [r6, #12]
    str r5, [r6, #16]

index_set
    mov r0, #0 
    add r1, r0, #16
    mov r7, r0
    add r8, r7, #4

sort
    cmp r0, r1
    beq end

    mov lr, pc
    ldr r9, [r6, r7]
    ldr r10, [r6, r8]
    
    cmp r7, r1
    beq end_loop
    cmp r9, r10
    bgt swap

    add r7, r7, #4
    add r8, r8, #4
    bl sort

end_loop
    sub r1, r1, #4
    mov r7, r0
    add r8, r7, #4
    bl sort

swap
    str r10, [r6, r7]
    str r9, [r6, r8]

    add r7, r7, #4
    add r8, r8, #4
    mov pc, lr
    
end
    mov r1, #0
    mov r2, #16

print_num
    cmp r1, r2
    bgt finish
    ldr r0, [r6, r1]
    stmfd sp!, {r0-r2}
    mov r10, #0 // number of push
    mov lr, pc+4
    bl print_loop
    ldmfd sp!, {r0-r2}
    add r1, r1, #4
    bl print_num
	
print_loop
	mov	r1, #10
    udiv r2, r0, r1 // r2 is Q
    mul r4, r2, r1 // r4 is B*Q
    sub r3, r0, r4 // r3 is R = A-BQ
    mov r0, r2
    mul r12, r0, #10
    add r12, r12, r3
    cmp r12, #10
    beq print1 // if r12==10 -> exception (first number 0)
    add r10, r10, #1
    push {r3}
    cmp r2, #0
    beq print1
    bl print_loop

print1
    sub r10, r10, #1
    pop {r0}

    cmp r10, #0
    beq print_blank
    cmp r10, #0
    beq lr
    
    bl print_char
    bl print1
    
print_blank
	stmfd	sp!, {r0-r1,lr}
    mov     r0, #' '
	adr		r1, char
	strb	r0, [r1]
	mov		r0, #3
	swi		0x123456
	ldmfd	sp!, {r0-r1,pc}    
    
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
		
