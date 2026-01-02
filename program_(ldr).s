.global _start
.text
_start:
	ldr r0, =var1   //this return the address of that memory 
	ldr r1, [r0] // load the value of r0 to r1

.data
var1: .word 3
var2: .word 4
	
	
//ldr is used to load the data from memory to register