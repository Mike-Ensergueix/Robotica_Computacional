% ===================================================
% Robo planar 2GL - Cinematica inversa em forma fechada (Octave)
% Simulacao dos 3 caminhos ao mesmo tempo, lado a lado
% Tabela DH: Ai | d | theta | a | alpha
% ===================================================
clear all; close all; clc;

% ---------------------------------------------------
% Parametros
% ---------------------------------------------------
L1 = 1; L2 = 1;        % comprimentos dos elos
pausa = 0.05;          % pausa entre quadros [s]

% ---------------------------------------------------
% Caminhos (conforme o enunciado)
% ---------------------------------------------------
Caminho(1).x    = -1:0.05:1;
Caminho(1).y    = tand(30) * Caminho(1).x + 0.5;
Caminho(1).nome = 'Caminho 1: reta';

Caminho(2).x    = 0.5 + 1.2 * cosd(0:2:180);
Caminho(2).y    = 1.2 * sind(0:2:180);
Caminho(2).nome = 'Caminho 2: semi-circulo';

Caminho(3).x    = -1:0.05:1;
Caminho(3).y    = Caminho(3).x.^3 + 0.5;
Caminho(3).nome = 'Caminho 3: cubica';

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
for i = 1:3
    x = Caminho(i).x;
    y = Caminho(i).y;
    N(i) = length(x);

    % cos(th2) pela lei dos cossenos
    c2 = (x.^2 + y.^2 - (L1^2 + L2^2)) / (2*L1*L2);

    % Restricao fisica: -1 <= cos(th2) <= 1 (ponto dentro do alcance)
    fora = abs(c2) > 1 + 1e-12;
    c2 = max(min(c2, 1), -1);
    c2(fora) = NaN;
    Fora(i) = sum(fora);

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

        Th(i).th1(cfg,:) = th1;
        Th(i).th2(cfg,:) = th2;
    end
end

% ---------------------------------------------------
% Figura: 3 caminhos lado a lado
% linha 1 (2 linhas de altura): robo | linha 3: junta 1 | linha 4: junta 2
% ---------------------------------------------------
cor  = {[1 0 0], [0 0 1]};     % vermelho: cima | azul: baixo
Nmax = max(N);
erro = zeros(3,2);

figure(1); clf;
set(gcf, 'Position', [50 50 1350 800]);

% Robo em acao: os tres caminhos comecam no mesmo instante (k = 1)
for k = 1:Nmax
    for i = 1:3
        kk = min(k, N(i));             % caminho que terminou fica parado no fim
        x = Caminho(i).x;
        y = Caminho(i).y;

        % ---------------- Robo ----------------
        subplot(4,3,[i, 3+i]); cla; hold on;
        plot(x, y, '*g', 'markersize', 4);                 % caminho
        plot(0, 0, 'ks', 'markersize', 8, 'linewidth', 1.5); % base

        for cfg = 1:2
            t1 = Th(i).th1(cfg,kk);
            t2 = Th(i).th2(cfg,kk);

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
            e = norm(p2 - [x(kk); y(kk)]);
            if ~isnan(e)
                erro(i,cfg) = max(erro(i,cfg), e);
            end
        end

        axis equal; axis([-1.5 2 -1.5 2.2]); grid on;
        xlabel('x'); ylabel('y');
        title(sprintf('%s\nx = %.2f, y = %.2f', Caminho(i).nome, x(kk), y(kk)));
        text(-1.4, -1.15, 'vermelho: cotovelo para cima', 'color', cor{1}, 'fontsize', 8);
        text(-1.4, -1.40, 'azul: cotovelo para baixo',    'color', cor{2}, 'fontsize', 8);
        hold off;

        % ---------------- Junta 1 ----------------
        subplot(4,3,6+i); cla; hold on;
        plot(1:kk, rad2deg(Th(i).th1(1,1:kk)), 'r', 'linewidth', 1.5);
        plot(1:kk, rad2deg(Th(i).th1(2,1:kk)), 'b', 'linewidth', 1.5);
        axis([1 N(i) -180 180]); grid on;
        title('Junta 1'); ylabel('\theta_1 [graus]');
        hold off;

        % ---------------- Junta 2 ----------------
        subplot(4,3,9+i); cla; hold on;
        plot(1:kk, rad2deg(Th(i).th2(1,1:kk)), 'r', 'linewidth', 1.5);
        plot(1:kk, rad2deg(Th(i).th2(2,1:kk)), 'b', 'linewidth', 1.5);
        axis([1 N(i) -180 180]); grid on;
        title('Junta 2'); xlabel('iteracoes [k]'); ylabel('\theta_2 [graus]');
        hold off;
    end
    drawnow;
    pause(pausa);
end

% ---------------------------------------------------
% Resumo
% ---------------------------------------------------
for i = 1:3
    printf('%s: %d pontos, %d fora do alcance, erro maximo (cima/baixo) = %.2e / %.2e\n', ...
           Caminho(i).nome, N(i), Fora(i), erro(i,1), erro(i,2));
end
