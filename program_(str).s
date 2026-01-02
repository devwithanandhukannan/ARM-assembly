.global _start

.text
_start:
    mov r1, #1          @ store immediate value 1 in r1
    ldr r2, =var1       @ load address of var1 into r2
    str r1, [r2]        @ store r1 into memory at var1

.data
var1: .word 3


//str used to store register value to the memory
