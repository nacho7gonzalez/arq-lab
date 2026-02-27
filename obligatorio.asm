.data
;;;;;;;;Default Port Constants;;;;;;;;
	PUERTO_LOG_DEFECTO EQU 2
	PUERTO_SALIDA_DEFECTO EQU 1
	PUERTO_ENTRADA_DEFECTO EQU 10

;;;;;;;;;;;;Variable Ports;;;;;;;;;;;;
	LOG_PORT dw PUERTO_LOG_DEFECTO
	OUT_PORT dw PUERTO_SALIDA_DEFECTO
	IN_PORT dw PUERTO_ENTRADA_DEFECTO

;;;Requirements For Stack Imlementation;;;
	STACK_MEMORY dw DUP(31) 0;
	STACK_BASE EQU STACK_MEMORY
	STACK_SIZE EQU 61 
	STACK_POINTER dw 0
	jjjjjj dw 0xABCD
;;;Extra Variables;;;
	COMMAND dW 0
	AUX1 dW 0
	AUX2 dW 0

.code
;;;;RPN calculator;;;;
Main:;;DONE;;
	MOV DX, [IN_PORT]  			;DX = IN_PORT
	IN AX, DX 					;Read from input port and store in AX
	MOV [COMMAND], AX			;Store the command in COMMAND
	PUSH AX						;Push the command to the stack
	MOV AX, 0					;AX = 0
	MOV DX, [LOG_PORT] 			;DX = LOG_PORT
	OUT DX, AX 					;Write 0 to log port
	POP AX						;Pop the command from the stack
	OUT DX, AX 					;Write the command to log port
	CMP AX, 1					;Compare AX with 1
	JZ GetNumber				;If AX = 1, jump to GetNumber
	CMP AX, 2					;Compare AX with 2
	JZ ChangeOutPort			;If AX = 2, jump to ChangeOutPort
	CMP AX, 3					;Compare AX with 3
	JZ ChangeLogPort 			;If AX = 3, jump to ChangeLogPort
	CMP AX, 4 					;Compare AX with 4
	JZ ShowTopOfStack 			;If AX = 4, jump to ShowTopOfStack
	CMP AX, 5 					;Compare AX with 5
	JZ ShowFullStack 			;If AX = 5, jump to ShowFullStack
	CMP AX, 6 					;Compare AX with 6
	JZ DuplicateTopOfStack 		;If AX = 6, jump to Dup
	CMP AX, 7 					;Compare AX with 7
	JZ SwapTopOfStack 			;If AX = 7, jump to SwapTopOfStack
	CMP AX, 8 					;Compare AX with 8
	JZ NegateTopOfStack 		;If AX = 8, jump to NegateTopOfStack
	CMP AX, 9 					;Compare AX with 9
	JZ FactorialTopOfStack		;If AX = 9, jump to FactorialTopOfStack
	CMP AX, 10 					;Compare AX with 10
	JZ SumFullStack 			;If AX = 10, jump to SumFullStack
	CMP AX, 11 					;Compare AX with 11
	JZ Addition 				;If AX = 11, jump to Addition
	CMP AX, 12 					;Compare AX with 12
	JZ Subtraction 				;If AX = 12, jump to Subtraction
	CMP AX, 13 					;Compare AX with 13
	JZ Product 					;If AX = 13, jump to Product
	CMP AX, 14 					;Compare AX with 14
	JZ Division 				;If AX = 14, jump to Division
	CMP AX, 15 					;Compare AX with 15
	JZ Modulus 					;If AX = 15, jump to Modulus
	CMP AX, 16 					;Compare AX with 16
	JZ AndBB 					;If AX = 16, jump to AndBB
	CMP AX, 17 					;Compare AX with 17
	JZ OrBB 					;If AX = 17, jump to OrBB
	CMP AX, 18 					;Compare AX with 18
	JZ LeftShift 				;If AX = 18, jump to LeftShift
	CMP AX, 19 					;Compare AX with 19
	JZ RightShift 				;If AX = 19, jump to RightShift
	CMP AX, 254 				;Compare AX with 254
	JZ Clear 					;If AX = 254, jump to Clear
	CMP AX, 255 				;Compare AX with 255
	JZ Halt 					;If AX = 255, jump to Halt
	JMP Error2  				;If AX != any of the above, jump to Error2

