% ===================================================
% Robo Planar 2GL - Trabalho 003 (Completo)
% Cinemática Direta e Inversa em Forma Fechada
% Alunos: Mike Junior dos Santos Vargas Ensergueix (RA: 25022492)
%         Vinicius Oliveira Araujo (RA: 25018155)
% Professor: Douglas de Assis Ferreira
% ===================================================

clc; clear all; close all;

% ---------------------------------------------------
% Menu de seleção do caminho
% ---------------------------------------------------
while true
    n_caminho = input(['Entre com o número do caminho:\n' ...
                       ' 1) Reta\n' ...
                       ' 2) Semi-círculo\n' ...
                       ' 3) Cúbica\n' ...
                       ' 4) Coração (Heart Curve)\n' ...
                       '> ']);
    
    if ismember(n_caminho, [1 2 3 4])
        break;
    else
        disp('Opção inválida. Tente novamente.');
    end
end

% ---------------------------------------------------
% Definição dos caminhos
% ---------------------------------------------------
L1 = 1; L2 = 1;        % Comprimentos dos elos
pausa = 0.01;           % Pausa entre quadros

switch n_caminho
    case 1
        % Caminho 1: Reta
        Caminho.x = -1:0.05:1;
        Caminho.y = tand(30) * Caminho.x + 0.5;
        nome_caminho = 'Caminho 1: Reta';
        
    case 2
        % Caminho 2: Semi-círculo
        alpha = 0:2:180;
        Caminho.x = 0.5 + 1.2 * cosd(alpha);
        Caminho.y = 1.2 * sind(alpha);
        nome_caminho = 'Caminho 2: Semi-círculo';
        
    case 3
        % Caminho 3: Cúbica
        Caminho.x = -1:0.05:1;
        Caminho.y = Caminho.x.^3 + 0.5;
        nome_caminho = 'Caminho 3: Cúbica';
        
    case 4
        % Caminho 4: Curva Coração (Heart Curve) - MathWorld
        % x^2 + (y - (x^2)^(1/3))^2 = 1
        % Parametrização: x = cos(t), y = |cos(t)|^(2/3) + sin(t)
        t  = linspace(pi/2, pi/2 - 2*pi, 20001);
        xd = cos(t);
        yd = abs(cos(t)).^(2/3) + sin(t);
        
        % Reamostragem com pontos igualmente espaçados ao longo da curva
        ds   = sqrt(diff(xd).^2 + diff(yd).^2);
        sarc = [0, cumsum(ds)];
        sq   = linspace(0, sarc(end), 120);
        xc   = interp1(sarc, xd, sq);
        yc   = interp1(sarc, yd, sq);
        
        % Adaptação ao manipulador (escala e deslocamento)
        esc = 1.2;
        x0  = 0;
        y0  = -0.25;
        Caminho.x = x0 + esc * xc;
        Caminho.y = y0 + esc * yc;
        nome_caminho = 'Caminho 4: Curva Coração (Heart Curve)';
        
    otherwise
        % Caso padrão
        Caminho.x = -1:0.05:1;
        Caminho.y = tand(30) * Caminho.x + 0.5;
        nome_caminho = 'Caminho 1: Reta';
end

