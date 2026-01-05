# Complete Beginner-Friendly Notes: Negative Numbers, 2's Complement, and ARM Shift Operations

## 1️⃣ **How Negative Numbers Work (Two's Complement)**

### Why We Need Two's Complement
- Computers don't have a minus sign key in binary
- They use **2's complement** to represent negative numbers
- This allows addition/subtraction using the same hardware

### **Steps to Convert to Negative (Two's Complement)**

1. **Write the positive number in binary**
2. **Invert all bits (0→1, 1→0)** 
3. **Add 1**

### **Example: Converting 40 to -40 (32-bit)**

```
Step 1: 40 in binary
00000000 00000000 00000000 00101000

Step 2: Invert all bits
11111111 11111111 11111111 11010111

Step 3: Add 1
11111111 11111111 11111111 11011000  ← This is -40!
```

**In ARM Assembly:**
```assembly
MOV r0, #-40  ; Assembler converts to 2's complement automatically
```

---

## 2️⃣ **Logical Shift Left (LSL) - Multiplication**

### What It Does:
- Shifts bits **left**
- Fills right side with **0s**
- Each shift = **multiply by 2**

### **32-bit Example: 40 × 2^n**

```assembly
MOV r0, #40     ; Start with 40
LSL r0, r0, #1  ; Shift left by 1
```

**Step-by-step visualization:**
```
Initial: 00000000 00000000 00000000 00101000 = 40
LSL #1:  00000000 00000000 00000000 01010000 = 80
LSL #2:  00000000 00000000 00000001 01000000 = 160
LSL #3:  00000000 00000000 00000010 10000000 = 320
...continuing shifts multiply by 2 each time
```

⚠️ **Warning:** Bits that shift out are **lost forever** (overflow)

---

## 3️⃣ **Logical Shift Right (LSR) - Unsigned Division**

### What It Does:
- Shifts bits **right**
- Fills left side with **0s**
- Each shift = **divide by 2** (unsigned)

### **Complete 32-bit Example with Your Code:**

```assembly
MOV r0, #40
LSR r0, r0, #1  ; First shift
LSR r0, r0, #1  ; Second shift
LSR r0, r0, #1  ; Third shift
LSR r0, r0, #1  ; Fourth shift
LSR r0, r0, #1  ; Fifth shift
```

**Full Binary Trace:**

| Step | Operation | 32-bit Binary | Decimal |
|------|-----------|--------------|---------|
| 0 | MOV r0, #40 | `00000000 00000000 00000000 00101000` | 40 |
| 1 | LSR #1 | `00000000 00000000 00000000 00010100` | 20 |
| 2 | LSR #1 | `00000000 00000000 00000000 00001010` | 10 |
| 3 | LSR #1 | `00000000 00000000 00000000 00000101` | 5 |
| 4 | LSR #1 | `00000000 00000000 00000000 00000010` | 2 |
| 5 | LSR #1 | `00000000 00000000 00000000 00000001` | 1 |

📌 **Note:** When 5→2, the rightmost `1` bit is discarded (no rounding!)

---

## 4️⃣ **Arithmetic Shift Right (ASR) - Signed Division**

### The Problem with LSR on Negative Numbers:
LSR fills with 0s, which **breaks negative numbers**!

### ASR Solution:
- Preserves the **sign bit** (leftmost bit)
- Fills with 1s if negative, 0s if positive

### **Example: -40 divided by 2**

```assembly
MOV r0, #-40
ASR r0, r0, #1
```

**Binary visualization:**
```
-40:     11111111 11111111 11111111 11011000
ASR #1:  11111111 11111111 11111111 11101100 = -20
ASR #2:  11111111 11111111 11111111 11110110 = -10
```

The **sign bit (1) is preserved**!

---

## 5️⃣ **Rotate Right (ROR) - Bit Mixing**

### What Rotate Means:
- Bits don't disappear
- Bits that "fall off" the right come back on the left
- **Circular shift**

### **32-bit Example:**
```assembly
MOV r0, #0x81    ; Binary: 10000001
ROR r0, r0, #1
```

**Visualization:**
```
Before: 00000000 00000000 00000000 10000001
After:  10000000 00000000 00000000 11000000
        ↑ This bit came from the right side!
```

### Common Uses:
- **Encryption algorithms**
- **Hash functions**
- **Obfuscation in malware**

---

## 6️⃣ **RRX (Rotate Right with Extend)**

### Special Feature:
Uses the **carry flag** from CPSR register

```assembly
RRX r0, r0
```

**How it works:**
```
[Carry] → [Bit 31] → [Bit 30] → ... → [Bit 0] → [Carry]
```

This creates **unpredictable patterns** - perfect for cryptography!

---

## 7️⃣ **Shift Amount: Immediate vs Register**

### **Immediate (Fixed):**
```assembly
LSL r0, r0, #3  ; Always shift by 3
```

### **Register (Variable):**
```assembly
MOV r1, #3
LSL r0, r0, r1  ; Shift amount from r1
```

**Why use register?**
- Dynamic shifts in loops
- Runtime-determined values
- Encryption algorithms

---

## 8️⃣ **Quick Reference Table**

| Instruction | Full Name | Effect | Common Use |
|------------|-----------|---------|------------|
| **LSL** | Logical Shift Left | × 2^n | Fast multiplication |
| **LSR** | Logical Shift Right | ÷ 2^n (unsigned) | Unsigned division |
| **ASR** | Arithmetic Shift Right | ÷ 2^n (signed) | Signed division |
| **ROR** | Rotate Right | Circular shift | Crypto, checksums |
| **RRX** | Rotate Right Extended | Rotate with carry | Advanced crypto |

---

## 9️⃣ **Reverse Engineering Tips**

### Pattern Recognition:

**Multiple LSLs:**
```assembly
LSL r0, r0, #1
LSL r0, r0, #1
LSL r0, r0, #1
```
= Multiply by 8 (2³)

**Multiple LSRs:**
```assembly
LSR r0, r0, #1
LSR r0, r0, #1
```
= Divide by 4 (2²)

**ROR/RRX patterns:**
= Probably encryption or obfuscation

---

## 🔥 **Practice Exercise**

Try predicting the output:
```assembly
MOV r0, #-16
ASR r0, r0, #2  ; What's the result?
```

**Answer:** -16 ÷ 4 = -4

Binary proof:
```
-16: 11111111 11111111 11111111 11110000
ASR #2: 11111111 11111111 11111111 11111100 = -4
```

---

## 📌 **Key Takeaways**

1. **2's complement** = how computers store negative numbers
2. **LSL** = multiply by powers of 2
3. **LSR** = unsigned divide (breaks negatives!)
4. **ASR** = signed divide (preserves sign)
5. **ROR/RRX** = crypto and obfuscation
6. Lost bits in shifts are **gone forever**
7. Compilers use shifts instead of MUL/DIV for speed
