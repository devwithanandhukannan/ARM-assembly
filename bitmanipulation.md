# ARM Assembly: Negative Numbers & Bit Shifting Tutorial 📚

## Table of Contents
1. [Two's Complement (Negative Numbers)](#1-twos-complement---negative-numbers)
2. [Logical Shift Left (LSL)](#2-logical-shift-left-lsl---multiply)
3. [Logical Shift Right (LSR)](#3-logical-shift-right-lsr---unsigned-divide)
4. [Arithmetic Shift Right (ASR)](#4-arithmetic-shift-right-asr---signed-divide)
5. [Rotate Right (ROR)](#5-rotate-right-ror---bit-mixing)
6. [Rotate Right Extended (RRX)](#6-rotate-right-extended-rrx)
7. [Immediate vs Register Shift](#7-shift-amount-immediate-vs-register)
8. [Quick Reference Table](#8-quick-reference-table)
9. [Reverse Engineering Tips](#9-reverse-engineering-tips)

---

## 1. Two's Complement - Negative Numbers

### Why Do We Need This?

```
Problem: Computers only understand 0 and 1
         There is NO minus sign (-) in binary!

Solution: Two's Complement
          A clever trick to represent negative numbers
```

### The 3 Steps to Make a Negative Number

```
┌─────────────────────────────────────────────┐
│  Step 1: Write positive number in binary    │
│  Step 2: Flip all bits (0→1, 1→0)          │
│  Step 3: Add 1                              │
└─────────────────────────────────────────────┘
```

### Example: Convert 40 to -40 (32-bit)

#### Step 1: Write 40 in Binary
```
40 in decimal = 00000000 00000000 00000000 00101000

How to calculate:
40 = 32 + 8 = 2^5 + 2^3

Bit positions:  ... 7  6  5  4  3  2  1  0
Values:         ... 0  0  1  0  1  0  0  0
                       ↑     ↑
                      32  +  8  = 40
```

#### Step 2: Flip All Bits (Invert)
```
Original:  00000000 00000000 00000000 00101000
           ↓↓↓↓↓↓↓↓ ↓↓↓↓↓↓↓↓ ↓↓↓↓↓↓↓↓ ↓↓↓↓↓↓↓↓
Flipped:   11111111 11111111 11111111 11010111

Rule: Every 0 becomes 1
      Every 1 becomes 0
```

#### Step 3: Add 1
```
Flipped:   11111111 11111111 11111111 11010111
                                            +1
           ─────────────────────────────────────
Result:    11111111 11111111 11111111 11011000  ← This is -40!
```

### Visual Summary
```
┌──────────────────────────────────────────────────────────────┐
│                    40 → -40 Conversion                        │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   +40 = 00000000 00000000 00000000 00101000                 │
│          ↓ FLIP ALL BITS                                     │
│         11111111 11111111 11111111 11010111                  │
│          ↓ ADD 1                                             │
│   -40 = 11111111 11111111 11111111 11011000                 │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### In ARM Assembly
```assembly
MOV r0, #-40    @ Assembler does 2's complement automatically!

@ r0 now contains: 11111111 11111111 11111111 11011000
@ Which is: 0xFFFFFFD8
```

### How to Know if a Number is Negative?
```
Look at bit 31 (the leftmost bit):

┌─────────────────────────────────────────────────┐
│  Bit 31 = 0  →  Number is POSITIVE             │
│  Bit 31 = 1  →  Number is NEGATIVE             │
└─────────────────────────────────────────────────┘

Examples:
00000000 00000000 00000000 00101000 = +40 (bit 31 = 0)
↑
bit 31

11111111 11111111 11111111 11011000 = -40 (bit 31 = 1)
↑
bit 31
```

---

## 2. Logical Shift Left (LSL) - Multiply

### What Does LSL Do?

```
┌─────────────────────────────────────────────┐
│  LSL = Push bits to the LEFT               │
│  Empty spaces on RIGHT fill with 0         │
│  Each shift = MULTIPLY by 2                │
└─────────────────────────────────────────────┘
```

### Visual Diagram
```
Before LSL #1:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 0 │ 0 │ 1 │ 0 │ 1 │ 0 │ 0 │ 0 │  = 40
└───┴───┴───┴───┴───┴───┴───┴───┘
  ↓   ↓   ↓   ↓   ↓   ↓   ↓   ↓
  ←   ←   ←   ←   ←   ←   ←   ←  (shift left)
  
After LSL #1:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 0 │ 1 │ 0 │ 1 │ 0 │ 0 │ 0 │ 0 │  = 80
└───┴───┴───┴───┴───┴───┴───┴───┘
                              ↑
                          New 0 added
```

### Code Example
```assembly
.global _start
_start:
    MOV r0, #40      @ r0 = 40
    LSL r0, r0, #1   @ r0 = 40 × 2 = 80
```

### Complete 32-bit Trace: 40 × 2^n

| Step | Code | 32-bit Binary | Decimal | Math |
|------|------|---------------|---------|------|
| 0 | MOV r0, #40 | 00000000 00000000 00000000 00101000 | 40 | Start |
| 1 | LSL r0, r0, #1 | 00000000 00000000 00000000 01010000 | 80 | 40×2 |
| 2 | LSL r0, r0, #1 | 00000000 00000000 00000000 10100000 | 160 | 80×2 |
| 3 | LSL r0, r0, #1 | 00000000 00000000 00000001 01000000 | 320 | 160×2 |
| 4 | LSL r0, r0, #1 | 00000000 00000000 00000010 10000000 | 640 | 320×2 |

### Step-by-Step Visualization
```
Step 0: MOV r0, #40
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00101000 = 40                       │
└────────────────────────────────────────────────────────────────┘

Step 1: LSL r0, r0, #1
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 01010000 = 80                       │
│                                   ↑                             │
│                               new 0                             │
└────────────────────────────────────────────────────────────────┘

Step 2: LSL r0, r0, #1
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 10100000 = 160                      │
└────────────────────────────────────────────────────────────────┘

Step 3: LSL r0, r0, #1
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000001 01000000 = 320                      │
│                         ↑                                       │
│                    bit moved here                               │
└────────────────────────────────────────────────────────────────┘
```

### ⚠️ Warning: Overflow!
```
If a 1 bit shifts out from the left side, it is LOST!

Before: 11000000 00000000 00000000 00000001
        ↑
        This bit will be lost!
        
LSL #1: 10000000 00000000 00000000 00000010
        ↑
        Gone forever! (This is called OVERFLOW)
```

---

## 3. Logical Shift Right (LSR) - Unsigned Divide

### What Does LSR Do?

```
┌─────────────────────────────────────────────┐
│  LSR = Push bits to the RIGHT              │
│  Empty spaces on LEFT fill with 0          │
│  Each shift = DIVIDE by 2 (unsigned)       │
└─────────────────────────────────────────────┘
```

### Visual Diagram
```
Before LSR #1:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 0 │ 0 │ 1 │ 0 │ 1 │ 0 │ 0 │ 0 │  = 40
└───┴───┴───┴───┴───┴───┴───┴───┘
  ↓   ↓   ↓   ↓   ↓   ↓   ↓   ↓
  →   →   →   →   →   →   →   →  (shift right)
  
After LSR #1:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 0 │ 0 │ 0 │ 1 │ 0 │ 1 │ 0 │ 0 │  = 20
└───┴───┴───┴───┴───┴───┴───┴───┘
  ↑
New 0 added                     bit 0 lost →
```

### Code Example
```assembly
.global _start
_start:
    MOV r0, #40      @ r0 = 40
    LSR r0, r0, #1   @ r0 = 40 ÷ 2 = 20
    LSR r0, r0, #1   @ r0 = 20 ÷ 2 = 10
    LSR r0, r0, #1   @ r0 = 10 ÷ 2 = 5
    LSR r0, r0, #1   @ r0 = 5 ÷ 2 = 2 (remainder lost!)
    LSR r0, r0, #1   @ r0 = 2 ÷ 2 = 1
```

### Complete 32-bit Trace: 40 ÷ 2^n

| Step | Code | 32-bit Binary | Decimal | Math |
|------|------|---------------|---------|------|
| 0 | MOV r0, #40 | 00000000 00000000 00000000 00101000 | 40 | Start |
| 1 | LSR r0, r0, #1 | 00000000 00000000 00000000 00010100 | 20 | 40÷2 |
| 2 | LSR r0, r0, #1 | 00000000 00000000 00000000 00001010 | 10 | 20÷2 |
| 3 | LSR r0, r0, #1 | 00000000 00000000 00000000 00000101 | 5 | 10÷2 |
| 4 | LSR r0, r0, #1 | 00000000 00000000 00000000 00000010 | 2 | 5÷2 ❗ |
| 5 | LSR r0, r0, #1 | 00000000 00000000 00000000 00000001 | 1 | 2÷2 |

### Step-by-Step Visualization
```
Step 0: MOV r0, #40
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00101000 = 40                       │
└────────────────────────────────────────────────────────────────┘

Step 1: LSR r0, r0, #1  (40 ÷ 2 = 20)
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00010100 = 20                       │
│ ↑                                                         → 0  │
│ new 0                                              (bit lost)  │
└────────────────────────────────────────────────────────────────┘

Step 2: LSR r0, r0, #1  (20 ÷ 2 = 10)
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00001010 = 10                       │
└────────────────────────────────────────────────────────────────┘

Step 3: LSR r0, r0, #1  (10 ÷ 2 = 5)
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00000101 = 5                        │
└────────────────────────────────────────────────────────────────┘

Step 4: LSR r0, r0, #1  (5 ÷ 2 = 2, remainder 1 LOST!)
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00000010 = 2                        │
│                                                          → 1   │
│                                              (remainder lost!) │
└────────────────────────────────────────────────────────────────┘

Step 5: LSR r0, r0, #1  (2 ÷ 2 = 1)
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 00000001 = 1                        │
└────────────────────────────────────────────────────────────────┘
```

### 📌 Important Note
```
┌────────────────────────────────────────────────────────────────┐
│  NO ROUNDING!                                                   │
│                                                                 │
│  5 ÷ 2 = 2.5 → but LSR gives us 2                             │
│                                                                 │
│  The remainder (0.5) is simply thrown away!                    │
│  This is called "truncation" or "floor division"               │
└────────────────────────────────────────────────────────────────┘
```

---

## 4. Arithmetic Shift Right (ASR) - Signed Divide

### The Problem with LSR on Negative Numbers

```
LSR fills with 0s on the left side.
This BREAKS negative numbers!

Example:
-40 = 11111111 11111111 11111111 11011000

If we use LSR #1:
      01111111 11111111 11111111 11101100 = +2,147,483,628 (WRONG!)
      ↑
      0 was inserted (destroyed the negative sign!)
```

### ASR is the Solution!

```
┌─────────────────────────────────────────────────────────────┐
│  ASR = Arithmetic Shift Right                               │
│  KEEPS the sign bit (bit 31)                                │
│  If negative → fills with 1s                                │
│  If positive → fills with 0s                                │
└─────────────────────────────────────────────────────────────┘
```

### Visual Diagram
```
ASR on Negative Number:
                    Sign bit preserved!
                    ↓
Before: [1]1111111 11111111 11111111 11011000 = -40
         ↓
After:  [1]1111111 11111111 11111111 11101100 = -20
         ↑
         Sign bit COPIED (not replaced with 0!)

ASR on Positive Number:
                    Sign bit preserved!
                    ↓
Before: [0]0000000 00000000 00000000 00101000 = +40
         ↓
After:  [0]0000000 00000000 00000000 00010100 = +20
         ↑
         Sign bit COPIED (stays 0)
```

### Code Example
```assembly
.global _start
_start:
    MOV r0, #-40     @ r0 = -40
    ASR r0, r0, #1   @ r0 = -40 ÷ 2 = -20
    ASR r0, r0, #1   @ r0 = -20 ÷ 2 = -10
```

### Complete 32-bit Trace: -40 ÷ 2^n

| Step | Code | 32-bit Binary | Decimal | Math |
|------|------|---------------|---------|------|
| 0 | MOV r0, #-40 | 11111111 11111111 11111111 11011000 | -40 | Start |
| 1 | ASR r0, r0, #1 | 11111111 11111111 11111111 11101100 | -20 | -40÷2 |
| 2 | ASR r0, r0, #1 | 11111111 11111111 11111111 11110110 | -10 | -20÷2 |
| 3 | ASR r0, r0, #1 | 11111111 11111111 11111111 11111011 | -5 | -10÷2 |

### Step-by-Step Visualization
```
Step 0: MOV r0, #-40
┌────────────────────────────────────────────────────────────────┐
│ 11111111 11111111 11111111 11011000 = -40                      │
│ ↑                                                               │
│ Sign bit = 1 (negative)                                        │
└────────────────────────────────────────────────────────────────┘

Step 1: ASR r0, r0, #1  (-40 ÷ 2 = -20)
┌────────────────────────────────────────────────────────────────┐
│ 11111111 11111111 11111111 11101100 = -20                      │
│ ↑↑                                                              │
│ │└─ New 1 copied from sign bit!                                │
│ └── Original sign bit                                          │
└────────────────────────────────────────────────────────────────┘

Step 2: ASR r0, r0, #1  (-20 ÷ 2 = -10)
┌────────────────────────────────────────────────────────────────┐
│ 11111111 11111111 11111111 11110110 = -10                      │
│ ↑                                                               │
│ Sign preserved!                                                 │
└────────────────────────────────────────────────────────────────┘
```

### LSR vs ASR Comparison

```
┌──────────────────────────────────────────────────────────────────┐
│                    -40 ÷ 2 Comparison                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Original -40:  11111111 11111111 11111111 11011000              │
│                                                                  │
│  Using LSR #1:  01111111 11111111 11111111 11101100              │
│                 ↑                                                │
│                 0 inserted = WRONG! (+2,147,483,628)             │
│                                                                  │
│  Using ASR #1:  11111111 11111111 11111111 11101100              │
│                 ↑                                                │
│                 1 preserved = CORRECT! (-20)                     │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### When to Use Which?

```
┌─────────────────────────────────────────────────────────┐
│  Unsigned numbers (0 and positive only) → Use LSR     │
│  Signed numbers (positive AND negative) → Use ASR     │
└─────────────────────────────────────────────────────────┘
```

---

## 5. Rotate Right (ROR) - Bit Mixing

### What Does ROR Do?

```
┌─────────────────────────────────────────────────────────────┐
│  ROR = Rotate Right                                         │
│  Bits that "fall off" the RIGHT come back on the LEFT      │
│  NO bits are lost! (Circular movement)                      │
└─────────────────────────────────────────────────────────────┘
```

### Visual Diagram (8-bit for simplicity)
```
Before ROR #1:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 1 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ 1 │  = 0x81
└───┴───┴───┴───┴───┴───┴───┴───┘
                              ↓
                        This bit falls off...

After ROR #1:
┌───┬───┬───┬───┬───┬───┬───┬───┐
│ 1 │ 1 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │  = 0xC0
└───┴───┴───┴───┴───┴───┴───┴───┘
  ↑
  ...and comes back here!
```

### Code Example
```assembly
.global _start
_start:
    MOV r0, #0x81     @ r0 = 10000001 (binary)
    ROR r0, r0, #1    @ Rotate right by 1
```

### Complete 32-bit Trace

```
Step 0: MOV r0, #0x81
┌────────────────────────────────────────────────────────────────┐
│ 00000000 00000000 00000000 10000001 = 0x00000081               │
│                                    ↑                            │
│                              This bit (1) will rotate          │
└────────────────────────────────────────────────────────────────┘

Step 1: ROR r0, r0, #1
┌────────────────────────────────────────────────────────────────┐
│ 10000000 00000000 00000000 01000000 = 0x80000040               │
│ ↑                                                               │
│ The bit came back here!                                        │
└────────────────────────────────────────────────────────────────┘
```

### More ROR Examples

```
┌───────────────────────────────────────────────────────────────────┐
│                     ROR r0, r0, #4                                │
├───────────────────────────────────────────────────────────────────┤
│                                                                   │
│ Before: 00000000 00000000 00000000 11110000 = 0x000000F0         │
│                                    ↑↑↑↑                           │
│                              These 4 bits rotate                  │
│                                                                   │
│ After:  00000000 00000000 00000000 00001111 = 0x0000000F         │
│                                         ↑↑↑↑                      │
│                                   Came back here                  │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

### ROR Circle Visualization
```
Imagine bits on a circle:

        ← Direction of rotation
        
           bit 31
             ↓
        ╭─────────╮
       ╱           ╲
      │  00000000   │
      │  00000000   │
      │  00000000   │
      │  10000001   │
       ╲           ╱
        ╰─────────╯
             ↑
           bit 0
           
After ROR #1, bit 0 moves to bit 31 position!
```

### Common Uses
```
┌─────────────────────────────────────────────────────────┐
│  • Encryption algorithms (AES, etc.)                    │
│  • Hash functions (SHA, MD5)                            │
│  • Checksums                                            │
│  • Malware obfuscation (hiding code)                   │
└─────────────────────────────────────────────────────────┘
```

---

## 6. Rotate Right Extended (RRX)

### What is RRX?

```
┌─────────────────────────────────────────────────────────────┐
│  RRX = Special 33-bit rotate                                │
│  Uses the Carry flag (C) from CPSR register                │
│  Creates a 33-bit rotation (32 bits + Carry)               │
└─────────────────────────────────────────────────────────────┘
```

### How RRX Works
```
      ┌─────────┐
      │ Carry   │ ←── CPSR Carry Flag (1 bit)
      └────┬────┘
           ↓
    ┌──────────────────────────────────────────────────┐
    │ Bit31 Bit30 ... Bit2 Bit1 Bit0 │ Carry │→ Out   │
    └──────────────────────────────────────────────────┘
           ↓     ↓        ↓    ↓      ↓
    ┌───────────────────────────────────────────��──────┐
    │ Carry Bit31 ... Bit3 Bit2 Bit1 │ New C │← Bit0  │
    └──────────────────────────────────────────────────┘
```

### Step-by-Step Visualization
```
Before RRX:
┌───────────────────────────────────────────────────────────────┐
│  Carry = 1                                                    │
│  R0 = 10000000 00000000 00000000 00000000                    │
│       ↑                                                       │
│       bit 31                                                  │
└───────────────────────────────────────────────────────────────┘

After RRX r0, r0:
┌───────────────────────────────────────────────────────────────┐
│  Carry = 0 (old bit 0)                                        │
│  R0 = 11000000 00000000 00000000 00000000                    │
│       ↑↑                                                      │
│       │└── old bit 31                                         │
│       └─── old Carry (was 1)                                  │
└───────────────────────────────────────────────────────────────┘
```

### Code Example
```assembly
.global _start
_start:
    MOV r0, #0x80000000   @ r0 = 10000000...
    
    @ First, set the Carry flag
    MOVS r1, #0xFFFFFFFF  @ This will set Carry = 1
    ADDS r1, r1, #1       @ Add to create carry
    
    RRX r0, r0            @ Rotate with Carry
```

### RRX vs ROR Comparison

```
┌────────────────────────────────────────────────────────────────┐
│                        ROR vs RRX                              │
├──────────────────────────────────────────┬─────────────────────┤
│              ROR                         │        RRX          │
├──────────────────────────────────────────┼─────────────────────┤
│  32-bit rotation                         │  33-bit rotation    │
│  Bit 0 → Bit 31                          │  Bit 0 → Carry      │
│  No carry involved                       │  Carry → Bit 31     │
│  Predictable                             │  Depends on flags   │
└──────────────────────────────────────────┴─────────────────────┘
```

### Why is RRX Useful?
```
┌─────────────────────────────────────────────────────────────┐
│  • Multi-word arithmetic (numbers bigger than 32 bits)      │
│  • Cryptography (unpredictable patterns)                    │
│  • Chaining operations together                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Shift Amount: Immediate vs Register

### Two Ways to Specify Shift Amount

#### Method 1: Immediate (Fixed Number)
```assembly
LSL r0, r0, #3    @ Always shift by exactly 3

@ The #3 is "hardcoded" - it never changes
```

#### Method 2: Register (Variable Number)
```assembly
MOV r1, #3
LSL r0, r0, r1    @ Shift by whatever value is in r1

@ The shift amount can change at runtime!
```

### Comparison Table

| Feature | Immediate (#n) | Register (Rn) |
|---------|----------------|---------------|
| Syntax | `LSL r0, r0, #3` | `LSL r0, r0, r1` |
| Value | Fixed at compile time | Can change at runtime |
| Range | 0-31 | 0-255 (uses bottom 8 bits) |
| Speed | Slightly faster | Slightly slower |
| Use case | Known shift amounts | Dynamic/calculated shifts |

### Register Shift Example

```assembly
.global _start
_start:
    MOV r0, #8        @ Number to shift
    MOV r1, #0        @ Shift amount (will change)
    
loop:
    LSL r2, r0, r1    @ Shift r0 by r1 positions
    ADD r1, r1, #1    @ Increase shift amount
    CMP r1, #5        @ Loop 5 times
    BLT loop          @ Branch if less than 5
```

### Trace of Above Code

| Loop | r0 | r1 | r2 = r0 << r1 | r2 value |
|------|----|----|---------------|----------|
| 1 | 8 | 0 | 8 << 0 | 8 |
| 2 | 8 | 1 | 8 << 1 | 16 |
| 3 | 8 | 2 | 8 << 2 | 32 |
| 4 | 8 | 3 | 8 << 3 | 64 |
| 5 | 8 | 4 | 8 << 4 | 128 |

### When to Use Which?

```
┌─────────────────────────────────────────────────────────────────┐
│  Use IMMEDIATE when:                                            │
│  • You know the exact shift amount                              │
│  • Multiplying/dividing by known powers of 2                   │
│  • Example: x * 8 = LSL #3                                     │
├─────────────────────────────────────────────────────────────────┤
│  Use REGISTER when:                                             │
│  • Shift amount is calculated at runtime                        │
│  • Loops with variable shifts                                   │
│  • Encryption algorithms                                        │
│  • Bit manipulation with dynamic positions                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 8. Quick Reference Table

| Instruction | Full Name | Direction | Fill With | Effect | Common Use |
|-------------|-----------|-----------|-----------|--------|------------|
| **LSL** | Logical Shift Left | ← Left | 0s on right | × 2^n | Fast multiply |
| **LSR** | Logical Shift Right | → Right | 0s on left | ÷ 2^n (unsigned) | Unsigned divide |
| **ASR** | Arithmetic Shift Right | → Right | Sign bit | ÷ 2^n (signed) | Signed divide |
| **ROR** | Rotate Right | → Right | Bits wrap around | Circular | Crypto, hash |
| **RRX** | Rotate Right Extended | → Right | Carry flag | 33-bit rotate | Multi-word ops |

### Visual Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                         LSL (Shift Left)                        │
│  ┌───┬───┬───┬───┬───┬───┬───┬───┐                             │
│  │ ← │ ← │ ← │ ← │ ← │ ← │ ← │ 0 │  Zero fills from right     │
│  └───┴───┴───┴───┴───┴───┴───┴───┘                             │
├─────────────────────────────────────────────────────────────────┤
│                         LSR (Logical Shift Right)               │
│  ┌───┬───┬───┬───┬───┬───┬───┬───┐                             │
│  │ 0 │ → │ → │ → │ → │ → │ → │ → │  Zero fills from left      │
│  └───┴───┴───┴───┴───┴───┴───┴───┘                             │
├─────────────────────────────────────────────────────────────────┤
│                         ASR (Arithmetic Shift Right)            │
│  ┌───┬───┬───┬───┬───┬───┬───┬───┐                             │
│  │ S │ → │ → │ → │ → │ → │ → │ → │  Sign bit fills from left  │
│  └───┴───┴───┴───┴───┴───┴───┴───┘                             │
│    ↑                                                            │
│    S = Sign bit (copied)                                        │
├─────────────────────────────────────────────────────────────────┤
│                         ROR (Rotate Right)                      │
│  ┌───┬───┬───┬───┬───┬───┬───┬───┐                             │
│  │ ↵ │ → │ → │ → │ → │ → │ → │ → │↴ Wraps around               │
│  └───┴───┴───┴───┴───┴───┴───┴───┘                             │
│    ↑_____________________________|                              │
├─────────────────────────────────────────────────────────────────┤
│                         RRX (Rotate Right Extended)             │
│  ┌───┐   ┌───┬───┬───┬───┬───┬───┬───┬───┐                     │
│  │ C │ → │ → │ → │ → │ → │ → │ → │ → │ → │→ C (33-bit)        │
│  └───┘   └───┴───┴───┴───┴───┴───┴───┴───┘                     │
│    ↑                                                            │
│    Carry flag                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 9. Reverse Engineering Tips

### Pattern 1: Multiplication by Power of 2

```assembly
@ You see this code:
LSL r0, r0, #1
LSL r0, r0, #1
LSL r0, r0, #1

@ This means:
r0 = r0 × 2 × 2 × 2 = r0 × 8

@ Same as:
LSL r0, r0, #3    @ Multiply by 2³ = 8
```

### Pattern 2: Division by Power of 2

```assembly
@ You see this code:
LSR r0, r0, #1
LSR r0, r0, #1

@ This means:
r0 = r0 ÷ 2 ÷ 2 = r0 ÷ 4

@ Same as:
LSR r0, r0, #2    @ Divide by 2² = 4
```

### Pattern 3: Encryption/Obfuscation

```assembly
@ You see ROR or RRX patterns:
ROR r0, r0, #7
EOR r0, r0, r1
ROR r0, r0, #13

@ This usually means:
@ - Encryption algorithm
@ - Hash function
@ - Malware trying to hide data
```

### Pattern 4: Fast Multiply by Non-Power of 2

```assembly
@ Multiply by 10:
LSL r1, r0, #3    @ r1 = r0 × 8
LSL r2, r0, #1    @ r2 = r0 × 2
ADD r0, r1, r2    @ r0 = (r0 × 8) + (r0 × 2) = r0 × 10
```

### Pattern 5: Check if Number is Power of 2

```assembly
@ Common pattern:
SUB r1, r0, #1    @ r1 = n - 1
AND r2, r0, r1    @ r2 = n & (n-1)
CMP r2, #0        @ If zero, n is power of 2!
```

### Quick Cheat Sheet for Reverse Engineering

```
┌────────────────────────────────────────────────────────────────┐
│              What You See → What It Means                      │
├────────────────────────────────────────────────────────────────┤
│  LSL r0, r0, #n    →    r0 = r0 × 2^n                         │
│  LSR r0, r0, #n    →    r0 = r0 ÷ 2^n (unsigned)              │
│  ASR r0, r0, #n    →    r0 = r0 ÷ 2^n (signed)                │
│  Multiple RORs     →    Probably encryption                   │
│  RRX patterns      →    Advanced crypto or obfuscation        │
│  LSL + LSL + ADD   →    Multiply by non-power of 2            │
└────────────────────────────────────────────────────────────────┘
```

---

## Remember! 🧠

```
┌─────────────────────────────────────────────────────────────────┐
│  1. LSL = Multiply (fast × by powers of 2)                     │
│  2. LSR = Divide unsigned (bits fall off right)                │
│  3. ASR = Divide signed (keeps negative sign)                  │
│  4. ROR = Rotate (no bits lost, wrap around)                   │
│  5. RRX = Special rotate (uses Carry flag)                     │
│  6. Two's complement = How computers do negative numbers       │
│  7. Bit 31 = 1 means NEGATIVE                                  │
│  8. Shifts are MUCH faster than multiply/divide instructions   │
└─────────────────────────────────────────────────────────────────┘
```