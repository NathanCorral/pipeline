ORIGIN 4x0000
SEGMENT CodeSegment:
	LEA R0, DataSegment
	LDR R1, R0, FULL1
	NOP
	NOP
	NOP
	NOP
	; Transparent Regfile Check
	ADD R1, R0, 1		; WB
	ADD R2, R1, 2		; MEM
	ADD R3, R1, 3		; EX
	ADD R4, R1, 4		; ID

	; Add, Load, Store
	ADD R2, R1, 1
	LDR R3, R2, FULL2
	STR R3, R2, RES1	; ADDR: 3e

	; Add, Store, Load
	ADD R2, R1, 2
	STR R2, R1, RES2
	LDR R3, R2, FULL3

	; Load, Add, Store
	LDR R2, R0, FULL4
	ADD R3, R2, 1
	STR R3, R2, RES3

	;  Load, Store, Add
	LDR R2, R0, FULL5
	STR R2, R0, RES4
	ADD R3, R2, 1

	
SEGMENT DataSegment:
FULL1:      DATA2 4x1234
FULL2:      DATA2 4x5678
FULL3:      DATA2 4x9ABC
FULL4:      DATA2 4xDEF0
FULL5:      DATA2 4x3579
NOP
NOP
NOP
NOP
NOP
NOP
NOP
RES1:       DATA2 4xFFFF
RES2:       DATA2 4xFFFF
RES3:       DATA2 4xFFFF
RES4:       DATA2 4xFFFF
RES5:       DATA2 4xFFFF
RES6:       DATA2 4xFFFF
RES7:       DATA2 4xFFFF
RES8:       DATA2 4xFFFF