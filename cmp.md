# ARM Assembly CMP Instruction Tutorial 📚

## What is CMP?

CMP means **Compare**. It compares two values by doing subtraction.

```
cmp r1, r2   →   This does: r1 - r2
```

**Important:** CMP does NOT save the result. It only updates the **flags**.

---

## What is CPSR Register?

CPSR = **Current Program Status Register**

It stores **flags** that tell us about the result.

### The 4 Important Flags (Top 4 bits of CPSR)

```
Bit Position:  31   30   29   28   27-0
Flag Name:     N    Z    C    V    (other bits)
```

| Flag | Name | Meaning |
|------|------|---------|
| N | Negative | Result is negative |
| Z | Zero | Result is zero |
| C | Carry | No borrow was needed |
| V | Overflow | Signed overflow happened |

### CPSR in Binary (32-bit)

```
NZCV .... .... .... .... .... .... ....
│││└─ Overflow
││└── Carry
│└─── Zero
└──── Negative
```

---

## Case 1: r1 > r2 (Positive Result)

### Code
```assembly
.global _start
_start:
    mov r1, #4
    mov r2, #2
    cmp r1, r2    @ Does: 4 - 2 = 2
```

### What Happens?

```
BEFORE CMP:
┌─────────────────────────────────────────────────┐
│ R1 = 00000000 00000000 00000000 00000100  (= 4) │
│ R2 = 00000000 00000000 00000000 00000010  (= 2) │
└─────────────────────────────────────────────────┘

CMP does: R1 - R2 = 4 - 2 = 2 (Positive!)

AFTER CMP:
┌─────────────────────────────────────────────────┐
│ CPSR = 0x200001D3                               │
│      = 00100000 00000000 00000001 11010011      │
│        ↑↑↑↑                                     │
│        NZCV                                     │
│        0010 → Only C flag is set                │
└─────────────────────────────────────────────────┘
```

### Flags Set

| Flag | Value | Why? |
|------|-------|------|
| N | 0 | Result (2) is NOT negative |
| Z | 0 | Result (2) is NOT zero |
| **C** | **1** | **No borrow needed (4 is bigger than 2)** |
| V | 0 | No overflow |

### Simple Rule
```
When r1 > r2 → C flag = 1 (Carry set)
```

---

## Case 2: r1 == r2 (Equal)

### Code
```assembly
.global _start
_start:
    mov r1, #2
    mov r2, #2
    cmp r1, r2    @ Does: 2 - 2 = 0
```

### What Happens?

```
BEFORE CMP:
┌─────────────────────────────────────────────────┐
│ R1 = 00000000 00000000 00000000 00000010  (= 2) │
│ R2 = 00000000 00000000 00000000 00000010  (= 2) │
└─────────────────────────────────────────────────┘

CMP does: R1 - R2 = 2 - 2 = 0 (Zero!)

AFTER CMP:
┌─────────────────────────────────────────────────┐
│ CPSR = 0x600001D3                               │
│      = 01100000 00000000 00000001 11010011      │
│        ↑↑↑↑                                     │
│        NZCV                                     │
│        0110 → Z and C flags are set             │
└─────────────────────────────────────────────────┘
```

### Flags Set

| Flag | Value | Why? |
|------|-------|------|
| N | 0 | Result (0) is NOT negative |
| **Z** | **1** | **Result is ZERO (equal!)** |
| **C** | **1** | **No borrow needed (same numbers)** |
| V | 0 | No overflow |

### Simple Rule
```
When r1 == r2 → Z flag = 1 (Zero set)
                C flag = 1 (Carry set)
```

---

## Case 3: r1 < r2 (Negative Result)

### Code
```assembly
.global _start
_start:
    mov r1, #2
    mov r2, #4
    cmp r1, r2    @ Does: 2 - 4 = -2
```

### What Happens?

