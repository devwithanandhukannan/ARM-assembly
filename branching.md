# ARM Branching Tutorial

## 📚 Table of Contents
```
ARM BRANCHING
│
├── 1. BASICS
│   ├── What is a Label?
│   ├── What is Branch (B)?
│   └── Basic Syntax
│
├── 2. CONDITION CODES
│   ├── Equal/Not Equal
│   ├── Signed Comparisons
│   ├── Unsigned Comparisons
│   └── Special Flags
│
├── 3. EXAMPLES
│   ├── BEQ (Equal)
│   ├── BNE (Not Equal)
│   ├── BGT (Greater Than)
│   ├── BLT (Less Than)
│   └── More...
│
└── 4. EXERCISES
```

---

# 1. BASICS

## What is a Label?
```
LABEL
│
├── A name that marks a location in your code
├── Like a bookmark in a book
└── Example: "cond1:" or "loop:" or "end:"
```

## What is Branch (B)?
```
BRANCH (B)
│
├── Tells the program to JUMP to another location
├── Like saying "Go to page 50"
└── Without branch → Code runs line by line (top to bottom)
```

## Basic Syntax
```
B <condition> <label>

    B    →  Branch (jump) instruction
    <c>  →  Condition (when to jump)
    <label> → Where to jump
```

---

# 2. CONDITION CODES

## Complete Condition Table
```
CODE    NAME                    MEANING                         FLAG CHECK
────────────────────────────────────────────────────────────────────────────
EQ      Equal                   Values are same                 Z == 1
NE      Not Equal               Values are different            Z == 0
────────────────────────────────────────────────────────────────────────────
GT      Greater Than (signed)   First > Second                  Z==0 AND N==V
LT      Less Than (signed)      First < Second                  N != V
GE      Greater or Equal        First >= Second                 N == V
LE      Less or Equal           First <= Second                 Z==1 OR N!=V
────────────────────────────────────────────────────────────────────────────
HI      Higher (unsigned)       First > Second                  C==1 AND Z==0
LS      Lower or Same           First <= Second                 C==0 OR Z==1
CS/HS   Carry Set/Higher Same   First >= Second                 C == 1
CC/LO   Carry Clear/Lower       First < Second                  C == 0
────────────────────────────────────────────────────────────────────────────
MI      Minus                   Result is negative              N == 1
PL      Plus                    Result is positive or zero      N == 0
VS      Overflow                Overflow happened               V == 1
VC      No Overflow             No overflow                     V == 0
────────────────────────────────────────────────────────────────────────────
AL      Always                  Always jump (no condition)      Any
```

---

# 3. CODE EXAMPLES

## ⚠️ The Problem: Code Falls Through

```arm
.global _start
_start:
    mov r0, #2
    mov r1, #2
    cmp r0, r1
    beq cond1

cond1:
    mov r2, #1
    
cond2:
    mov r3, #1
```

```
WHAT HAPPENS:
│
├── r0 = 2, r1 = 2
├── Compare: r0 == r1? YES!
├── Jump to cond1 ✓
├── Execute: r2 = 1
├── FALLS INTO cond2 (PROBLEM!)
└── Execute: r3 = 1
```

**Problem:** Both cond1 AND cond2 run!

---

## ✅ The Solution: Use Unconditional Branch

```arm
.global _start
_start:
    mov r0, #2
    mov r1, #2
    cmp r0, r1
    beq cond1       @ if equal, go to cond1
    b cond2         @ else, go to cond2

cond1:
    mov r2, #1
    b end           @ skip cond2

cond2:
    mov r3, #1

end:
```

```
THIS IS LIKE:
│
├── if (r0 == r1) {
│       cond1 code
│   }
│   else {
│       cond2 code
│   }
```

---

## BEQ - Branch if Equal

```arm
.global _start
_start:
    mov r0, #5
    mov r1, #5
    cmp r0, r1
    beq same        @ if r0 == r1, jump to same
    b different

same:
    mov r2, #1      @ r2 = 1 (they are equal)
    b end

different:
    mov r2, #0      @ r2 = 0 (they are different)

end:
```

```
FLOW:
│
├── r0 = 5
├── r1 = 5
├── Compare: 5 == 5? YES
├── Jump to "same"
└── r2 = 1
```

---

## BNE - Branch if Not Equal

```arm
.global _start
_start:
    mov r0, #5
    mov r1, #3
    cmp r0, r1
    bne not_equal   @ if r0 != r1, jump
    b equal

not_equal:
    mov r2, #1      @ Values are different
    b end

equal:
    mov r2, #0      @ Values are same

end:
```

```
FLOW:
│
├── r0 = 5
├── r1 = 3
├── Compare: 5 != 3? YES
├── Jump to "not_equal"
└── r2 = 1
```

---

## BGT - Branch if Greater Than (Signed)

```arm
.global _start
_start:
    mov r0, #10
    mov r1, #5
    cmp r0, r1
    bgt greater     @ if r0 > r1, jump
    b not_greater

greater:
    mov r2, #1      @ r0 is bigger
    b end

not_greater:
    mov r2, #0      @ r0 is not bigger

end:
```

