# ARM Assembly Study Notes: Function Arguments & Stack

## Overview
This code adds 6 numbers (1+2+3+4+5+6 = 21) using a function call.

---

## The Big Picture

```
┌─────────────────────────────────────────────┐
│  Arguments 1-4  →  Use registers r0-r3      │
│  Arguments 5+   →  Use the stack            │
│  Return address →  Save in lr (link reg)    │
└─────────────────────────────────────────────┘
```

---

## Code Breakdown - Step by Step

### STEP 1: Save Return Address
```assembly
.global _start
_start:
    push {lr}
```

| What | Why |
|------|-----|
| Save `lr` to stack | `lr` holds where to return after function ends |
| We will call `bl add_num` later | `bl` overwrites `lr`, so save it first! |

---

### STEP 2: Put First 4 Arguments in Registers
```assembly
    mov r0, #1      @ argument 1 = 1
    mov r1, #2      @ argument 2 = 2
    mov r2, #3      @ argument 3 = 3
    mov r3, #4      @ argument 4 = 4
```

| What | Why |
|------|-----|
| Use r0-r3 for args 1-4 | ARM calling convention (rule) |
| Fast! | Registers are faster than memory |

```
Registers after this step:
┌────┬────┬────┬────┐
│ r0 │ r1 │ r2 │ r3 │
│ 1  │ 2  │ 3  │ 4  │
└────┴────┴────┴────┘
```

---

### STEP 3: Make Space on Stack
```assembly
    sub sp, sp, #8
```

| What | Why |
|------|-----|
| Subtract 8 from stack pointer | Create room for 2 more numbers |
| 8 bytes = 2 × 4 bytes | Each integer = 4 bytes in ARMv7 |

```
Stack grows DOWNWARD:

BEFORE:          AFTER:
High addr        High addr
    │                │
    ▼                ▼
   [sp]             [ ] ← sp+4 (for arg 5)
                    [ ] ← sp   (for arg 6)
Low addr         Low addr
```

---

### STEP 4: Store Arguments 5 and 6 on Stack
```assembly
    mov r4, #6
    str r4, [sp]        @ store 6 at bottom of stack space
    
    mov r4, #5
    str r4, [sp, #4]    @ store 5 at top of stack space
```

| What | Why |
|------|-----|
| Use r4 as temporary | r0-r3 already hold arguments |
| `str` = store to memory | Put values on stack |

```
Stack after storing:
┌─────────┐
│    5    │ ← sp+4  (argument 5)
├─────────┤
│    6    │ ← sp    (argument 6)
└─────────┘
```

---

### STEP 5: Call the Function
```assembly
    bl add_num
```

| What | Why |
|------|-----|
| `bl` = Branch with Link | Jump to function |
| Saves return address in `lr` | So function knows where to come back |

---

### STEP 6: The Function (add_num)
```assembly
add_num:
    @ Add registers (args 1-4)
    add r0, r0, r1      @ r0 = 1+2 = 3
    add r0, r0, r2      @ r0 = 3+3 = 6
    add r0, r0, r3      @ r0 = 6+4 = 10
    
    @ Add from stack (args 5-6)
    ldr r4, [sp, #4]    @ load 5 from stack
    add r0, r0, r4      @ r0 = 10+5 = 15
    
    ldr r4, [sp]        @ load 6 from stack
    add r0, r0, r4      @ r0 = 15+6 = 21
    
    bx lr               @ return to caller
```

| What | Why |
|------|-----|
| `ldr` = load from memory | Get values from stack |
| Result goes in r0 | ARM convention: return value in r0 |
| `bx lr` = return | Jump back to saved address |

---

### STEP 7: Cleanup
```assembly
    mov r4, r0          @ save result (21) in r4
    add sp, sp, #8      @ free stack space
    pop {lr}            @ restore return address
```

| What | Why |
|------|-----|
| `add sp, sp, #8` | Give back the 8 bytes we used |
| `pop {lr}` | Restore original return address |

---

## Visual Summary

```
┌──────────────────────────────────────────────┐
│           PASSING 6 ARGUMENTS                │
├──────────────────────────────────────────────┤
│                                              │
│   Args 1-4: Registers (FAST)                 │
│   ┌────┬────┬────┬────┐                      │
│   │ r0 │ r1 │ r2 │ r3 │                      │
│   │ 1  │ 2  │ 3  │ 4  │                      │
│   └────┴────┴────┴────┘                      │
│                                              │
│   Args 5-6: Stack (SLOWER)                   │
│   ┌─────────┐                                │
│   │    5    │ sp+4                           │
│   ├─────────┤                                │
│   │    6    │ sp                             │
│   └─────────┘                                │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Key Rules to Remember

| Rule | Explanation |
|------|-------------|
| **r0-r3 for first 4 args** | ARM standard calling convention |
| **Stack for extra args** | When you have more than 4 arguments |
| **Save lr before bl** | Or you lose your return address |
| **Stack grows down** | Subtract to allocate, add to free |
| **4 bytes per integer** | ARMv7 uses 32-bit (4 byte) integers |
| **Return value in r0** | Function result always in r0 |

---

## Simple Memory Trick

```
"Registers are VIP seats (r0-r3) - only 4 available"
"Stack is general seating - unlimited but slower"
```