// =====================================================================
//  DSP Lab 3 - Discrete-time signal manipulation functions (Scilab)
//  Convention: a signal is a row vector xn plus an index xorigin,
//  where xn(xorigin) is the sample at n = 0 (1-based index).
// =====================================================================
funcprot(0);

// ---------------------------------------------------------------------
// Helper: draw several signals as stem plots in ONE figure (subplots).
// sigs    : list of row vectors
// origins : vector of origin indexes
// titles  : vector of strings
// Set  global LAB3_NOPLOT = %t  to switch plotting off.
// ---------------------------------------------------------------------
function showsig(sigs, origins, titles, figname)
    global LAB3_NOPLOT
    if LAB3_NOPLOT == %t then
        return
    end
    m = size(sigs);
    nmin = %inf; nmax = -%inf; vmin = 0; vmax = 0;
    for i = 1:m
        x = sigs(i);
        n = (1:length(x)) - origins(i);
        nmin = min(nmin, n(1)); nmax = max(nmax, n($));
        vmin = min(vmin, min(x)); vmax = max(vmax, max(x));
    end
    f = scf(max([winsid(), -1]) + 1);
    f.figure_name = figname;
    f.background = 8;
    for i = 1:m
        subplot(m, 1, i);
        x = sigs(i);
        n = (1:length(x)) - origins(i);
        plot2d3(n, x);                       // vertical stems
        e = gce(); e.children.foreground = 2; e.children.thickness = 2;
        plot(n, x, "bo");                    // circles on top
        a = gca();
        pad = 0.2 * max(1, vmax - vmin);
        a.data_bounds = [nmin - 1, vmin - pad; nmax + 1, vmax + pad];
        a.x_location = "origin";
        a.grid = [1 1];
        a.sub_ticks = [0 0];
        a.x_ticks = tlist(["ticks", "locations", "labels"], ..
                          (nmin-1:nmax+1)', string((nmin-1:nmax+1)'));
        title(titles(i), "fontsize", 3);
        xlabel("n");
    end
endfunction

// ---------------------------------------------------------------------
// Helper: put two signals on a common time axis (zero padding).
// Returns a, b (same length) and the common origin o.
// ---------------------------------------------------------------------
function [a, b, o] = align2(x1n, x1origin, x2n, x2origin)
    n1s = 1 - x1origin; n1e = length(x1n) - x1origin;
    n2s = 1 - x2origin; n2e = length(x2n) - x2origin;
    ns = min(n1s, n2s); ne = max(n1e, n2e);
    L = ne - ns + 1;
    a = zeros(1, L); b = zeros(1, L);
    a((n1s - ns + 1):(n1e - ns + 1)) = x1n;
    b((n2s - ns + 1):(n2e - ns + 1)) = x2n;
    o = 1 - ns;
endfunction

// ---------------------------------------------------------------------
// Exercise 1: y(n) = x(n - k), k > 0
// ---------------------------------------------------------------------
function [yn, yorigin] = delay(xn, xorigin, k)
    if k <= 0 then
        error("delay: k must be > 0");
    end
    yn = xn;
    yorigin = xorigin - k;            // every sample moves k steps right
    if yorigin < 1 then               // n = 0 is now left of the data
        yn = [zeros(1, 1 - yorigin), yn];
        yorigin = 1;
    end
    showsig(list(xn, yn), [xorigin, yorigin], ..
            ["x(n)", "y(n) = x(n - " + string(k) + ")"], "Delay");
endfunction

// ---------------------------------------------------------------------
// Exercise 2: y(n) = x(n + k), k > 0
// ---------------------------------------------------------------------
function [yn, yorigin] = advance(xn, xorigin, k)
    if k <= 0 then
        error("advance: k must be > 0");
    end
    yn = xn;
    yorigin = xorigin + k;            // every sample moves k steps left
    if yorigin > length(yn) then      // n = 0 is now right of the data
        yn = [yn, zeros(1, yorigin - length(yn))];
    end
    showsig(list(xn, yn), [xorigin, yorigin], ..
            ["x(n)", "y(n) = x(n + " + string(k) + ")"], "Advance");
endfunction

// ---------------------------------------------------------------------
// Exercise 3: y(n) = x(-n)
// ---------------------------------------------------------------------
function [yn, yorigin] = fold(xn, xorigin)
    yn = xn($:-1:1);
    yorigin = length(xn) - xorigin + 1;
    showsig(list(xn, yn), [xorigin, yorigin], ..
            ["x(n)", "y(n) = x(-n)"], "Fold");
endfunction

// ---------------------------------------------------------------------
// Exercise 4: y(n) = x1(n) + x2(n)
// ---------------------------------------------------------------------
function [yn, yorigin] = add(x1n, x1origin, x2n, x2origin)
    [a, b, yorigin] = align2(x1n, x1origin, x2n, x2origin);
    yn = a + b;
    showsig(list(x1n, x2n, yn), [x1origin, x2origin, yorigin], ..
            ["x1(n)", "x2(n)", "y(n) = x1(n) + x2(n)"], "Add");
endfunction

// ---------------------------------------------------------------------
// Exercise 5: y(n) = x1(n) . x2(n)
// ---------------------------------------------------------------------
function [yn, yorigin] = multi(x1n, x1origin, x2n, x2origin)
    [a, b, yorigin] = align2(x1n, x1origin, x2n, x2origin);
    yn = a .* b;
    showsig(list(x1n, x2n, yn), [x1origin, x2origin, yorigin], ..
            ["x1(n)", "x2(n)", "y(n) = x1(n).x2(n)"], "Multiplication");
endfunction

// ---------------------------------------------------------------------
// Exercise 6: y(n) = x(n) * h(n) = sum_k x(k) h(n - k)
// ---------------------------------------------------------------------
function [yn, yorigin] = convolution(xn, xorigin, hn, horigin)
    Lx = length(xn); Lh = length(hn);
    yn = zeros(1, Lx + Lh - 1);
    for i = 1:Lx
        for j = 1:Lh
            yn(i + j - 1) = yn(i + j - 1) + xn(i) * hn(j);
        end
    end
    // first sample of y is at n = (1 - xorigin) + (1 - horigin)
    yorigin = xorigin + horigin - 1;
    showsig(list(xn, hn, yn), [xorigin, horigin, yorigin], ..
            ["x(n)", "h(n)", "y(n) = x(n) * h(n)"], "Convolution");
endfunction