```
FLOW:
│
├── r0 = 10
├── r1 = 5
├── Compare: 10 > 5? YES
├── Jump to "greater"
└── r2 = 1
```

---

## BLT - Branch if Less Than (Signed)

```arm
.global _start
_start:
    mov r0, #3
    mov r1, #7
    cmp r0, r1
    blt smaller     @ if r0 < r1, jump
    b not_smaller

smaller:
    mov r2, #1      @ r0 is smaller
    b end

not_smaller:
    mov r2, #0      @ r0 is not smaller

end:
```

```
FLOW:
│
├── r0 = 3
├── r1 = 7
├── Compare: 3 < 7? YES
├── Jump to "smaller"
└── r2 = 1
```

---

## BGE - Branch if Greater or Equal

```arm
.global _start
_start:
    mov r0, #5
    mov r1, #5
    cmp r0, r1
    bge pass        @ if r0 >= r1, jump
    b fail

pass:
    mov r2, #1      @ Passed the check
    b end

fail:
    mov r2, #0      @ Failed the check

end:
```

```
FLOW:
│
├── r0 = 5
├── r1 = 5
├── Compare: 5 >= 5? YES (equal counts!)
├── Jump to "pass"
└── r2 = 1
```

---

## BLE - Branch if Less or Equal

```arm
.global _start
_start:
    mov r0, #4
    mov r1, #4
    cmp r0, r1
    ble less_or_eq  @ if r0 <= r1, jump
    b greater

less_or_eq:
    mov r2, #1
    b end

greater:
    mov r2, #0

end:
```

---

## BHI - Branch if Higher (Unsigned)

```arm
.global _start
_start:
    mov r0, #200
    mov r1, #100
    cmp r0, r1
    bhi higher      @ if r0 > r1 (unsigned), jump
    b not_higher

higher:
    mov r2, #1
    b end

not_higher:
    mov r2, #0

end:
```

```
USE UNSIGNED WHEN:
│
├── Values are always positive
├── Working with addresses
└── Working with bytes (0-255)
```

---

## BLS - Branch if Lower or Same (Unsigned)

```arm
.global _start
_start:
    mov r0, #50
    mov r1, #100
    cmp r0, r1
    bls lower_same  @ if r0 <= r1 (unsigned), jump
    b higher

lower_same:
    mov r2, #1
    b end

higher:
    mov r2, #0

end:
```

---

## BMI - Branch if Minus (Negative)

```arm
.global _start
_start:
    mov r0, #5
    mov r1, #10
    subs r2, r0, r1  @ r2 = r0 - r1 = 5 - 10 = -5
    bmi negative     @ if result is negative, jump
    b positive

negative:
    mov r3, #1       @ Result was negative
    b end

positive:
    mov r3, #0       @ Result was positive

end:
```

---

## BPL - Branch if Plus (Positive or Zero)

```arm
.global _start
_start:
    mov r0, #10
    mov r1, #5
    subs r2, r0, r1  @ r2 = 10 - 5 = 5
    bpl positive     @ if result >= 0, jump
    b negative

positive:
    mov r3, #1
    b end

negative:
    mov r3, #0

end:
```

---

## BVS/BVC - Overflow Check

```arm
.global _start
_start:
    ldr r0, =0x7FFFFFFF  @ Maximum positive number
    mov r1, #1
    adds r2, r0, r1      @ This causes overflow!
    bvs overflow         @ if overflow, jump
    b no_overflow

overflow:
    mov r3, #1           @ Overflow happened
    b end

no_overflow:
    mov r3, #0           @ No overflow

end:
```

---

## B (Always) - Unconditional Branch

```arm
.global _start
_start:
    mov r0, #1
    b skip          @ Always jump, no condition
    mov r1, #2      @ This line NEVER runs!

skip:
    mov r2, #3      @ This runs

end:
```

---

# Quick Reference Chart

```
COMPARING TWO VALUES:
│
├── EQUAL?
│   ├── BEQ → if (a == b)
│   └── BNE → if (a != b)
│
├── SIGNED NUMBERS (can be negative)
│   ├── BGT → if (a > b)
│   ├── BLT → if (a < b)
│   ├── BGE → if (a >= b)
│   └── BLE → if (a <= b)
│
├── UNSIGNED NUMBERS (always positive)
│   ├── BHI → if (a > b)
│   ├── BLS → if (a <= b)
│   ├── BCS → if (a >= b)
│   └── BCC → if (a < b)
│
└── SPECIAL CHECKS
    ├── BMI → if (result < 0)
    ├── BPL → if (result >= 0)
    ├── BVS → if (overflow)
    └── BVC → if (no overflow)
```

---

# Summary

```
REMEMBER:
│
├── CMP sets flags (does not save result)
│
├── B<condition> <label> → Jump if condition is true
│
├── Always add "b end" to skip other blocks
│
├── SIGNED: GT, LT, GE, LE (for negative numbers)
│
└── UNSIGNED: HI, LS, CS, CC (for positive only)
```

---
