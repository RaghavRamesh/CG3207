Lab1
============

Part 1
-----
Augment the sample counter (in step 1) as follows:
When a button DIR is pressed, the counter should toggle the count direction. Upon pressing the RESET button, the counter value should be reset (synchronously or asynchronously) to "0000" when counting up, and to "1111" when counting down. 

Optional (for enthusiastic folks only, no extra credit) : The counter has 4 different speeds - 1x (the default speed), 2x, 3x, and 4x. A button SPEED is used to change the speed of the counter -  each press of SPEED increases the speed, and if the current speed is 4x, it wraps around to 1x.

** Note : ** You will need to debounce DIR and SPEED buttons to observe the desired results (why?). However, debouncing is left as an optional task. Priority of buttons (i.e., what should happen when two or more buttons are pressed together) is left to your discretion.

Part 2
-----
#####Problem Statement
Design a system that can read-in characters from a ROM (Read-Only Memory) and convert lower-case characters into upper-case character and vice-versa. 

#####Details
Each character in a string (array of characters) is stored in 8-bit value according to an ASCII table. For example if we want to store "Hello World" (without quotes), then the array would contain {0x48, 0x45, 0x4C, 0x4C, 0x4F, 0x20, ...}. 0x48 (in HEX) corresponds to 'H', 0x45 to 'E' and so on. Please visit http://www.asciitable.com/ for a list of ASCII codes.

A ROM contains the string that we want to change case. Use the Language Template\VHDL\Synthesis Constructs\Coding Examples\ROM in ISE to instantiate a ROM.
The counter generates the address for the ROM. The data from the ROM goes to the comparators. If the data is between 0x41 and 0x5A, then the character is upper-case. If the data is between 0x61 and 0x7A, then the character is lower-case. If it is out of these ranges, it is not an alphabet.
The comparator compares the data whether the data is either upper-case letter or lower-case letter or neither. The result is provided to the state-machine.
The Adder/Subtractor can convert the case of the data from the ROM to lower by adding 0x20. Similarly, it can also convert to upper-case by subtracting 0x20. If the data is not an alphabet, the data can remain unchanged. The resulting data is placed on the output of the ADD/SUB module. The operation performed by the ADD/SUB module (i.e. (1) ADD 0x20, (2) SUB 0x20, and (3) NO OPERATION) is under the control of the state-machine.

The state-machine has a reset input that causes the system to start reading from the start. The OP[1:0] is two-bit input that has the following meaning:

00: No Operation
01: Read and Convert to lower-case
10: Read and Convert to upper-case
11: No Operation

The output of the ADD/SUB is 8-bit. To display it on 4 LEDs, we need to display multiplex the LEDs using the fourth push button such that when the button is pressed, the LEDs shown the higher 4-bits and when not, it shows the lower 4-bits of the output of the ADD/SUB module.