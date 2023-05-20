
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
    CMP r0, #45
    beq negative
    CMP	r0, #32
    mov r7, r1
    beq go_negative
    CMP r7, #0
    blt change_reg1
    CMP r0, #32		
    beq	num2	
    sub	r0, r0, #'0'	
    mul	r11, r1, r10
    add	r1, r11, r0		
    bl	num1

num2
    bl	scan
    CMP r0, #45
    beq negative
    CMP	r0, #32
    mov r7, r2
    beq go_negative
    CMP r7, #0
    blt change_reg2
	CMP	r0, #32		
	beq	num3	
	sub	r0, r0, #'0'	
	mul	r11, r2, r10
	add	r2, r11, r0		
	bl	num2

num3
    bl	scan
    CMP r0, #45
    beq negative
    CMP	r0, #32
    mov r7, r3
    beq go_negative
    CMP r7, #0
    blt change_reg3
	CMP	r0, #32		
	beq	num4	
	sub	r0, r0, #'0'	
	mul	r11, r3, r10
	add	r3, r11, r0		
	bl	num3

num4
    bl	scan
    CMP r0, #45
    beq negative
    CMP	r0, #32
    mov r7, r4
    beq go_negative
    CMP r7, #0
    blt change_reg4
	CMP	r0, #32		
	beq	num5	
	sub	r0, r0, #'0'	
	mul	r11, r4, r10
	add	r4, r11, r0		
	bl	num4

num5
    bl	scan
    CMP r0, #45
    beq negative
    CMP	r0, #32
    mov r7, r5
    beq go_negative
    CMP r7, #0
    blt change_reg5
	CMP	r0, #32		
	beq	array
	sub	r0, r0, #'0'	
	mul	r11, r5, r10
	add	r5, r11, r0		
	bl	num5
	
	
negative
	adds lr, lr, #8
	stmfd sp!, {lr}
	mov r6, #1
	bl scan
	ldmfd sp!, {pc}
	
go_negative
	adds lr, lr, #8
	stmfd sp!, {lr}
	cmp r6, #1
	beq negg
	ldmfd sp!, {pc}
	
negg
	adds lr, lr, #8
	stmfd sp!, {lr}
	mvn r7, r7
	mov r0, r7
	mov r6, #0
	ldmfd sp!, {pc}
	
change_reg1
	adds lr, lr, #8
	stmfd sp!, {lr}
	mov r1, r7
	mov r0, #32
	ldmfd sp!, {pc}

change_reg2
	adds lr, lr, #8
	stmfd sp!, {lr}
	mov r2, r7
	mov r0, #32
	ldmfd sp!, {pc}

change_reg3
	adds lr, lr, #8
	stmfd sp!, {lr}
	mov r3, r7
	mov r0, #32
	ldmfd sp!, {pc}
	
change_reg4
	adds lr, lr, #8
	stmfd sp!, {lr}
	mov r4, r7
	mov r0, #32
	ldmfd sp!, {pc}
	
change_reg5
	adds lr, lr, #8
	stmfd sp!, {lr}
	mov r5, r7
	mov r0, #32
	ldmfd sp!, {pc}

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
	mov r11, #0 ;biggest negative index
	mov r9, #16 ;end
	mov r8, #0 ;start
	mov r7, #10 ;divider=10

find_biggest_negative
	ldr r0, [r6, r8]
	cmp r0, #0
	mov lr, pc
	blt gogo_negative
	add r8, r8, #4
	cmp r8, r9
	beq print_loop
	bl find_biggest_negative

gogo_negative
	stmfd sp!, {lr}
	mov r11, r8 ;store biggest negative index in r11
	add r11, r11, #1
	mvn r0, r0
	str r0, [r6, r8]
	ldmfd sp!, {pc}
	
print_loop
	cmp r1, #20
	beq finish
	ldr r0, [r6, r1]
	ldr r10, =0x9000
	mov r12, #0
	mov r3, #0 
	mov r4, #0 ;string index

divide_10
	cmp r0, #10
	blt store_num
	sub r0, r0, r7
	add r3, r3, #1
	bl divide_10

store_num
	mov r12, r3 ;<- r12=r3(temp)
	mov r3, r0 ; r3 <- r0(remainder)
	mov r0, r12 ; r0 <- r12=r3(quotient = new dividend)
	str r3, [r10, r4]
	cmp r0, #0
	beq print_number
	add r4, r4, #4
	bl divide_10

print_number
	cmp r1, r11 ; less than r11 -> negative!
	mov lr, pc
	blt print_negative
print_real
	cmp r4, #0 
	blt next
	ldr r0, [r10, r4]
	add r0, r0, #'0'
	bl print_char
	sub r4, r4, #4
	bl print_real

next
	add r1, r1, #4
	bl print_blank
	bl print_loop

print_blank
	stmfd sp!, {r0-r1, lr}
	adr r0, blank
	mov r1, r0
	mov r0, #4
	swi 0x123456
	ldmfd sp!, {r0-r1, pc}

print_negative
	stmfd sp!, {r0-r1, lr}
	adr r0, minus
	mov r1, r0
	mov r0, #4
	swi 0x123456
	ldmfd sp!, {r0-r1, pc}

minus
	DCD 45
	
blank
	DCD 32


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
