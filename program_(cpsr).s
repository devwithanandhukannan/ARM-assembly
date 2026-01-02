.global _start
_start:
	mov r0, #10
	mov r1, #20
	subs r3, r0, r1

// cpsr register are current program status register
// which means it contains some flag contains the status and control information about the processor
// flags are NZCV