```
BEFORE CMP:
┌─────────────────────────────────────────────────┐
│ R1 = 00000000 00000000 00000000 00000010  (= 2) │
│ R2 = 00000000 00000000 00000000 00000100  (= 4) │
└─────────────────────────────────────────────────┘

CMP does: R1 - R2 = 2 - 4 = -2 (Negative!)

AFTER CMP:
┌─────────────────────────────────────────────────┐
│ CPSR = 0x800001D3                               │
│      = 10000000 00000000 00000001 11010011      │
│        ↑↑↑↑                                     │
│        NZCV                                     │
│        1000 → Only N flag is set                │
└─────────────────────────────────────────────────┘
```

### Flags Set

| Flag | Value | Why? |
|------|-------|------|
| **N** | **1** | **Result (-2) IS negative** |
| Z | 0 | Result (-2) is NOT zero |
| C | 0 | Borrow WAS needed (2 is smaller than 4) |
| V | 0 | No overflow |

### Simple Rule
```
When r1 < r2 → N flag = 1 (Negative set)
               C flag = 0 (Borrow happened)
```

---

## Case 4: V Flag (Overflow Example)

### What is Overflow?

Overflow happens when the result is **too big** or **too small** for 32 bits (signed numbers).

### Code
```assembly
.global _start
_start:
    ldr r1, =0x80000000    @ Smallest negative: -2147483648
    mov r2, #1              @ Positive: 1
    cmp r1, r2              @ Does: -2147483648 - 1
```

### What Happens?

```
BEFORE CMP:
┌─────────────────────────────────────────────────────────┐
│ R1 = 10000000 00000000 00000000 00000000                │
│      (= 0x80000000 = -2147483648 in signed)             │
│                                                         │
│ R2 = 00000000 00000000 00000000 00000001                │
│      (= 0x00000001 = 1)                                 │
└─────────────────────────────────────────────────────────┘

CMP does: R1 - R2 = -2147483648 - 1 = ???

Expected: -2147483649 (but this is TOO SMALL for 32-bit!)

Actual Result: 0x7FFFFFFF = +2147483647 (WRONG! Overflow!)

AFTER CMP:
┌─────────────────────────────────────────────────────────┐
│ CPSR = 0x300001D3                                       │
│      = 00110000 00000000 00000001 11010011              │
│        ↑↑↑↑                                             │
│        NZCV                                             │
│        0011 → C and V flags are set                     │
└─────────────────────────────────────────────────────────┘
```

### Flags Set

| Flag | Value | Why? |
|------|-------|------|
| N | 0 | Result looks positive (wrong due to overflow) |
| Z | 0 | Result is NOT zero |
| **C** | **1** | No borrow in unsigned math |
| **V** | **1** | **OVERFLOW! Result wrapped around** |

### Simple Rule
```
V flag = 1 when:
- Negative - Positive = Positive (wrong!)
- Positive - Negative = Negative (wrong!)
```

---

## Quick Summary Table

| Condition | N | Z | C | V |
|-----------|---|---|---|---|
| r1 > r2 | 0 | 0 | **1** | 0 |
| r1 == r2 | 0 | **1** | **1** | 0 |
| r1 < r2 | **1** | 0 | 0 | 0 |
| Overflow | ? | 0 | ? | **1** |

---

## Visual Diagram

```
         CMP R1, R2
              │
              ▼
        ┌───────────┐
        │  R1 - R2  │ (subtraction happens)
        └─────┬─────┘
              │
              ▼
    ┌─────────────────────┐
    │   Update CPSR Flags │
    │   ┌───┬───┬───┬───┐ │
    │   │ N │ Z │ C │ V │ │
    │   └───┴───┴───┴───┘ │
    └─────────────────────┘
              │
              ▼
     Result is NOT saved!
     Only flags change!
```

---

## Remember! 

1. **CMP = Subtract but don't save**
2. **N = 1** → Result is Negative (r1 < r2)
3. **Z = 1** → Result is Zero (r1 == r2)
4. **C = 1** → No borrow needed (r1 >= r2)
5. **V = 1** → Overflow (result too big/small)