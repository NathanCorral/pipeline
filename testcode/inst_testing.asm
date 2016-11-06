ORIGIN 4x0000
SEGMENT CodeSegment:
    ADD R1, R0, 7
    LDI R2, R0, FOURI
    AND R3, R2, R1
    AND R3, R3, -1
    LEA R4, rabbit_hole
    JMP R4
continue0:
    JSR mangos
    NOT R1, R1
    LEA R4, guavas
    JSRR R4
    JSR mangos
    STI R1, R0, FOURI
    LDI R2, R0, FOURI
    TRAP MEM_MANGO
complete:
    BRnzp complete

rabbit_hole:
    LEA R7, continue0
    RET

mangos:
    LDB R1, R0, FS
    RET

guavas:
    STB R1, R0, FS
    RET
    
SEGMENT DataSegment:
FOUR:       DATA2 4
FOURI:      DATA2 FOUR
FS:         DATA2 4xffff
RES1:       DATA2 0
RES2:       DATA2 0
RES3:       DATA2 0
RES4:       DATA2 0
RES5:       DATA2 0
RES6:       DATA2 0
RES7:       DATA2 0
RES8:       DATA2 0
RES9:       DATA2 0
RES10:      DATA2 0
RES11:      DATA2 0
RES12:      DATA2 0
RES13:      DATA2 0
RES14:      DATA2 0
RES15:      DATA2 0
RES16:      DATA2 0
MEM_MANGO:  DATA2 mangos
