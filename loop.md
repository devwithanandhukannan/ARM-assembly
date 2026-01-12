## 1. What is a Loop?

A **loop** lets you run the same code **many times**.

Example in real life:  
“Count from 0 to 4.”

You repeat:  
- Say the number  
- Add 1  
- Until you reach 5

In code, a loop does the same thing.

---

## 2. C Code Example (while loop)

```c
int i = 0;

while (i < 5) {
    i++;
}
```

### Explanation

- `int i = 0;` → start with i = 0
- `while (i < 5)` → repeat the block **as long as** i is less than 5
- `i++;` → increase i by 1 every time

Loop steps:
- Start: i = 0
- Check: is i < 5? yes → enter loop → i becomes 1
- Check: is i < 5? yes → enter loop → i becomes 2  
…
- When i = 5 → is i < 5? no → stop loop

Final value: `i = 5`

---

## 3. Same Idea in ARM Assembly (without loop at first)

C idea:

```c
int i = 0;
while (i < 5) {
    i++;
}
```

ARM assembly version (first version, only one pass, NOT a real loop):

```asm
    .global _start
_start:
    mov r0, #0       @ r0 is like variable i, set i = 0

    cmp r0, #5       @ compare r0 with 5  (i < 5 ?)
    bge end          @ if r0 >= 5, go to end (branch if greater or equal)

    add r0, r0, #1   @ r0 = r0 + 1   (i++)

end:
    mov r0, #2       @ just set r0 = 2 at the end (example)
```

This version only checks once and adds 1 once.  
It does **not** loop back to `cmp`. To make a real loop, we need a label and a branch back.

---

## 4. ARM Assembly with a Real Loop

Now we add a label `loop:` and branch back to it.

```asm
    .global _start
_start:
    mov r0, #0        @ i = 0

loop:
    cmp r0, #5        @ compare i with 5
    bge end           @ if i >= 5, exit loop (go to end)
    add r0, r0, #1    @ i = i + 1
    b   loop          @ go back to 'loop' label (repeat)

end:
    mov r0, #2        @ after loop finishes, set r0 = 2
```

### Step-by-step (like C while loop)

- Start: `r0 = 0`
- `loop:`  
  - compare r0 with 5  
  - if r0 >= 5 → jump to `end`  
  - else, `r0 = r0 + 1`  
  - jump back to `loop`
- Works like:

```c
int i = 0;
while (i < 5) {
    i++;
}
i = 2;   // same as mov r0, #2 at the end
```

---

## 5. Another Example: C `for` Loop and ARM Version

### C Code

```c
int i;

for (i = 0; i < 3; i++) {
    // do something
}
```

This is the same as:

```c
int i = 0;
while (i < 3) {
    // do something
    i++;
}
```

### ARM Assembly Version (simple structure)

```asm
    .global _start
_start:
    mov r0, #0        @ i = 0

for_loop:
    cmp r0, #3        @ check i < 3 ?
    bge done          @ if i >= 3, exit loop

    @ --- do something here ---
    @ example: add 10 to r1 each time

    add r1, r1, #10   @ r1 = r1 + 10

    add r0, r0, #1    @ i++  (i = i + 1)
    b   for_loop      @ go back and check again

done:
    mov r7, #1        @ syscall: exit (Linux)
    swi 0
```

---

## 6. Example: Counting Down (while loop, reverse)

### C Code

```c
int i = 5;

while (i > 0) {
    i--;
}
```

### ARM Assembly Version

```asm
    .global _start
_start:
    mov r0, #5        @ i = 5

down_loop:
    cmp r0, #0        @ is i > 0 ?
    ble finished      @ if i <= 0, exit loop

    sub r0, r0, #1    @ i = i - 1 (i--)

    b   down_loop     @ repeat

finished:
    mov r7, #1        @ exit (for Linux)
    swi 0
```

---

## 7. Key Points to Remember

- In C:
  - `while (condition) { ... }`
  - `for (start; condition; update) { ... }`

- In assembly (ARM):
  - Use a register like `r0` as the loop variable.
  - Use `cmp` to compare.
  - Use `bge`, `ble`, `beq`, `bne`, etc. to branch based on the result.
  - Make a label (like `loop:`), do your code, then `b loop` to repeat.

- Typical loop pattern in ARM:

```asm
    mov r0, #0        @ init i

loop:
    cmp r0, #N        @ check condition
    bge end           @ if fail, exit
    @ body
    add r0, r0, #1    @ update i
    b   loop

end:
    @ after loop
```

You can use this pattern for most simple loops.