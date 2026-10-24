clear all;
close all;
clc;

% ============================================================
% Pacote simbolico
% ============================================================
pkg load symbolic

% ============================================================
% Variaveis simbolicas
% ============================================================
syms d th a alpha real
syms th1 th2 a1 a2 real
deg2rad_sym = @(d) sym(d) * sym(pi) / sym(180);
one = sym(1);
zero = sym(0);

% ============================================================
% Matriz de Denavit-Hartenberg
% ============================================================
A_DH = [ cos(th) -sin(th)*cos(alpha)  sin(th)*sin(alpha) a*cos(th)
         sin(th)  cos(th)*cos(alpha) -cos(th)*sin(alpha) a*sin(th)
         zero     sin(alpha)          cos(alpha)         d
         zero     zero                zero               one ];

% ============================================================
% Cadeia de transformacoes do robo planar 2GL (100% simbolica)
% Tabela DH: Ai | d | theta | a | alpha
% ============================================================
% --------- Frame {0} ---------
F0 = sym(eye(4));

% --------- Frame {1} ---------
% i1: d = 0, theta = th1, a = a1 (L1), alpha = 0
A1 = subs(A_DH, [d th a alpha], [zero th1 a1 zero]);
F1 = F0 * A1;

% --------- Frame {2} ---------
% i2: d = 0, theta = th2, a = a2 (L2), alpha = 0
A2 = subs(A_DH, [d th a alpha], [zero th2 a2 zero]);
F2 = F1 * A2;

% ============================================================
% Exibicao das transformacoes
% ============================================================
disp('A1:')
pretty(A1)
disp('A2:')
pretty(A2)

A02 = simplify(F2);
disp('A02:')
pretty(A02)

% ============================================================
% Parametros numericos (L1 = L2 = 1)
% ============================================================
t1s = deg2rad_sym(30);
t2s = deg2rad_sym(60);
a1s = sym(1);
a2s = sym(1);

A02_num = subs(A02, [th1 th2 a1 a2], [t1s t2s a1s a2s]);
A02_num = double(vpa(A02_num, 12));

disp('A02 numerica:')
disp(A02_num)

% --------- Substituicoes -> vpa -> double ---------
F0 = eye(4);
F1 = double(vpa(subs(F1, [th1 a1], [t1s a1s]), 12));
F2 = double(vpa(subs(F2, [th1 th2 a1 a2], [t1s t2s a1s a2s]), 12));

% ==== Plot ====
figure(1); clf;
axis equal; grid on; view(2);
xlabel('x'); ylabel('y'); hold on;
esc = 0.5;
mark = 1;
F = {F0, F1, F2};

% Elos
plot([F0(1,4) F1(1,4)], [F0(2,4) F1(2,4)], 'k', 'linewidth', 2);
plot([F1(1,4) F2(1,4)], [F1(2,4) F2(2,4)], 'k', 'linewidth', 2);

% Frames {0}, {1} e {2}
for i = 1:3
    Fi = F{i};
    o = Fi(1:3,4);
    plot3(o(1), o(2), o(3), 'om', 'linewidth', 2, 'markersize', mark);
    text(o(1), o(2)-0.1, o(3), sprintf('\\{%d\\}', i-1));

    % eixo x (azul)
    plot3([o(1) o(1)+esc*Fi(1,1)], [o(2) o(2)+esc*Fi(2,1)], [o(3) o(3)+esc*Fi(3,1)], 'b', 'linewidth', 2);
    text(o(1)+esc*Fi(1,1), o(2)+esc*Fi(2,1), o(3)+esc*Fi(3,1), sprintf('x_{\\{%d\\}}', i-1));

    % eixo y (verde)
    plot3([o(1) o(1)+esc*Fi(1,2)], [o(2) o(2)+esc*Fi(2,2)], [o(3) o(3)+esc*Fi(3,2)], 'g', 'linewidth', 2);
    text(o(1)+esc*Fi(1,2), o(2)+esc*Fi(2,2), o(3)+esc*Fi(3,2), sprintf('y_{\\{%d\\}}', i-1));

    % eixo z (vermelho)
    plot3([o(1) o(1)+esc*Fi(1,3)], [o(2) o(2)+esc*Fi(2,3)], [o(3) o(3)+esc*Fi(3,3)], 'r', 'linewidth', 2);
    text(o(1)+esc*Fi(1,3), o(2)+esc*Fi(2,3), o(3)+esc*Fi(3,3), sprintf('z_{\\{%d\\}}', i-1));
end

title(sprintf('End-effector: x = %.3f, y = %.3f, z = %.3f', F2(1,4), F2(2,4), F2(3,4)));
