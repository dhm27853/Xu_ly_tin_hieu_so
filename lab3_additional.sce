/ =====================================================================
//  DSP Lab 3 - Additional exercises 2.1, 2.2, 2.4, 2.6 (Scilab part)
//  Put this file in the same folder as lab3_functions.sci, then run it.
//  Intermediate steps are computed with plotting switched off; each
//  question's result is then drawn with showsig().
// =====================================================================
clear; clc;
exec(get_absolute_file_path("lab3_additional.sce") + "lab3_functions.sci", -1);
global LAB3_NOPLOT;

// Print a signal as  n: ...  /  x: ...
function printsig(name, xn, xorigin)
    n = (1:length(xn)) - xorigin;
    mprintf("%s\n   n : %s\n   x : %s\n", name, ..
            strcat(msprintf("%7d\n", n'), " "), ..
            strcat(msprintf("%7.4g\n", xn'), " "));
endfunction

// Compare two signals on a common axis
function r = samesig(an, ao, bn, bo)
    [a, b, o] = align2(an, ao, bn, bo);
    r = and(abs(a - b) < 1e-12);
endfunction

// Systems used in problem 2.6 -----------------------------------------
// y(n) = x(n^2)
function [yn, yorigin] = sys_square(xn, xorigin)
    ns = 1 - xorigin; ne = length(xn) - xorigin;   // support of x
    if ne < 0 then
        yn = 0; yorigin = 1; return;
    end
    M = floor(sqrt(ne));                            // |n| <= M  ->  n^2 <= ne
    n = -M:M;
    yn = zeros(1, length(n));
    for i = 1:length(n)
        m = n(i)^2;
        if m >= ns & m <= ne then
            yn(i) = xn(m + xorigin);
        end
    end
    yorigin = M + 1;
endfunction

// y(n) = x(n) - x(n-1)
function [yn, yorigin] = sys_diff(xn, xorigin)
    yn = [xn, 0] - [0, xn];
    yorigin = xorigin;
endfunction

// y(n) = n.x(n)
function [yn, yorigin] = sys_nx(xn, xorigin)
    n = (1:length(xn)) - xorigin;
    yn = n .* xn;
    yorigin = xorigin;
endfunction

// Steps (1)-(6) of problem 2.6(b) for any system "sys"
function check_ti(sys, name, xn, xorigin)
    global LAB3_NOPLOT
    LAB3_NOPLOT = %t;
    [y, yo]     = sys(xn, xorigin);          // (2) y(n) = T[x(n)]
    [y2p, y2po] = delay(y, yo, 2);           // (3) y'2(n) = y(n-2)
    [x2, x2o]   = delay(xn, xorigin, 2);     // (4) x2(n) = x(n-2)
    [y2, y2o]   = sys(x2, x2o);              // (5) y2(n) = T[x2(n)]
    LAB3_NOPLOT = %f;
    mprintf("\n----- System %s -----\n", name);
    printsig("(1) x(n)", xn, xorigin);
    printsig("(2) y(n) = T[x(n)]", y, yo);
    printsig("(3) y''2(n) = y(n-2)", y2p, y2po);
    printsig("(4) x2(n) = x(n-2)", x2, x2o);
    printsig("(5) y2(n) = T[x2(n)]", y2, y2o);
    if samesig(y2, y2o, y2p, y2po) then
        mprintf("(6) y2(n) = y(n-2)  -> consistent with time invariance\n");
    else
        mprintf("(6) y2(n) <> y(n-2) -> the system is TIME-VARIANT\n");
    end
    showsig(list(xn, y, y2p, x2, y2), [xorigin, yo, y2po, x2o, y2o], ..
            ["(1) x(n)", "(2) y(n) = T[x(n)]", "(3) y''2(n) = y(n-2)", ..
             "(4) x2(n) = x(n-2)", "(5) y2(n) = T[x2(n)]"], "2.6 " + name);
endfunction

// =====================================================================
//  PROBLEM 2.1
// =====================================================================
mprintf("\n=============== PROBLEM 2.1 ===============\n");
n  = -3:3;
xn = zeros(1, 7);
xn(n < 0)  = 1 + n(n < 0) / 3;            // -3 <= n <= -1
xn(n >= 0) = 1;                           //  0 <= n <= 3
xo = 4;                                   // n = 0 is the 4th sample
printsig("(a) x(n)", xn, xo);
LAB3_NOPLOT = %f;
showsig(list(xn), xo, "2.1(a)  x(n)", "2.1a");

LAB3_NOPLOT = %t;
[f, fo]   = fold(xn, xo);
[b1, b1o] = delay(f, fo, 4);              // (b1) fold, then delay 4
[d, d_o]  = delay(xn, xo, 4);
[b2, b2o] = fold(d, d_o);                 // (b2) delay 4, then fold
// (c) x(-n+4) computed directly from the definition
nc = -2:8; c = zeros(nc);
for i = 1:length(nc)
    m = -nc(i) + 4;
    if m >= -3 & m <= 3 then c(i) = xn(m + xo); end
end
co = 3;
LAB3_NOPLOT = %f;
printsig("(b1) fold then delay 4", b1, b1o);
printsig("(b2) delay 4 then fold", b2, b2o);
printsig("(c) x(-n+4)", c, co);
showsig(list(b1, b2, c), [b1o, b2o, co], ..
        ["2.1(b1) fold, then delay by 4", "2.1(b2) delay by 4, then fold", ..
         "2.1(c) x(-n+4)"], "2.1bc");
mprintf("(d) (b1) equals x(-n+4)? %s ;  (b2) equals x(-n+4)? %s\n", ..
        string(samesig(b1, b1o, c, co)), string(samesig(b2, b2o, c, co)));
mprintf("    Rule: x(-n+k) = fold x(n) first, then delay by k.\n");

// (e) x(n) = 1/3 d(n+2) + 2/3 d(n+1) + u(n) - u(n-4), checked on -10..10
ne_ = -10:10;
dl = bool2s(ne_ == -2) / 3 + 2 * bool2s(ne_ == -1) / 3 ..
     + bool2s(ne_ >= 0) - bool2s(ne_ >= 4);
mprintf("(e) delta/u expression equals x(n)? %s\n", ..
        string(samesig(dl, 11, xn, xo)));

// =====================================================================
//  PROBLEM 2.2   x(n) = {1, 1(origin), 1, 1, 1/2, 1/2}
// =====================================================================
mprintf("\n=============== PROBLEM 2.2 ===============\n");
xn = [1, 1, 1, 1, 0.5, 0.5]; xo = 2;
LAB3_NOPLOT = %t;
[ya, yao] = delay(xn, xo, 2);                           // (a) x(n-2)
[f, fo]   = fold(xn, xo);
[yb, ybo] = delay(f, fo, 4);                            // (b) x(4-n)
[yc, yco] = advance(xn, xo, 2);                         // (c) x(n+2)
u2n = [ones(1, 6), 0, 0, 0];                           // u(2-n), n=-3..5
[yd, ydo] = multi(xn, xo, u2n, 4);                      // (d) x(n)u(2-n)
[x1, x1o] = delay(xn, xo, 1);
[ye, yeo] = multi(x1, x1o, [0, 0, 0, 1], 1);            // (e) x(n-1)d(n-3)
[yf, yfo] = sys_square(xn, xo);                         // (f) x(n^2)
[f, fo]   = fold(xn, xo);
[s, so]   = add(xn, xo, f, fo);
yg = s / 2; ygo = so;                                   // (g) even part
[mf, mfo] = fold(-xn, xo);
[s, so]   = add(xn, xo, mf, mfo);
yh = s / 2; yho = so;                                   // (h) odd part
LAB3_NOPLOT = %f;
printsig("x(n)", xn, xo);
printsig("(a) x(n-2)", ya, yao);
printsig("(b) x(4-n)", yb, ybo);
printsig("(c) x(n+2)", yc, yco);
printsig("(d) x(n)u(2-n)", yd, ydo);
printsig("(e) x(n-1)d(n-3)", ye, yeo);
printsig("(f) x(n^2)", yf, yfo);
printsig("(g) xe(n)", yg, ygo);
printsig("(h) xo(n)", yh, yho);
showsig(list(xn, ya, yb, yc), [xo, yao, ybo, yco], ..
        ["2.2  x(n)", "(a) x(n-2)", "(b) x(4-n)", "(c) x(n+2)"], "2.2a-c");
showsig(list(yd, ye, yf), [ydo, yeo, yfo], ..
        ["(d) x(n)u(2-n)", "(e) x(n-1)d(n-3)", "(f) x(n^2)"], "2.2d-f");
showsig(list(yg, yh), [ygo, yho], ..
        ["(g) even part xe(n)", "(h) odd part xo(n)"], "2.2gh");
mprintf("Check xe(n) + xo(n) = x(n): %s\n", ..
        string(samesig(yg + yh, ygo, xn, xo)));

// =====================================================================
//  PROBLEM 2.4   x(n) = {2, 3, 4(origin), 5, 6}
// =====================================================================
mprintf("\n=============== PROBLEM 2.4 ===============\n");
xn = [2, 3, 4, 5, 6]; xo = 3;
LAB3_NOPLOT = %t;
[f, fo]   = fold(xn, xo);
[s, so]   = add(xn, xo, f, fo);   xe = s / 2; xeo = so;
[mf, mfo] = fold(-xn, xo);
[s, so]   = add(xn, xo, mf, mfo); xod = s / 2; xodo = so;
[r, ro]   = add(xe, xeo, xod, xodo);
LAB3_NOPLOT = %f;
printsig("x(n)", xn, xo);
printsig("xe(n) = [x(n) + x(-n)]/2", xe, xeo);
printsig("xo(n) = [x(n) - x(-n)]/2", xod, xodo);
printsig("xe(n) + xo(n)", r, ro);
LAB3_NOPLOT = %t;
[fe, feo] = fold(xe, xeo);     // xe(-n)
[fd, fdo] = fold(xod, xodo);   // xo(-n)
LAB3_NOPLOT = %f;
mprintf("xe even? %s   xo odd? %s   xe + xo = x? %s\n", ..
        string(samesig(fe, feo, xe, xeo)), string(samesig(fd, fdo, -xod, xodo)), ..
        string(samesig(r, ro, xn, xo)));
showsig(list(xn, xe, xod, r), [xo, xeo, xodo, ro], ..
        ["2.4  x(n)", "xe(n)", "xo(n)", "xe(n) + xo(n)"], "2.4");

// =====================================================================
//  PROBLEM 2.6   x(n) = 1 for 0 <= n <= 3
// =====================================================================
mprintf("\n=============== PROBLEM 2.6 ===============\n");
xn = [1, 1, 1, 1]; xo = 1;
check_ti(sys_square, "y(n) = x(n^2)",       xn, xo);   // (b)
check_ti(sys_diff,   "y(n) = x(n) - x(n-1)", xn, xo);  // (c)
check_ti(sys_nx,     "y(n) = n.x(n)",       xn, xo);   // (d)
