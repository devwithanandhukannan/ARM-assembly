# ARMv7 Assembly

## Description

**Program 1: Exit Program**

This program demonstrates a minimal ARMv7 Linux assembly example that exits immediately using a system call and returns status code `42`.

### Why does the Program Counter (PC) increment by 4?

In ARMv7 **ARM state**, each instruction is **32 bits (4 bytes)** long.

- The Program Counter (`PC`) always points to the **next instruction**
- After executing one instruction, the CPU increments the PC by **4 bytes**
- This allows sequential execution of instructions in memory

> Note:  
> In **Thumb mode**, instructions may be 16 or 32 bits, so the PC may increment by **2 or 4** instead.

### Program Behavior

- Execution starts at `_start`
- ARM registers are used to invoke a Linux system call
- The program exits immediately with status code `42`

This is commonly the first example when learning ARM assembly and Linux syscalls.

## Source Code

- [Exit program source](./program_(exit).s)
