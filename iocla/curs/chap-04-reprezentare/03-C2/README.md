

### flags.asm
compile and play in gdb

### print_flags.c 
flags calculator 

For signed/unsigned operations, watch flags C(arry), O(verflow), Z(ero).

Presence of a flag means result is in the allowed interval. 

Absence of a flag means the operation is within the allowed interval. 

0x2 + 0x2 

0xff + 1

0xff + 0xff

0xfe + 7

0x7f + 0x81 vs. 0x7f + 1

0x7f + 0x7f vs 0x7f + 0x80

Exercises for C and O - find a pair that activates:
* none 
* only C
* only O
* both 

### asymmetrical.c

-(-128 ) = -128 

C does not check flags, which may lead to bugs.