GetNumber:;;DONE;;
	MOV DX, [IN_PORT] 				;DX = IN_PORT
	IN AX, DX 						;Read num from input port and store in AX
	MOV DX, [LOG_PORT] 				;DX = LOG_PORT
	OUT DX, AX						;Write the input into the log Port
	MOV CX , [STACK_POINTER]		;CX = STACK_POINTER
	CMP CX, STACK_SIZE 				;Compare STACK_POINTER with STACk_SIZE to check if its full
	JGE Error4						;If Stack is full, jump to Error4
	MOV DI, [STACK_POINTER] 		;CX = STACK_POINTER
	INC CX							;Else increment STACK_POINTER
	INC CX							;Making it point to the next free space
	MOV [STACK_POINTER], CX 		;Store the new value of STACK_POINTER
	MOV BX, STACK_BASE				;BX = STACK[0]
	MOV [BX + DI], AX				;Store num in stack
	JMP Error16 					;Jump to Error16

ChangeOutPort:;;DONE;;
	MOV DX, [IN_PORT] 		;DX = IN_PORT
	IN AX, DX 				;Read new port from input port and store in AX
	MOV DX, [LOG_PORT]		;DX = LOG_PORT
	OUT DX, AX				;Write the input into the log Port
	MOV [OUT_PORT], AX		;Store the new port in OUT_PORT
	JMP Error16 			;Jump to Error16

ChangeLogPort:;;DONE;;
	MOV DX, [IN_PORT] 		;DX = IN_PORT
	IN AX, DX	 			;Read new port from input port and store in AX
	MOV DX, [LOG_PORT]		;DX = LOG_PORT
	OUT DX, AX				;Write the input into the log Port
	MOV [LOG_PORT], AX		;Store new port in LOG_PORT
	JMP Error16 			;Jump to Error16

ShowTopOfStack:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 		;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8							;If Stack is empty, jump to Error3
	MOV BX, STACK_BASE 					;BX = STACK[0]
	MOV DI, [STACK_POINTER]				;DI = STACK[STACKPOINTER]
	MOV AX, [BX + DI - 2]				;AX = STACK[STACKPOINTER]
	MOV DX, [OUT_PORT] 					;DX = OUT_PORT
	OUT DX, AX 							;Write AX to output port
	JMP Error16 						;Jump to Error16

ShowFullStack:;;DONE;;
	MOV BX, STACK_BASE 				;BX = STACK[0]
	MOV DX, [OUT_PORT] 				;DX = OUT_PORT
	MOV DI, [STACK_POINTER]		;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	ShowFullStackLoop:
		CMP DI, 0 									;Compare DI with 0 to check if Stack its empty
		JL ShowFullStackEnd							;If Stack is empty, jump to ShowFullStackEnd
		MOV AX, [BX + DI]							;AX = Stack[STACK_POINTER]
		OUT DX, AX									;Write AX to output port
		DEC DI										;Decrement DI
		DEC DI
		JMP ShowFullStackLoop						;Jump to ShowFullStackLoop
	ShowFullStackEnd:
		JMP Error16 								;Jump to Error16

DuplicateTopOfStack:;;DONE;;
	CMP word ptr[STACK_POINTER], STACK_SIZE 		;Compare STACK_POINTER with STACk_SIZE to check if its full
	JZ Error4										;If Stack is full, jump to Error4
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE 								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV AX, [BX + DI]								;AX = STACK[STACKPOINTER]
	INC word ptr[STACK_POINTER]						;Increment STACK_POINTER
	INC word ptr[STACK_POINTER]						;Making it point to the next free space
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	MOV [BX + DI - 2], AX							;STACK[STACKPOINTER] = AX
	JMP Error16 									;Jump to Error16

