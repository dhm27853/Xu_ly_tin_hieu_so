// ============================================================
//  DSP - LAB 1  (Scilab)
//  Chay tung phan: boi den doan code -> Ctrl+E (Evaluate selection)
//  hoac chay ca file: F5
// ============================================================
clc; clear; xdel(winsid());

// Ham ve tin hieu roi rac (giong stem trong Matlab)
function ve_roi(n, x, tieu_de, nhan_y)
    plot2d3(n, x);
    plot(n, x, "ro");
    a = gca();
    a.data_bounds = [min(n)-1, min(0, min(x))-0.5; max(n)+1, max(0, max(x))+0.5];
    title(tieu_de); xlabel("n"); ylabel(nhan_y);
endfunction

// ================= Ex 1.1 =================
x = 1:4
v1 = x + 1              // (x1+1, x2+1, x3+1, x4+1)

y = 5:8
v2 = x .* y             // (x1y1, ..., x4y4) - nhan tung phan tu

x3 = linspace(0, %pi, 10)
v3 = sin(x3)            // (sin(x1), ..., sin(x10))

// ================= Ex 1.2 =================
// xa(t) = 3 sin(100*pi*t)  ->  F = 50 Hz, Tp = 20 ms
F  = 50;
Fs = 300;
delta = 0.1;

// (1) Tin hieu tuong tu: 5 chu ky = 0 -> 0.1 s
t  = 0:1e-4:5/F;
xa = 3*sin(100*%pi*t);

// (2)(3) Lay mau: x(n) = xa(n/Fs) = 3 sin(pi*n/3)
f = F/Fs                // f = 1/6 chu ky/mau (huu ti) -> tuan hoan
N = 6                   // chu ky co ban N = 6 mau
n  = 0:5*N-1;           // 5 chu ky = 30 mau
xn = 3*sin(100*%pi*n/Fs);
xn = round(xn*1e10)/1e10;   // bo sai so 1e-16 (tranh floor(-1e-16) = -1)

// (4) Luong tu hoa kieu cat bo (truncation), delta = 0.1
xq = floor(xn/delta)*delta;

disp("   n        x(n)      xq(n)");
disp([n' xn' xq']);

// Ca 3 hinh trong 1 cua so
scf(1); clf();
subplot(3,1,1);
plot(t, xa);
title("Analog signal xa(t) = 3sin(100*pi*t) - 5 periods");
xlabel("t (s)"); ylabel("xa(t)");

subplot(3,1,2);
ve_roi(n, xn, "Discrete-time signal x(n) = 3sin(pi*n/3), Fs = 300 Hz, N = 6", "x(n)");

subplot(3,1,3);
ve_roi(n, xq, "Quantized signal xq(n) - truncation, delta = 0.1", "xq(n)");
