
		AREA text, CODE
		ENTRY
		
start
	mov	r1, #0
    mov r11, #0
    mov r10, #10

num1
    bl	scan
    cmp	r0, #32	
    beq	parameter_set	
    sub	r0, r0, #'0'	
    mul	r11, r1, r10
    add	r1, r11, r0		
    bl	num1

parameter_set
    ldr r10, =0x8000 ; counting array
    mov r5, #0 ;clear array with 0
    
    mov r2, #0 ; array index

    mov r3, #0 ; quotient (r1 is remainder)
    mov r7, #10 ; divider=10
    
    mov r11, #0 ; find_maximum index
    mov r8, #0 ; maximum except 6,9
    mov r9, #0 ; maximum in 6,9
    
    mov r12, #0 ; answer
    mov r6, #4 ; multiply 4

    

array_clear
    cmp r2, #40
    beq divide_10
    str r5, [r10, r2]
    add r2, r2, #4
    bl array_clear
    

divide_10
	cmp r1, #10
	blt write_num
	sub r1, r1, r7
	add r3, r3, #1 ;quotient++
	bl divide_10

write_num
	mov r12, r3 ;<- r12=r3(temp)
	mov r3, r1 ; r3 <- r1(remainder)
	mov r1, r12 ; r1 <- r12=r3(quotient = new dividend)
    mov r8, r3 ; r8 <- r3
    mul r12, r8, r6
    ldr r9, [r10, r12] ;r9 <-array[r3]
    add r9, r9, #1 ; r9++
	str r9, [r10, r12] ; array[r3] <- r9
	mov r3, #0
	cmp r1, #0
	beq gogo
	bl divide_10

gogo
    mov r8, #0
    mov r9, #0

find_maximum
    cmp r11, #40
    beq decision_number
    cmp r11, #24
    beq six_nine
    cmp r11, #36
    beq six_nine
    ldr r0, [r10, r11]
    cmp r0, r8
    bgt new_r8
    add r11, r11, #4
    bl find_maximum

new_r8
    mov r8, r0
    add r11, r11, #4
    bl find_maximum
    

six_nine
    ldr r0, [r10, r11]
    add r9, r9, r0
    add r11, r11, #4
    bl find_maximum

decision_number
    mov r3, #0 ;quotient
    mov r4, #0 ;remainder
    mov r11, pc
    bl divide_2
    add r9, r3, r4
    cmp r8, r9
    mov r11, pc
    bgt left
    ble right
    bl print_num

divide_2 ; number(6)+number(9)/2 +remainder
    cmp r9, #2
    blt end_division
    sub r9, r9, #2
    add r3, r3, #1
    bl divide_2

end_division
    mov r4, r9
    mov pc, r11
    

left 
    mov r10, r8
    mov pc, r11

right
    mov r10, r9
    add r11, r11, #4
    mov pc, r11


print_num
    mov r4, #10 ; maximum answer=10 (11/1111/1111) or (00/0000/0000)
    cmp r4, r10 ; if 10
    beq print10
	add r10, r10, #'0'
    mov r0, r10
	bl print_char
    bl finish

print10
    mov r0, #1
    bl print_char
    mov r0, #0
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

    
