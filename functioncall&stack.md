### 1. What happens when we call a function?

In C:
```c
int add(int a, int b) { return a + b; }

int main() {
    add(1, 2);
    return 0;
}
```

In ARM assembly, a **function call** is done with a special **branch instruction** called **BL** (Branch with Link).

### 2. Important registers for function calls

- **Link Register (LR) = r14**  
  When you execute `BL label`, the **processor automatically saves the address of the next instruction** (return address) into **LR**.

- **BX LR**  
  Means **"branch to the address stored in LR"** → return from the function.

### 3. How arguments are passed (ARM32 standard calling convention - AAPCS)

**First 4 arguments** → put in registers **r0, r1, r2, r3** (from left to right).

| Argument position | Register |
|-------------------|----------|
| 1st               | r0       |
| 2nd               | r1       |
| 3rd               | r2       |
| 4th               | r3       |

Return value is usually placed back in **r0**.

### 4. Very simple example

```arm
.global _start
_start:
    mov r0, #1        @ 1st argument
    mov r1, #2        @ 2nd argument

    bl  add_number    @ call function → LR gets address of next instruction

    mov r2, r0        @ result is in r0

    mov r7, #1        @ exit syscall
    svc #0

add_number:           @ function label (like function name in C)
    add r0, r0, r1    @ r0 = r0 + r1
    bx  lr            @ return (jump to address saved in LR)
```

### 5. Why do we need the **stack** (and `push`/`pop`)?

**Problem**:  
The called function (callee) is allowed to **change (clobber) r0-r3** and also **r12** (and sometimes other registers).  
If the **caller** still needs the old values of these registers after the function returns → **they must be saved somewhere**.

**Solution** → **save them on the stack** before the call and **restore them** after the call.

### 6. Stack basics (very simple)

- **SP** (Stack Pointer) = **r13** → always points to the **top** of the stack.
- Stack grows **downwards** (lower memory addresses) in ARM.

**push {r0, r1}**  
→ stores r0 and r1 to memory and **decreases SP** (makes room).

**pop {r0, r1}**  
→ loads values back from memory to r0 and r1 and **increases SP** (cleans up).

### 7. Example with saving/restoring registers

```arm
_start:
    mov r0, #10
    mov r4, #20           @ caller wants to keep r4 unchanged

    push {r0, r4, lr}     @ save r0, r4 and return address (LR)

    mov r0, #5
    mov r1, #3
    bl  add_number        @ function may change r0-r3

    pop {r0, r4, lr}      @ restore original values + return address

    @ now r0 and r4 have the same values as before the call
```

**Inside the function** (if it calls another function → it also has to save LR again):

```arm
add_number:
    push {lr}             @ save its own return address (nested call possible)

    add r0, r0, r1

    pop {lr}              @ restore return address
    bx  lr
```

### Quick summary table

| Instruction | Meaning (simple words)               | Effect on SP |
|------------|--------------------------------------|--------------|
| `bl label` | call function + save return address in LR | no change |
| `bx lr`    | return from function                 | no change |
| `push {regs}` | save registers on stack           | SP ↓ (decreases) |
| `pop {regs}`  | restore registers from stack       | SP ↑ (increases) |

**Main idea to remember**  
**BL + LR** → makes it possible to **return** from a function.  
**Stack + push/pop** → allows us to **save important register values** when the function is allowed to change them.