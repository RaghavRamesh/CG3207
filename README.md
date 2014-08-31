Classwork Problem
============

Augment the sample counter (in step 1) as follows:
When a button DIR is pressed, the counter should toggle the count direction. Upon pressing the RESET button, the counter value should be reset (synchronously or asynchronously) to "0000" when counting up, and to "1111" when counting down. 

Optional (for enthusiastic folks only, no extra credit) : The counter has 4 different speeds - 1x (the default speed), 2x, 3x, and 4x. A button SPEED is used to change the speed of the counter -  each press of SPEED increases the speed, and if the current speed is 4x, it wraps around to 1x.

Note : You will need to debounce DIR and SPEED buttons to observe the desired results (why?). However, debouncing is left as an optional task. Priority of buttons (i.e., what should happen when two or more buttons are pressed together) is left to your discretion.