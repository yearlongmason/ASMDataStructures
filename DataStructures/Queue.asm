; Queue.asm
; Mason Lee

malloc PROTO
free PROTO
_printInt PROTO
_printNewLine PROTO ; Mostly for testing purposes

.DATA
QueueNode STRUCT
	data QWORD ?
	nextNode QWORD 0
QueueNode ENDS

head QueueNode <0, 0>
currentNode QueueNode <0, 0>
lastNode QWORD ? ; This will be used as a pointer to the previous node
tempData QWORD ?
headNodePtr QWORD ?

.CODE


; Parameters: memory address of head node
; data to be stored at new node
; Returns: None
_pushQueue PROC
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

	; Add node to the end of the emd of the queue
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

_pushQueue ENDP


; Parameters: memory address of head node
; Returns: Data at node that was just popped
_popQueue PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Save off the head node pointer
	mov headNodePtr, rcx

	; Move to next node
	mov rsi, rcx
	mov rsi, [rsi + 8]

	; Save off data and next node ptr in currentNode
	mov rax, [rsi]
	mov currentNode.data, rax
	mov rax, [rsi + 8]
	mov currentNode.nextNode, rax

	; Delete current node (node being popped)
	mov rcx, rsi
	call free

	; Set first node to the next node (currently being stored in currentNode.nextNode)
	mov rsi, headNodePtr
	mov rax, currentNode.nextNode
	mov [rsi + 8], rax

	; Return data stored at node just popped
	mov rax, currentNode.data

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_popQueue ENDP


; Parameters: memory address of head node
; Returns: None
_printQueue PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Set current node values equal to values in the struct that was passed in
	mov rsi, rcx
	mov rcx, [rsi]
	mov currentNode.data, rcx
	mov rcx, [rsi + 8]
	mov currentNode.nextNode, rcx

	; If the queue is empty just finish
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

_printQueue ENDP


; Parameters: memory address of head node
; Returns: None
_deleteQueue PROC
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

	; Finally, free the last node
	mov rcx, lastNode
	call free

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_deleteQueue ENDP


; FUNCTIONS TO IMPLEMENT
; pushQueue DONE
; popQueue
; printQueue DONE
; deleteQueue DONE

_asmMain PROC
	push rbp ; Push frame pointer onto the stack
	sub rsp, 20h
	lea rbp, [rsp + 20h]

	; Push values onto queue
	lea rcx, head
	mov rdx, 1
	call _pushQueue
	lea rcx, head
	mov rdx, 2
	call _pushQueue
	lea rcx, head
	mov rdx, 3
	call _pushQueue

	; Print queue
	lea rcx, head
	call _printQueue
	call _printNewLine

	; Pop value
	lea rcx, head
	call _popQueue
	mov rcx, rax
	call _printInt
	call _printNewLine
	
	; Print queue
	lea rcx, head
	call _printQueue
	call _printNewLine

	; Delete queue
	lea rcx, head
	call _deleteQueue

	lea rsp, [rbp]
	pop rbp ; Pop frame pointer from the stack
	ret ; return to where function was called

_asmMain ENDP
END