SwapTopOfStack:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	CMP word ptr[STACK_POINTER], 2 					;Compare STACK_POINTER with 1 to check if its empty
	JZ ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV BX, STACK_BASE 								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV AX, [BX + DI]								;AX = STACK[STACKPOINTER]
	MOV CX, [BX + DI - 2]							;BX = Stack[STACK_POINTER - 1]
	MOV [BX + DI], CX								;STACK[STACKPOINTER] = CX
	MOV [BX + DI - 2], AX							;Stack[STACK_POINTER - 1] = AX
	JMP Error16 									;Jump to Error16

NegateTopOfStack:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE 								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV AX, [BX + DI]								;AX = STACK[STACKPOINTER]
	NEG AX											;Negate AX
	MOV [BX + DI], AX								;STACK[STACKPOINTER] = AX
	JMP Error16 									;Jump to Error16

FactorialTopOfStack:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 							;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE					 			;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV AX, [BX + DI]								;AX = STACK[STACKPOINTER]
	CALL RecursiveFactorial 						;Call RecursiveFactorial
	MOV [BX + DI], CX								;STACK[STACKPOINTER] = CX
	JMP Error16 									;Jump to Error16

JMP Skip
RecursiveFactorial PROC
	PUSH AX 										;Push AX to stack to preserve previous value
	PUSH BX 										;Push CX to stack to preserve previous value
	CMP AX, 0 										;Compare AX with 0
	JE Zero 										;If AX = 0, jump to Zero
	DEC AX 											;Decrement AX
	CALL RecursiveFactorial 						;Call RecursiveFactorial
	INC AX 											;Increment AX
	MOV BX, AX 										;BX = AX
	MUL CX 											;AX = AX * CX
	MOV CX, AX 										;CX = AX
	MOV AX, BX 										;AX = BX
	JMP EndFact 									;Jump to EndFact
	Zero:
		MOV CX, 1 									;BX = 1
	EndFact:
		POP BX 										;Pop BX from stack
		POP AX 										;Pop AX from stack
		RET
RecursiveFactorial ENDP

Skip:

SumFullStack:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Put0											;If Stack is empty, jump to Put0
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV SI, [STACK_POINTER]							;CX = STACK_POINTER
	DEC SI
	DEC SI
	MOV AX, 0										;AX = 0
	SumLoop:
		ADD AX, [BX + SI]							;AX = AX + Stack[STACK_POINTER]
		DEC SI										;Decrement SI
		DEC SI 										;Decrement SI
		CMP SI, 0									;Compare CX with 0
		JGE SumLoop									;If CX != 0, jump to SumLoop
	MOV word ptr[STACK_POINTER], 2					;STACK_POINTER = 1
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	MOV [BX + DI - 2], AX								;Stack[STACK_POINTER] = AX
	JMP Error16 									;Jump to Error16

Put0:
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	MOV CX, 0
	MOV [BX + DI], CX								;Stack[STACK_POINTER] = 0
	INC DI											;Increment DI
	INC DI											;Increment DI
	MOV [STACK_POINTER], DI							;STACK_POINTER = DI
	JMP Error16 									;Jump to Error16

Addition:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI											;Decrement SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV AX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV CX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	ADD AX, CX										;AX = AX + CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

Subtraction:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI											;Decrement SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	SUB AX, CX										;AX = AX - CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

Product:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI											;Decrement SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV AX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV CX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	IMUL CX											;AX = AX * CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

Division:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI											;Decrement SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	PUSH DX
	MOV DX, 0
	CMP AX, 0
	JL DivNeg
	IDIV CX											;AX = AX / CX
	POP DX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

DivNeg:
	MOV DX, 0xFFFF
	IDIV CX											;AX = AX / CX
	POP DX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

Modulus:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI											;Decrement SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	MOV [AUX1], AX 									;Save AX in AUX1
	MOV [AUX2], CX 									;Save CX in AUX2
	PUSH DX
	MOV DX, 0
	IDIV CX											;AX = AX / CX
	MOV [BX + SI], DX								;Stack[STACK_POINTER] = DX
	POP DX
	CMP word ptr[AUX1], 0									;Compare AUX1 with 0
	JL NegMod										;If AUX1 < 0, jump to NegMod
	CMP word ptr[AUX2], 0									;Compare AUX2 with 0
	JL NegMod										;If AUX2 < 0, jump to NegMod
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	MOV BX, STACK_BASE 								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	MOV AX, [BX + DI]								;AX = STACK[STACKPOINTER]
	MOV [BX + DI], AX								;STACK[STACKPOINTER] = AX
	JMP Error16 									;Jump to Error16

