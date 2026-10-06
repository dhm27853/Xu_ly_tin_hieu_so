// ============================================================
//  DSP - LAB 2  (Scilab)
//  Chay tung phan: boi den doan code -> Ctrl+E (Evaluate selection)
//  LUU Y: chay PHAN 0 (cac ham ho tro) truoc tien.
// ============================================================

// ================= PHAN 0: HAM HO TRO =================
clc; clear; xdel(winsid());

// Ve tin hieu roi rac
function ve_roi(n, x, tieu_de, nhan_y)
    plot2d3(n, x);
    plot(n, x, "ro");
    a = gca();
    a.data_bounds = [min(n)-1, min(0, min(x))-1; max(n)+1, max(0, max(x))+1];
    title(tieu_de); xlabel("n"); ylabel(nhan_y);
    xgrid();
endfunction

// Dat tin hieu (n0, x0) len truc thoi gian moi n (cho khac = 0)
function y = mo_rong(n0, x0, n)
    y = zeros(n);
    for k = 1:length(n0)
        y(n == n0(k)) = x0(k);
    end
endfunction

// ================= EXERCISE 1: tim hieu cac ham =================
v = [4 -2 7 1];
min(v)                         // phan tu nho nhat -> -2
max(v)                         // phan tu lon nhat -> 7
[m, vi_tri] = max(v)           // gia tri va vi tri
bool2s(v > 0)                  // doi boolean -> 0/1 : [1 0 1 1]
deff("y = f(x)", "y = x.^2 + 1");   // dinh nghia ham 1 dong
f(3)                           // -> 10

scf(10); clf();
n = 0:5;
subplot(1,2,1);                // chia cua so 1 hang 2 cot, o thu 1
plot2d3(n, n.^2);              // ve dang que (roi rac)
title("plot2d3 demo"); xlabel("n"); ylabel("n^2");
subplot(1,2,2);                // o thu 2
plot2d3(n, bool2s(n >= 2));
title("bool2s demo"); xlabel("n"); ylabel("bool2s(n>=2)");

// ================= EXERCISE 2: unit step =================
scf(2); clf();
n = -5:5;
msignal = bool2s(n >= 0);
plot2d3(n, msignal);
title("Exercise 2 - Unit step u(n)"); xlabel("n"); ylabel("u(n)");

// ================= EXERCISE 3: unit impulse =================
scf(3); clf();
n = -5:5;
msignal = bool2s(n == 0);
plot2d3(n, msignal);
title("Exercise 3 - Unit impulse delta(n)"); xlabel("n"); ylabel("delta(n)");

// ================= EXERCISE 4: unit ramp =================
scf(4); clf();
n = -5:5;
ur = n .* bool2s(n >= 0);
ve_roi(n, ur, "Exercise 4 - Unit ramp ur(n)", "ur(n)");

// ================= EXERCISE 5: even / odd =================
// x(n) = {1, 3(n=0), -2}
n = -1:1;
x = [1 3 -2];
xf = x($:-1:1);          // x(-n) (n doi xung nen chi can dao nguoc)
xe = (x + xf)/2          // {-0.5, 3, -0.5}
xo = (x - xf)/2          // {1.5, 0, -1.5}

scf(5); clf();
subplot(3,1,1); ve_roi(n, x,  "Exercise 5 - x(n)", "x(n)");
subplot(3,1,2); ve_roi(n, xo, "Odd component xo(n)", "xo(n)");
subplot(3,1,3); ve_roi(n, xe, "Even component xe(n)", "xe(n)");

// ================= EXERCISE 6: addition =================
// x1 = {0(n=0), 1, 3, -2}   x2 = {0, 1(n=0), 2, 3}
n1 = 0:3;  x1 = [0 1 3 -2];
n2 = -1:2; x2 = [0 1 2 3];
n  = min([n1 n2]):max([n1 n2]);      // -1..3
X1 = mo_rong(n1, x1, n);
X2 = mo_rong(n2, x2, n);
y  = X1 + X2                          // {0, 1(n=0), 3, 6, -2}

scf(6); clf();
subplot(3,1,1); ve_roi(n, X1, "Exercise 6 - x1(n)", "x1(n)");
subplot(3,1,2); ve_roi(n, X2, "x2(n)", "x2(n)");
subplot(3,1,3); ve_roi(n, y,  "y(n) = x1(n) + x2(n)", "y(n)");

// ================= EXERCISE 7: multiplication =================
y = X1 .* X2                          // {0, 0(n=0), 2, 9, 0}

scf(7); clf();
subplot(3,1,1); ve_roi(n, X1, "Exercise 7 - x1(n)", "x1(n)");
subplot(3,1,2); ve_roi(n, X2, "x2(n)", "x2(n)");
subplot(3,1,3); ve_roi(n, y,  "y(n) = x1(n) . x2(n)", "y(n)");

// ================= EXERCISE 8: folding / shifting =================
// x(n) = {1, -2, 3(n=0), 6}
n0 = -2:1; x0 = [1 -2 3 6];

// y1(n) = x(-n)
ny1 = -n0($:-1:1);  y1 = x0($:-1:1)            // n=-1..2 : {6, 3, -2, 1}
// y2(n) = x(n+3)  -> dich trai 3
ny2 = n0 - 3;       y2 = x0                    // n=-5..-2: {1, -2, 3, 6}
// y3(n) = 2x(-n-2) -> gap, roi dich trai 2, nhan 2
ny3 = -n0($:-1:1) - 2;  y3 = 2*x0($:-1:1)      // n=-3..0 : {12, 6, -4, 2}

