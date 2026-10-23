clear all;
close all;
clc;

% ============================================================
% Pacote simbólico
% ============================================================
pkg load symbolic

% ============================================================
% Variáveis simbólicas
% ============================================================
syms d th a alpha real
syms d1 d3 th1 th2 real
deg2rad_sym = @(d) sym(d) * sym(pi) / sym(180);
pi2 = sym(pi)/2;
one = sym(1);
zero = sym(0);

% ============================================================
% Matriz de Denavit-Hartenberg
% ============================================================
A_DH = [ cos(th)  -sin(th)*cos(alpha)   sin(th)*sin(alpha)   a*cos(th)
         sin(th)   cos(th)*cos(alpha)  -cos(th)*sin(alpha)   a*sin(th)
         zero      sin(alpha)             cos(alpha)           d
         zero      zero                   zero                 one ];

% ============================================================
% Cadeia de transformações RRP (100% simbolica)
% ============================================================
% --------- Frame {0} ---------
F0 = sym(eye(4));

% --------- Frame {1} ---------
% Elo 1: theta = th1, d = d1, a = 0, alpha = -90 (-pi/2)
A1 = subs(A_DH, [d th a alpha], [d1 th1 zero -pi2]);
F1 = F0 * A1;

% --------- Frame {2} ---------
% Elo 2: theta = th2, d = 0, a = 0, alpha = 90 (pi/2)
A2 = subs(A_DH, [d th a alpha], [zero th2 zero pi2]);
F2 = F1 * A2;

% --------- Frame {3} ---------
% Elo 3: theta = 0, d = d3, a = 0, alpha = 0
A3 = subs(A_DH, [d th a alpha], [d3 zero zero zero]);
F3 = F2 * A3;

% ============================================================
% Exibição das transformações simbólicas
% ============================================================
disp('--- Matriz A1 ---'); pretty(A1)
disp('--- Matriz A2 ---'); pretty(A2)
disp('--- Matriz A3 ---'); pretty(A3)

A03 = simplify(F3);
disp('--- Matriz Homogênea Final A03 ---');
pretty(A03)

% ============================================================
% Parâmetros numéricos para teste
% ============================================================
t1s = deg2rad_sym(0);
t2s = deg2rad_sym(45);
d1s = sym(3);
d3s = sym(2);

A03_num = subs(A03, [th1 th2 d1 d3], [t1s t2s d1s d3s]);
A03_num = double(vpa(A03_num, 12));

disp('A03 numerica:')
disp(A03_num)

% --------- Substituições -> vpa -> double ---------
F0 = eye(4);
F1 = double(vpa(subs(F1, [th1 d1], [t1s d1s]), 12));
F2 = double(vpa(subs(F2, [th1 th2 d1], [t1s t2s d1s]), 12));
F3 = double(vpa(subs(F3, [th1 th2 d1 d3], [t1s t2s d1s d3s]), 12));

% ==== Plot ====
figure(1); clf;
axis equal; grid on; view(3);
xlabel('x'); ylabel('y'); zlabel('z'); hold on;
esc = 0.7;
mark = 1;

% ---------- Frame {0} ----------
plot3(F0(1,4), F0(2,4), F0(3,4), 'om', 'linewidth', 2, 'markersize', mark);
plot3([F0(1,4) F0(1,4)+esc*F0(1,1)], [F0(2,4) F0(2,4)+esc*F0(2,1)], [F0(3,4) F0(3,4)+esc*F0(3,1)], 'b', 'linewidth', 2);
text(F0(1,4)+esc*F0(1,1), F0(2,4)+esc*F0(2,1), F0(3,4)+esc*F0(3,1), 'x_{\{0\}}');
plot3([F0(1,4) F0(1,4)+esc*F0(1,2)], [F0(2,4) F0(2,4)+esc*F0(2,2)], [F0(3,4) F0(3,4)+esc*F0(3,2)], 'g', 'linewidth', 2);
text(F0(1,4)+esc*F0(1,2), F0(2,4)+esc*F0(2,2), F0(3,4)+esc*F0(3,2), 'y_{\{0\}}');
plot3([F0(1,4) F0(1,4)+esc*F0(1,3)], [F0(2,4) F0(2,4)+esc*F0(2,3)], [F0(3,4) F0(3,4)+esc*F0(3,3)], 'r', 'linewidth', 2);
text(F0(1,4)+esc*F0(1,3), F0(2,4)+esc*F0(2,3), F0(3,4)+esc*F0(3,3), 'z_{\{0\}}');
plot3([F0(1,4) F1(1,4)], [F0(2,4) F1(2,4)], [F0(3,4) F1(3,4)], 'k');

