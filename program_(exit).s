//created simple ARMv7 assembly program
//use move instruction to store immediate register value
.global start to label outside the program. need to understand
_start used to declare that 

r7 register is system call register
swi software intrupt

.global _start

_start:
	mov r0, #42
	mov r7, #1
	swi 0


r7 here 1 is exit
and swi is software intrupt tell the cpu to take over next