nn = -6:3;   // truc chung de de so sanh
scf(81); clf();
subplot(2,1,1); ve_roi(nn, mo_rong(n0, x0, nn), "Exercise 8 - x(n)", "x(n)");
subplot(2,1,2); ve_roi(nn, mo_rong(ny1, y1, nn), "y1(n) = x(-n)", "y1(n)");
scf(82); clf();
subplot(2,1,1); ve_roi(nn, mo_rong(n0, x0, nn), "Exercise 8 - x(n)", "x(n)");
subplot(2,1,2); ve_roi(nn, mo_rong(ny2, y2, nn), "y2(n) = x(n+3)", "y2(n)");
scf(83); clf();
subplot(2,1,1); ve_roi(nn, mo_rong(n0, x0, nn), "Exercise 8 - x(n)", "x(n)");
subplot(2,1,2); ve_roi(nn, mo_rong(ny3, y3, nn), "y3(n) = 2x(-n-2)", "y3(n)");

// ============================================================
//            ADDITIONAL EXERCISES (sach Proakis)
// ============================================================

// ================= Problem 1.3 =================
t = 0:0.001:6;
n = 0:47;
scf(13); clf();
subplot(3,2,1); plot(t, 3*cos(5*t + %pi/6));
title("(a) xa(t)=3cos(5t+pi/6): periodic, T=2pi/5"); xlabel("t"); ylabel("xa(t)");
subplot(3,2,2); ve_roi(n, 3*cos(5*n + %pi/6), "(b) 3cos(5n+pi/6): NOT periodic", "x(n)");
subplot(3,2,3); ve_roi(n, real(2*exp(%i*(n/6 - %pi))), "(c) Re{2exp[j(n/6-pi)]}: NOT periodic", "Re x(n)");
subplot(3,2,4); ve_roi(n, cos(n/8).*cos(%pi*n/8), "(d) cos(n/8)cos(pi n/8): NOT periodic", "x(n)");
subplot(3,2,5); ve_roi(n, cos(%pi*n/2) - sin(%pi*n/8) + 3*cos(%pi*n/4 + %pi/3), ..
                "(e) periodic, N = 16", "x(n)");

// ================= Problem 1.6 =================
// Vi du: Tp = 1 s, T = 3/8 s -> T/Tp = 3/8 (huu ti) -> N = 8 mau = 3 chu ky xa(t)
Tp = 1; T = 3/8;
t = 0:0.001:6;
n = 0:16;
scf(16); clf();
plot(t, cos(2*%pi*t/Tp));
plot2d3(n*T, cos(2*%pi*n*T/Tp)); plot(n*T, cos(2*%pi*n*T/Tp), "ro");
title("Problem 1.6 - T/Tp = 3/8: x(n) periodic, N = 8 samples = 3 s = 3 periods of xa(t)");
xlabel("t (s)"); ylabel("amplitude");

// ================= Problem 1.7 =================
// Fs = 8 kHz: 5 kHz -> alias 3 kHz ; 9 kHz -> alias 1 kHz
Fs = 8000;
t = 0:1e-6:2e-3;
n = 0:16;
scf(17); clf();
subplot(2,1,1);
plot(t, cos(2*%pi*5000*t), "b"); plot(t, cos(2*%pi*3000*t), "g");
plot(n/Fs, cos(2*%pi*5000*n/Fs), "ro");
title("Problem 1.7(b) - 5 kHz (blue) and 3 kHz (green) give the same samples at Fs = 8 kHz");
xlabel("t (s)"); ylabel("amplitude");
subplot(2,1,2);
plot(t, cos(2*%pi*9000*t), "b"); plot(t, cos(2*%pi*1000*t), "g");
plot(n/Fs, cos(2*%pi*9000*n/Fs), "ro");
title("Problem 1.7(c) - 9 kHz (blue) and 1 kHz (green) give the same samples at Fs = 8 kHz");
xlabel("t (s)"); ylabel("amplitude");

// ================= Problem 1.9 =================
// xa = sin(480 pi t) + 3 sin(720 pi t), Fs = 600 Hz
Fs = 600;
t = 0:1e-5:0.02;
n = 0:12;
xa = sin(480*%pi*t) + 3*sin(720*%pi*t);
xn = sin(480*%pi*n/Fs) + 3*sin(720*%pi*n/Fs);    // = -2 sin(0.8 pi n)
ya = -2*sin(480*%pi*t);
scf(19); clf();
subplot(2,1,1);
plot(t, xa); plot(n/Fs, xn, "ro");
title("Problem 1.9 - xa(t) and its samples (Fs = 600 Hz)"); xlabel("t (s)"); ylabel("xa(t)");
subplot(2,1,2);
plot(t, ya, "g"); plot(n/Fs, xn, "ro");
title("Reconstructed ya(t) = -2sin(480 pi t) passes through the same samples"); xlabel("t (s)"); ylabel("ya(t)");

// ================= Problem 1.10 =================
// 10000 bit/s, 1024 muc = 10 bit/mau -> Fs = 1000 Hz
Fs = 1000;
n = 0:39;
xn  = 3*cos(600*%pi*n/Fs) + 2*cos(1800*%pi*n/Fs);
xn2 = 3*cos(0.6*%pi*n)   + 2*cos(0.2*%pi*n);
disp(max(abs(xn - xn2)));        // ~0 -> hai bieu thuc giong nhau
delta = 10/1023                   // ~0.0098
scf(110); clf();
ve_roi(n, xn, "Problem 1.10 - x(n) = 3cos(0.6 pi n) + 2cos(0.2 pi n), Fs = 1 kHz", "x(n)");