% Visualização inicial do caminho
figure(1); clf;
plot(Caminho.x, Caminho.y, 'g-', 'LineWidth', 2); 
hold on;
plot(Caminho.x(1), Caminho.y(1), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
plot(Caminho.x(end), Caminho.y(end), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
hold off;
axis equal; grid on;
title(nome_caminho);
xlabel('x'); ylabel('y');
legend('Trajetória', 'Ponto Inicial', 'Ponto Final', 'Location', 'best');
pause(2);

% Vetores para armazenamento dos ângulos
theta1_cima = [];
theta2_cima = [];
theta1_baixo = [];
theta2_baixo = [];

x1_c = []; y1_c = []; x2_c = []; y2_c = []; % Cotovelo para cima
x1_b = []; y1_b = []; x2_b = []; y2_b = []; % Cotovelo para baixo

% ---------------------------------------------------
% Cinemática Inversa e Simulação
% ---------------------------------------------------
figure(2); clf;
set(gcf, 'Position', [50 50 1300 700]);

for k = 1:length(Caminho.x)
    x = Caminho.x(k);
    y = Caminho.y(k);
    
    % Cálculo de cos(theta2) pela lei dos cossenos
    c_th2 = (x^2 + y^2 - (L1^2 + L2^2)) / (2*L1*L2);
    
    if abs(c_th2) > 1 + 1e-12
        % Ponto fora do espaço de trabalho
        if k == 1
            continue;
        else
            % Mantém último valor válido
            x1_c(k)=x1_c(k-1); y1_c(k)=y1_c(k-1); x2_c(k)=x2_c(k-1); y2_c(k)=y2_c(k-1);
            x1_b(k)=x1_b(k-1); y1_b(k)=y1_b(k-1); x2_b(k)=x2_b(k-1); y2_b(k)=y2_b(k-1);
            theta1_cima(k)=theta1_cima(k-1); theta2_cima(k)=theta2_cima(k-1);
            theta1_baixo(k)=theta1_baixo(k-1); theta2_baixo(k)=theta2_baixo(k-1);
        end
    else
        % Limita ao intervalo válido
        if c_th2 > 1; c_th2 = 1; end
        if c_th2 < -1; c_th2 = -1; end
        
        s_th2_mod = sqrt(1 - c_th2^2);
        
        % ========== CONFIGURAÇÃO 1: COTOVELO PARA CIMA (s_th2 < 0) ==========
        s_th2_cima = -s_th2_mod;
        th2_c = atan2(s_th2_cima, c_th2);
        k1_c = L1 + L2*c_th2;
        k2_c = L2*s_th2_cima;
        r_c  = sqrt(k1_c^2 + k2_c^2);
        th1_c = atan2(y/r_c, x/r_c) - atan2(k2_c, k1_c);
        th1_c = atan2(sin(th1_c), cos(th1_c)); % Normalização
        
        % Cinemática direta - Cotovelo para cima
        x1_c(k) = L1*cos(th1_c);
        y1_c(k) = L1*sin(th1_c);
        x2_c(k) = L1*cos(th1_c) + L2*cos(th1_c + th2_c);
        y2_c(k) = L1*sin(th1_c) + L2*sin(th1_c + th2_c);
        
        % Armazena ângulos em graus
        theta1_cima(k) = rad2deg(th1_c);
        theta2_cima(k) = rad2deg(th2_c);
        
        % ========== CONFIGURAÇÃO 2: COTOVELO PARA BAIXO (s_th2 > 0) ==========
        s_th2_baixo = +s_th2_mod;
        th2_b = atan2(s_th2_baixo, c_th2);
        k1_b = L1 + L2*c_th2;
        k2_b = L2*s_th2_baixo;
        r_b  = sqrt(k1_b^2 + k2_b^2);
        th1_b = atan2(y/r_b, x/r_b) - atan2(k2_b, k1_b);
        th1_b = atan2(sin(th1_b), cos(th1_b)); % Normalização
        
        % Cinemática direta - Cotovelo para baixo
        x1_b(k) = L1*cos(th1_b);
        y1_b(k) = L1*sin(th1_b);
        x2_b(k) = L1*cos(th1_b) + L2*cos(th1_b + th2_b);
        y2_b(k) = L1*sin(th1_b) + L2*sin(th1_b + th2_b);
        
        % Armazena ângulos em graus
        theta1_baixo(k) = rad2deg(th1_b);
        theta2_baixo(k) = rad2deg(th2_b);
    end
    
    % -------------------- PLOTS --------------------
    % Subplot 1: Simulação do robô
    subplot(2,3,[1,2,4,5])
    cla; hold on;
    % Trajetória desejada
    plot(Caminho.x, Caminho.y, 'g*', 'MarkerSize', 3);
    % Base
    plot(0,0,'ks','MarkerSize',10,'LineWidth',2);
    
    % Robô - Cotovelo para cima (Vermelho)
    plot([0 x1_c(k)], [0 y1_c(k)], 'r-', 'LineWidth', 3);
    plot([x1_c(k) x2_c(k)], [y1_c(k) y2_c(k)], 'r-', 'LineWidth', 3);
    plot(x1_c(k), y1_c(k), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot(x2_c(k), y2_c(k), 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
    
    % Robô - Cotovelo para baixo (Azul)
    plot([0 x1_b(k)], [0 y1_b(k)], 'b-', 'LineWidth', 3);
    plot([x1_b(k) x2_b(k)], [y1_b(k) y2_b(k)], 'b-', 'LineWidth', 3);
    plot(x1_b(k), y1_b(k), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    plot(x2_b(k), y2_b(k), 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b');
    
    % Trajetória percorrida pelo efetuador
    if k >= 2
        plot(x2_c(1:k), y2_c(1:k), 'r:', 'LineWidth', 1.5);
        plot(x2_b(1:k), y2_b(1:k), 'b:', 'LineWidth', 1.5);
    end
    
    hold off;
    axis equal;
    if max(abs(Caminho.x)) > 1.5 || max(abs(Caminho.y)) > 1.5
        axis([-2.2 2.2 -1.5 2.5]);
    else
        axis([-1.8 1.8 -0.5 2.0]);
    end
    grid on;
    xlabel('x [unidades]');
    ylabel('y [unidades]');
    title(sprintf('%s | Iteração k = %d/%d | P = (%.2f, %.2f)', nome_caminho, k, length(Caminho.x), x, y));
    legend('Trajetória desejada', 'Base', 'Cotovelo p/ Cima', 'Cotovelo p/ Baixo', 'Location', 'northeastoutside');
    
    % Subplot 2: Ângulos da Junta 1
    subplot(2,3,3)
    cla; hold on;
    plot(1:k, theta1_cima(1:k), 'r-', 'LineWidth', 1.5);
    plot(1:k, theta1_baixo(1:k), 'b-', 'LineWidth', 1.5);
    hold off;
    axis([1 length(Caminho.x) -180 180]);
    grid on;
    title('Ângulos da Junta 1');
    xlabel('Iteração k');
    ylabel('\theta_1 [graus]');
    legend('Cotovelo p/ Cima', 'Cotovelo p/ Baixo');
    
    % Subplot 3: Ângulos da Junta 2
    subplot(2,3,6)
    cla; hold on;
    plot(1:k, theta2_cima(1:k), 'r-', 'LineWidth', 1.5);
    plot(1:k, theta2_baixo(1:k), 'b-', 'LineWidth', 1.5);
    hold off;
    axis([1 length(Caminho.x) -180 180]);
    grid on;
    title('Ângulos da Junta 2');
    xlabel('Iteração k');
    ylabel('\theta_2 [graus]');
    legend('Cotovelo p/ Cima', 'Cotovelo p/ Baixo');
    
    drawnow;
    pause(pausa);
end

% ---------------------------------------------------
% Verificação da Cinemática Direta
% ---------------------------------------------------
disp(' ');
disp('=== VERIFICAÇÃO DA CINEMÁTICA DIRETA ===');
for k = [1 round(length(Caminho.x)/2) length(Caminho.x)]
    x_d = Caminho.x(k); y_d = Caminho.y(k);
    err_c = sqrt((x2_c(k)-x_d)^2 + (y2_c(k)-y_d)^2);
    err_b = sqrt((x2_b(k)-x_d)^2 + (y2_b(k)-y_d)^2);
    fprintf('k=%d: P_desejado=(%.3f,%.3f) | Erro_Cima=%.2e | Erro_Baixo=%.2e\n', k, x_d, y_d, err_c, err_b);
end

disp(' ');
disp('Simulação concluída!');
