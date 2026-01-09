//Write code that:
//- Puts 10 in r0
//- Puts 20 in r1
//- If r0 < r1, put 1 in r2
//- Else, put 0 in r2

.global _start
_start:
	mov r0, #10
	mov r1, #20
	cmp r0, r1
	blt cond1
	b cond2

cond1:
	mov r2, #1
cond2:
	mov r2, #0
	
	

//Write code that:
//- Puts 15 in r0
//- Puts 25 in r1
//- Put the bigger number in r2

.global _start
_start:
	mov r0, #15
	mov r1, #25
	cmp r0, r1
	bgt cond1
	b cond2

cond1:
	mov r2, r0
cond2:
	mov r2, r1


//Write code that:
//- Puts 10 in r0
//- Puts 10 in r1
//- If r0 > r1: r2 = 1
//- If r0 < r1: r2 = -1
//- If r0 == r1: r2 = 0

.global _start
_start:
	mov r0, #10
	mov r1, #10
	cmp r0, r1
	bgt cond1
	blt cond2
	b cond3

cond1:
	mov r2, #1
cond2:
	mov r2, #-1
cond3:
	mov r2, #0
	
	


	
	
