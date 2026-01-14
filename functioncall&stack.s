.global _start
_start:
    mov r0, #1        
    mov r1, #2     

    bl  add_number    
    mov r2, r0        

    mov r7, #1        
    svc #0

add_number:           
    add r0, r0, r1    
    bx  lr        


@ ---------------------------------------    

@ Use the stack (save LR)❓ Task
@ Write a function that:
@ Saves lr on stack
@ Adds 4 + 6
@ Restores lr
@ Returns safely
@ .global _start

_start:
    mov r0, #4
    mov r1, #6

    bl safe_add
    mov r2, r0

    mov r7, #1
    mov r0, #0
    svc #0

safe_add:
    push {lr}
    add r0, r0, r1
    pop {lr}
    bx lr