NegMod:;;DONE;;
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	MOV BX, STACK_BASE 								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	MOV AX, [BX + DI]								;AX = STACK[STACKPOINTER]
	NEG AX											;Negate AX
	MOV [BX + DI], AX								;STACK[STACKPOINTER] = AX
	JMP Error16 									;Jump to Error16


AndBB:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	AND AX, CX										;AX = AX & CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI					;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

OrBB:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	OR AX, CX										;AX = AX | CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI							;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

LeftShift:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	CMP CX, 16
	JGE TooLeft
	SAL AX, CL										;AX = AX << CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI							;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

TooLeft:
	MOV AX, 0
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI							;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

RightShift:;;DONE;;
	CMP word ptr[STACK_POINTER], 0 					;Compare STACK_POINTER with 0 to check if its empty
	JZ Error8										;If Stack is empty, jump to Error8
	MOV BX, STACK_BASE								;BX = STACK[0]
	MOV DI, [STACK_POINTER]							;DI = STACK[STACKPOINTER]
	DEC DI
	DEC DI
	MOV SI, DI										;SI = STACK[STACKPOINTER - 1]
	DEC SI											;Decrement SI
	DEC SI
	CMP SI, 0										;Compare SI with 0
	JL ClearAnd8									;If Stack is empty, jump to ClearAnd8
	MOV CX, [BX + DI]								;AX = Stack[STACK_POINTER]
	MOV AX, [BX + SI]								;CX = Stack[STACK_POINTER - 1]
	CMP CX, 16
	JGE TooRight
	SAR AX, CL										;AX = AX >> CX
	MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
	MOV word ptr[STACK_POINTER], DI							;STACK_POINTER -= 1
	JMP Error16 									;Jump to Error16

TooRight:
	CMP AX, 0
	JL Negative
	MOV AX, 0
	SetShift:
		MOV [BX + SI], AX								;Stack[STACK_POINTER] = AX
		MOV word ptr[STACK_POINTER], DI							;STACK_POINTER -= 1
		JMP Error16 									;Jump to Error16
	Negative:
		MOV AX, -1
		JMP SetShift

Clear:;;DONE;;
	MOV word ptr[STACK_POINTER], 0 					;STACK_POINTER = 0
	JMP Error16 									;Jump to Error16

Halt:;;DONE;;
	MOV AX, 16										;AX = 16
	OUT DX, AX										;Write 16 to log port
	HaltLoop:
		JMP HaltLoop 								;Loop forever

ClearAnd8:;;DONE;;
	MOV word ptr[STACK_POINTER], 0 					;STACK_POINTER = 0
	JMP Error8 										;Jump to Error8

Error2:
	MOV AX, 2 			;AX = 2
	OUT DX, AX 			;Write 2 to log port
	JMP Main			;Return to Main

Error4:
	MOV AX, 4			;AX = 4
	MOV DX, [LOG_PORT] 	;DX = LOG_PORT
	OUT DX, AX 			;Write 4 to log port
	JMP Main 			;Return to Main

Error8:
	MOV AX, 8			;AX = 8
	MOV DX, [LOG_PORT] 	;DX = LOG_PORT
	OUT DX, AX			;Write 8 to log port
	JMP Main 			;Return to Main

Error16:
	MOV AX, 16										;AX = 16
	MOV DX, [LOG_PORT] 								;DX = LOG_PORT
	OUT DX, AX										;Write 16 to log port
	JMP Main										;Return to Main

.ports 
10: 1,1, 1,2, 1,3, 1,4, 1,5, 1,1, 1,9, 1,8, 1,-1400, 1,10, 1,11, 1,12, 1,13, 11, 4, 12, 4, 13, 4, 14, 4, 15, 4, 16, 4, 17, 4, 18, 4, 7, 4, 19, 4, 10, 4, 8, 4, 6, 5, 254, 255 

.interrupts	; Manejo de interrupciones. En esta tarea no se usan interrupciones.
