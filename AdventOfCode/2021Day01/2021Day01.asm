; 2021Day01.asm
; Mason Lee

malloc PROTO
free PROTO
_printInt PROTO
_printString PROTO
_printNewLine PROTO ; Mostly for testing purposes
_getData PROTO

.DATA
LLNode STRUCT
	data QWORD ?
	nextNode QWORD 0
LLNode ENDS

depths LLNode <0, 0>
currentNode LLNode <0, 0>
numIncreases QWORD 0
depthsLength QWORD ?
loopCounter QWORD ?
lastNode QWORD ? ; This will be used as a pointer to the previous node (used in _deleteList)
tempData QWORD ?
outputMessage BYTE "Answer for part 1: ",0

.CODE

; Parameters: memory address of head node
; Returns: None
_printList PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Set current node values equal to values in the struct that was passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	cmp currentNode.nextNode, 0
	je finishPrintList

	; This section sets the current node data equal to the next node data
	nextNodeJmp:
	mov rsi, currentNode.nextNode
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; Print data at this index
	mov rcx, currentNode.data
	call _printInt

	; If the value of next node is 0 then there is no next node, so do not loop
	cmp currentNode.nextNode, 0
	jne nextNodeJmp

	finishPrintList:

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_printList ENDP


; Parameters: memory address of head node
; data to be stored at new node
; Returns: None
_addNode PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; move rdx into tempData
	mov tempData, rdx

	; Set current node values equal to values in the struct that was passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; Skips over going to the next node
	jmp skipNextNode

	; This section sets the current node data equal to the next node data
	nextNodeJmp:
	mov rsi, currentNode.nextNode
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	skipNextNode:

	; If the value of next node is 0 then there is no next node, so do not loop
	cmp currentNode.nextNode, 0
	jne nextNodeJmp

	; Add node to the end of the linked list
	mov rcx, 16
	call malloc
	mov [rsi + 8], rax

	; Move to the next node
	mov rsi, [rsi + 8]
	mov rax, tempData ; Get data to add to new node
	mov [rsi], rax
	mov rax, 0
	mov [rsi + 8], rax

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_addNode ENDP


; Parameters: memory address of head node
; index of value to return
; Returns: Value stored at index passed in
_getIndex PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	mov rax, rdx ; Start rax counter
	inc rax ; Incriment rax by 1 to account for the head node

	; Set current node values equal to values in head node passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	mov rcx, rax ; Move the counter to rcx
	; This section sets the current node data equal to the next node data
	nextNodeJmp:
		mov rsi, currentNode.nextNode
		mov rax, [rsi]
		mov currentNode.data, rax
		mov rax, [rsi + 8]
		mov currentNode.nextNode, rax

		loop nextNodeJmp

	mov rax, currentNode.data

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_getIndex ENDP


; Parameters: memory address of head node
; index of value to set
; data to set the value of the index to
; Returns: Value stored at index passed in
_setIndex PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	mov tempData, r8 ; Store data to be set in tempData for now

	mov rax, rdx ; Start rax counter
	inc rax ; Incriment rax by 1 to account for the head node

	; Set current node values equal to values in head node passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	mov rcx, rax ; Move the counter to rcx
	; This section sets the current node data equal to the next node data
	nextNodeJmp:
		mov rsi, currentNode.nextNode
		mov rax, [rsi]
		mov currentNode.data, rax
		mov rax, [rsi + 8]
		mov currentNode.nextNode, rax

		loop nextNodeJmp

	; Set data at correct index to data passed in
	mov rax, tempData
	mov [rsi], rax

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_setIndex ENDP


; Parameters: memory address of head node
; Returns: None
_deleteList PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Clear lastNode
	xor rax, rax
	mov lastNode, rax

	; Set current node values equal to values in the struct that was passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; Clear head node
	xor rax, rax
	mov [rsi], rax
	mov [rsi + 8], rax

	; This section sets the current node data equal to the next node data
	nextNodeJmp:
	mov rsi, currentNode.nextNode
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; Free the last node
	mov rcx, lastNode
	call free

	mov lastNode, rsi

	; If the value of next node is 0 then there is no next node, so do not loop
	cmp currentNode.nextNode, 0
	jne nextNodeJmp

	; Finally, free the last node
	mov rcx, lastNode
	call free

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_deleteList ENDP


_partOne PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Get data in the depths list
	lea rcx, depths
	call _getData
	mov depthsLength, rax
	
	; Loop through each index in depthsLength
	mov rcx, depthsLength
	dec rcx
	depthLoop:
		mov loopCounter, rcx ; Save loop counter
		
		; Get the current index
		mov rax, depthsLength
		sub rax, loopCounter ; rax now holds current index
		
		; Get value at current index
		lea rcx, depths
		mov rdx, rax
		dec rdx
		call _getIndex
		mov tempData, rax

		; Get the current index
		mov rax, depthsLength
		sub rax, loopCounter ; rax now holds current index
		
		; Get value at next index
		lea rcx, depths
		mov rdx, rax
		call _getIndex

		; Add one to number of increases unless current index is greater than next index
		cmp tempData, rax
		jg skipInc
			inc numIncreases
		skipInc:

		mov rcx, loopCounter ; Restore loop counter
		loop depthLoop

	; Output answer
	lea rcx, outputMessage
	call _printString
	mov rcx, numIncreases
	call _printInt
	call _printNewLine

	; Avoid memory leaks by deleting list
	lea rcx, depths
	call _deleteList

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_partOne ENDP
END