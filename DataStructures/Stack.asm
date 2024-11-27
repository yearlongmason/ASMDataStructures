; Stack.asm
; Mason Lee

malloc PROTO
free PROTO
_printInt PROTO
_printNewLine PROTO ; Mostly for testing purposes

.DATA
StackNode STRUCT
	data QWORD ?
	nextNode QWORD 0
StackNode ENDS

head StackNode <0, 0>
currentNode StackNode <0, 0>
lastNode QWORD ? ; This will be used as a pointer to the previous node (used in _deleteStack, and _popStack)
tempData QWORD ?

.CODE


; Parameters: memory address of head node
; Returns: None
_printStack PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Set current node values equal to values in the struct that was passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; If the stack is empty just finish
	cmp currentNode.nextNode, 0
	je finishPrintList

	; This section sets the current node data equal to the next node data
	nextNodeJmp:
	mov rsi, currentNode.nextNode
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; Print data at current index
	mov rcx, currentNode.data
	call _printInt

	; If the value of next node is 0 then there is no next node, so do not loop
	cmp currentNode.nextNode, 0
	jne nextNodeJmp

	finishPrintList:

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_printStack ENDP


; Parameters: memory address of head node
; data to be stored at new node
; Returns: None
_pushStack PROC
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

	; Add node to the end of the top of the stack
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

_pushStack ENDP


; Parameters: memory address of head node
; Returns: Value of data from popped node
_popStack PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Clear last node
	xor rax, rax
	mov lastNode, rax

	; Set current node values equal to values in the struct that was passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; This section sets the current node data equal to the next node data
	nextNodeJmp:
	mov lastNode, rsi ; Keep track of the previous node
	mov rsi, currentNode.nextNode
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; If the value of next node is 0 then there is no next node, so do not loop
	cmp currentNode.nextNode, 0
	jne nextNodeJmp

	; Delete the last (current) node and keep track of data being deleted so it can be returned
	mov rax, [rsi]
	mov tempData, rax
	mov rcx, rsi
	call free
	
	; Set the new last node's nextNode value to 0
	mov rsi, lastNode
	xor rax, rax ; Clear rax
	mov [rsi + 8], rax ; Set the new last node's nextNode value to 0

	; Return the data that was just popped off the top of the stack
	mov rax, tempData

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_popStack ENDP


; Parameters: memory address of head node
; data to be stored at new node
; Returns: None
_peekStack PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

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

	; Move data at the current (end) node into direct return register (rax)
	mov rax, [rsi]

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_peekStack ENDP


; Parameters: memory address of head node
; Returns: None
_deleteStack PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Clear last node
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

	; Free the previous node
	mov rcx, lastNode
	call free

	mov lastNode, rsi ; Save memory address of previous node

	; If the value of next node is 0 then there is no next node, so do not loop
	cmp currentNode.nextNode, 0
	jne nextNodeJmp

	; Finally, free last node
	mov rcx, lastNode
	call free

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_deleteStack ENDP


_asmMain PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Push values to stack
	lea rcx, head
	mov rdx, 1
	call _pushStack
	lea rcx, head
	mov rdx, 2
	call _pushStack
	lea rcx, head
	mov rdx, 3
	call _pushStack
	lea rcx, head
	mov rdx, 4
	call _pushStack

	; Print stack
	lea rcx, head
	call _printStack
	call _printNewLine

	; Pop data
	lea rcx, head
	call _popStack
	mov rcx, rax ; Print out value just popped
	call _printInt

	; Print stack
	call _printNewLine
	lea rcx, head
	call _printStack

	lea rcx, head
	mov rdx, 20
	call _pushStack

	; Print stack
	call _printNewLine
	lea rcx, head
	call _printStack

	; Peek at the top of the stack
	call _printNewLine
	lea rcx, head
	call _peekStack
	mov rcx, rax
	call _printInt

	; Delete stack
	lea rcx, head
	call _deleteStack

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_asmMain ENDP
END