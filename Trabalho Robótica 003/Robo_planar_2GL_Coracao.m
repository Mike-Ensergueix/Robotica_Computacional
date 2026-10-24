% ===================================================
% Robo planar 2GL - Item D: curva coracao (Octave)
% Curva: segunda curva coracao implicita (MathWorld, Heart Curve)
%        x^2 + (y - (x^2)^(1/3))^2 = 1
% Tabela DH: Ai | d | theta | a | alpha
% ===================================================
clear all; close all; clc;

% ---------------------------------------------------
% Parametros
% ---------------------------------------------------
L1 = 1; L2 = 1;        % comprimentos dos elos
pausa = 0.05;          % pausa entre quadros [s]
N  = 120;              % numero de pontos do caminho

% Adaptacao da curva ao manipulador (escala e deslocamento)
esc = 1.2;             % fator de escala
x0  = 0;               % deslocamento em x
y0  = -0.25;           % deslocamento em y (centraliza o coracao na base)

% ---------------------------------------------------
% Curva coracao
% Parametrizacao: x = cos(t), y = |cos(t)|^(2/3) + sin(t)
% (satisfaz x^2 + (y - (x^2)^(1/3))^2 = 1, pois y - |x|^(2/3) = sin(t))
% O caminho comeca no encontro dos lobos, em (0, 1), e percorre
% o coracao no sentido horario.
% ---------------------------------------------------
t  = linspace(pi/2, pi/2 - 2*pi, 20001);
xd = cos(t);
yd = abs(cos(t)).^(2/3) + sin(t);

% Reamostragem com pontos igualmente espacados ao longo da curva
ds   = sqrt(diff(xd).^2 + diff(yd).^2);
sarc = [0, cumsum(ds)];
sq   = linspace(0, sarc(end), N);
xc   = interp1(sarc, xd, sq);
yc   = interp1(sarc, yd, sq);

Caminho.x = x0 + esc * xc;
Caminho.y = y0 + esc * yc;
x = Caminho.x;
y = Caminho.y;

% ---------------------------------------------------
% Matriz de Denavit-Hartenberg (numerica, theta em radianos)
% Mesma matriz A_DH da cinematica direta
% ---------------------------------------------------
DH = @(th, d, a, al) [cos(th), -sin(th)*cos(al),  sin(th)*sin(al), a*cos(th);
                      sin(th),  cos(th)*cos(al), -cos(th)*sin(al), a*sin(th);
                      0,        sin(al),          cos(al),         d;
                      0,        0,                0,               1];

% ---------------------------------------------------
% Cinematica inversa em forma fechada, para todos os pontos
% cfg = 1: cotovelo para cima  (sen(th2) < 0)
% cfg = 2: cotovelo para baixo (sen(th2) > 0)
% ---------------------------------------------------
c2 = (x.^2 + y.^2 - (L1^2 + L2^2)) / (2*L1*L2);

% Restricao fisica: -1 <= cos(th2) <= 1 (ponto dentro do alcance)
fora = abs(c2) > 1 + 1e-12;
c2 = max(min(c2, 1), -1);
c2(fora) = NaN;

s2 = sqrt(1 - c2.^2);              % modulo de sen(th2)

for cfg = 1:2
    if cfg == 1
        s2c = -s2;                 % cotovelo para cima
    else
        s2c = +s2;                 % cotovelo para baixo
    end
    th2 = atan2(s2c, c2);
    k1  = L1 + L2*c2;
    k2  = L2*s2c;
    th1 = atan2(y, x) - atan2(k2, k1);
    th1 = atan2(sin(th1), cos(th1));   % angulo em (-180, 180] graus

    Th1(cfg,:) = th1;
    Th2(cfg,:) = th2;
end

% ---------------------------------------------------
% Figura: robo (esquerda) e angulos das juntas (direita)
% ---------------------------------------------------
cor  = {[1 0 0], [0 0 1]};     % vermelho: cima | azul: baixo
erro = zeros(1,2);
xe = nan(1,N); ye = nan(1,N);  % trajetoria real do efetuador

figure(1); clf;
set(gcf, 'Position', [50 50 1200 650]);

% Robo em acao:
for k = 1:N
    % ---------------- Robo ----------------
    subplot(2,2,[1 3]); cla; hold on;
    plot(x, y, 'og', 'markersize', 3);                    % coracao desejado
    plot(0, 0, 'ks', 'markersize', 8, 'linewidth', 1.5);  % base

    for cfg = 1:2
        t1 = Th1(cfg,k);
        t2 = Th2(cfg,k);

        % Cinematica direta (matrizes DH)
        A1 = DH(t1, 0, L1, 0);
        A2 = DH(t2, 0, L2, 0);
        F1 = A1;
        F2 = A1 * A2;
        p1 = F1(1:2,4);            % junta 2
        p2 = F2(1:2,4);            % efetuador

        plot([0 p1(1) p2(1)], [0 p1(2) p2(2)], '-', ...
             'color', cor{cfg}, 'linewidth', 2);
        plot(p1(1), p1(2), 'o', 'color', cor{cfg}, 'linewidth', 1.5);
        plot(p2(1), p2(2), 'o', 'color', cor{cfg}, 'linewidth', 1.5);

        % erro entre o efetuador e o ponto do caminho
        e = norm(p2 - [x(k); y(k)]);
        if ~isnan(e)
            erro(cfg) = max(erro(cfg), e);
        end
        if cfg == 1
            xe(k) = p2(1);
            ye(k) = p2(2);
        end
    end

    plot(xe(1:k), ye(1:k), 'm', 'linewidth', 2);          % trajetoria do efetuador

    axis equal; axis([-2.2 2.2 -2.2 2.2]); grid on;
    xlabel('x'); ylabel('y');
    title(sprintf('Curva coracao | k = %d | x = %.2f, y = %.2f', k, x(k), y(k)));
    text(-2.1, -1.85, 'vermelho: cotovelo para cima', 'color', cor{1}, 'fontsize', 8);
    text(-2.1, -2.10, 'azul: cotovelo para baixo',    'color', cor{2}, 'fontsize', 8);
    hold off;

    % ---------------- Junta 1 ----------------
    subplot(2,2,2); cla; hold on;
    plot(1:k, rad2deg(Th1(1,1:k)), 'r', 'linewidth', 1.5);
    plot(1:k, rad2deg(Th1(2,1:k)), 'b', 'linewidth', 1.5);
    axis([1 N -180 180]); grid on;
    title('Junta 1'); ylabel('\theta_1 [graus]');
    hold off;

    % ---------------- Junta 2 ----------------
    subplot(2,2,4); cla; hold on;
    plot(1:k, rad2deg(Th2(1,1:k)), 'r', 'linewidth', 1.5);
    plot(1:k, rad2deg(Th2(2,1:k)), 'b', 'linewidth', 1.5);
    axis([1 N -180 180]); grid on;
    title('Junta 2'); xlabel('iteracoes [k]'); ylabel('\theta_2 [graus]');
    hold off;

    drawnow;
    pause(pausa);
end

% ---------------------------------------------------
% Resumo
% ---------------------------------------------------
r = sqrt(x.^2 + y.^2);
printf('Curva coracao: %d pontos, %d fora do alcance\n', N, sum(fora));
printf('Distancia da base: minima = %.3f, maxima = %.3f\n', min(r), max(r));
printf('Erro maximo (cima/baixo) = %.2e / %.2e\n', erro(1), erro(2));
