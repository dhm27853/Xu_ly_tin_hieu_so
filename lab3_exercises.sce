// =====================================================================
//  DSP Lab 3 - Part 2: Exercises 1-6 (test examples)
//  Put this file in the same folder as lab3_functions.sci, then run it.
// =====================================================================
clear; clc;
exec(get_absolute_file_path("lab3_exercises.sce") + "lab3_functions.sci", -1);
global LAB3_NOPLOT; LAB3_NOPLOT = %f;

// ---- Exercise 1: y(n) = x(n-1),  x(n) = {1, -2, 3(origin), 6}
mprintf("\n===== Exercise 1: delay =====\n");
[yn, yorigin] = delay([1, -2, 3, 6], 3, 1);
disp("yn = ", yn); disp("yorigin = ", yorigin);

// ---- Exercise 2: y(n) = x(n+2),  x(n) = {1, -2, 3(origin), 6}
mprintf("\n===== Exercise 2: advance =====\n");
[yn, yorigin] = advance([1, -2, 3, 6], 3, 2);
disp("yn = ", yn); disp("yorigin = ", yorigin);

// ---- Exercise 3: y(n) = x(-n),  x(n) = {1, -2, 3(origin), 6}
mprintf("\n===== Exercise 3: fold =====\n");
[yn, yorigin] = fold([1, -2, 3, 6], 3);
disp("yn = ", yn); disp("yorigin = ", yorigin);

// ---- Exercise 4: x1(n) = {0(origin), 1, 3, -2},  x2(n) = {1, 1(origin), 2, 3}
mprintf("\n===== Exercise 4: add =====\n");
[yn, yorigin] = add([0, 1, 3, -2], 1, [1, 1, 2, 3], 2);
disp("yn = ", yn); disp("yorigin = ", yorigin);

// ---- Exercise 5: same x1(n), x2(n) as Exercise 4
mprintf("\n===== Exercise 5: multi =====\n");
[yn, yorigin] = multi([0, 1, 3, -2], 1, [1, 1, 2, 3], 2);
disp("yn = ", yn); disp("yorigin = ", yorigin);

// ---- Exercise 6: x(n) = {1, 2(origin), 3},  h(n) = {1(origin), -1, 2}
mprintf("\n===== Exercise 6: convolution =====\n");
[yn, yorigin] = convolution([1, 2, 3], 2, [1, -1, 2], 1);
disp("yn = ", yn); disp("yorigin = ", yorigin);
disp("Check with Scilab conv(): ", conv([1, 2, 3], [1, -1, 2]));
