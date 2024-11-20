; code.asm
; Mason Lee

_getDouble PROTO
_printString PROTO
_printDouble PROTO

.DATA
depths WORD	199, 200, 208, 210, 200, 207, 240, 269, 260, 263
lenDepths WORD 10

.CODE

asmMain PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	lea rsi, depths
	movsx rcx, lenDepths
	dec rcx
	lea rsi, depths
	mov rdi, 0

	xor rax, rax

	depthLoop:
		; Get number at current index and next number
		mov	bx, WORD PTR [rsi + rdi * 2]
		mov	dx, WORD PTR [rsi + rdi * 2 + 2]

		; if next value is smaller jump over inc rax
		cmp bx, dx
		ja decrease

			inc rax

		decrease:

		inc rdi
		loop depthLoop

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack (so ret knows where to go back to)
	ret ; return back to cpp main

asmMain ENDP
END