% ---------- Frame {1} ----------
plot3(F1(1,4), F1(2,4), F1(3,4), 'om', 'linewidth', 2, 'markersize', mark);
text(F1(1,4), F1(2,4), F1(3,4)-0.2, '\{1\}');
plot3([F1(1,4) F1(1,4)+esc*F1(1,1)], [F1(2,4) F1(2,4)+esc*F1(2,1)], [F1(3,4) F1(3,4)+esc*F1(3,1)], 'b', 'linewidth', 2);
text(F1(1,4)+esc*F1(1,1), F1(2,4)+esc*F1(2,1), F1(3,4)+esc*F1(3,1), 'x_{\{1\}}');
plot3([F1(1,4) F1(1,4)+esc*F1(1,2)], [F1(2,4) F1(2,4)+esc*F1(2,2)], [F1(3,4) F1(3,4)+esc*F1(3,2)], 'g', 'linewidth', 2);
text(F1(1,4)+esc*F1(1,2), F1(2,4)+esc*F1(2,2), F1(3,4)+esc*F1(3,2), 'y_{\{1\}}');
plot3([F1(1,4) F1(1,4)+esc*F1(1,3)], [F1(2,4) F1(2,4)+esc*F1(2,3)], [F1(3,4) F1(3,4)+esc*F1(3,3)], 'r', 'linewidth', 2);
text(F1(1,4)+esc*F1(1,3), F1(2,4)+esc*F1(2,3), F1(3,4)+esc*F1(3,3), 'z_{\{1\}}');
plot3([F1(1,4) F2(1,4)], [F1(2,4) F2(2,4)], [F1(3,4) F2(3,4)], 'k');

% ---------- Frame {2} ----------
plot3(F2(1,4), F2(2,4), F2(3,4), 'om', 'linewidth', 2, 'markersize', mark);
text(F2(1,4), F2(2,4), F2(3,4)-0.2, '\{2\}');
plot3([F2(1,4) F2(1,4)+esc*F2(1,1)], [F2(2,4) F2(2,4)+esc*F2(2,1)], [F2(3,4) F2(3,4)+esc*F2(3,1)], 'b', 'linewidth', 2);
text(F2(1,4)+esc*F2(1,1), F2(2,4)+esc*F2(2,1), F2(3,4)+esc*F2(3,1), 'x_{\{2\}}');
plot3([F2(1,4) F2(1,4)+esc*F2(1,2)], [F2(2,4) F2(2,4)+esc*F2(2,2)], [F2(3,4) F2(3,4)+esc*F2(3,2)], 'g', 'linewidth', 2);
text(F2(1,4)+esc*F2(1,2), F2(2,4)+esc*F2(2,2), F2(3,4)+esc*F2(3,2), 'y_{\{2\}}');
plot3([F2(1,4) F2(1,4)+esc*F2(1,3)], [F2(2,4) F2(2,4)+esc*F2(2,3)], [F2(3,4) F2(3,4)+esc*F2(3,3)], 'r', 'linewidth', 2);
text(F2(1,4)+esc*F2(1,3), F2(2,4)+esc*F2(2,3), F2(3,4)+esc*F2(3,3), 'z_{\{2\}}');
plot3([F2(1,4) F3(1,4)], [F2(2,4) F3(2,4)], [F2(3,4) F3(3,4)], 'k');

% ---------- Frame {3} ----------
plot3(F3(1,4), F3(2,4), F3(3,4), 'om', 'linewidth', 2, 'markersize', mark);
text(F3(1,4), F3(2,4), F3(3,4)-0.2, '\{3\}');
plot3([F3(1,4) F3(1,4)+esc*F3(1,1)], [F3(2,4) F3(2,4)+esc*F3(2,1)], [F3(3,4) F3(3,4)+esc*F3(3,1)], 'b', 'linewidth', 2);
text(F3(1,4)+esc*F3(1,1), F3(2,4)+esc*F3(2,1), F3(3,4)+esc*F3(3,1), 'x_{\{3\}}');
plot3([F3(1,4) F3(1,4)+esc*F3(1,2)], [F3(2,4) F3(2,4)+esc*F3(2,2)], [F3(3,4) F3(3,4)+esc*F3(3,2)], 'g', 'linewidth', 2);
text(F3(1,4)+esc*F3(1,2), F3(2,4)+esc*F3(2,2), F3(3,4)+esc*F3(3,2), 'y_{\{3\}}');
plot3([F3(1,4) F3(1,4)+esc*F3(1,3)], [F3(2,4) F3(2,4)+esc*F3(2,3)], [F3(3,4) F3(3,4)+esc*F3(3,3)], 'r', 'linewidth', 2);
text(F3(1,4)+esc*F3(1,3), F3(2,4)+esc*F3(2,3), F3(3,4)+esc*F3(3,3), 'z_{\{3\}}');
