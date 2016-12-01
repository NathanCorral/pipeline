;; author: Colin Lord

;; reference C code below:
;;
;; int fac = 5;
;; int acc = 1;
;; 
;; for(int i = 1; i <= fac; i++)
;;     acc *= i;

;; R0 holds 0 at all times
;; R1 holds 1 at all times
;; R7 is similar to assembler temporary and can be overwritten at (almost) any time
;; Value calculated can be changed by changing data at label FIVE

ORIGIN 4x0000
SEGMENT CodeSegment:

    LDR R1, R0, ONE     ; Initialize R1 to 1 for convenience
    LDR R2, R0, FIVE    ; R2 <- int fac = 5;
    LDR R3, R0, ONE     ; R3 <- int acc = 1;
    LDR R4, R0, ONE     ; R4 <- int i = 1;

LOOP_ACC:
    NOT R7, R4          ; prepare i for subtraction
    ADD R7, R7, R1      ; R7 is negative i
    ADD R7, R7, R2      ; i <= fac comparison
    BRn HALT            ; if i <= fac, end program
    BRnzp MULTIPLY      ; multiply i and acc
MUL_CALL:
    ADD R3, R0, R6      ; Store multiplication result in R3
    ADD R4, R4, R1      ; i++
    BRnzp LOOP_ACC

HALT:
    BRnzp HALT

;; R6 = 0;
;; for(int i = 0; i < R3; i++)
;;     R6 += R4;
MULTIPLY:
    ADD R6, R0, R0      ; R6 = 0;
    ADD R5, R0, R0      ; R5 <- int i = 0;
LOOP_MULTIPLY:
    NOT R7, R5          ; prepare i for subtraction
    ADD R7, R7, R1      ; R7 is negative i
    ADD R7, R7, R3
    BRnz MUL_CALL       ; if i >= R3, we're done
    ADD R6, R6, R4      ; R6 += R4;
    ADD R5, R5, R1      ; i++
    BRnzp LOOP_MULTIPLY

ONE:  DATA2 4x0001
FIVE: DATA2 4x0005
