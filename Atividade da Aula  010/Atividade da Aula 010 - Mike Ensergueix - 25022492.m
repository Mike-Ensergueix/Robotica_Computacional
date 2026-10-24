clear; clc; close all;

% Funcao objetivo
theta = -3:0.05:1;
f_theta = theta.^2 + 2*theta + 1;

% Define um valor aleatorio para x
x = randn;

% Bola que permite a condição de parada e Taxa de aprendizado
ksi = 1e-5;
n = 0.02;

% Calcula o erro inicial
f = x^2 + 2*x + 1;

% Vetores para armazenar os valores
X = x;
F = f;

% Algoritmo do gradiente descendente
while f > ksi

    % Calcula o gradiente
    Grad = 2*x + 2;

    % Atualiza o ponto
    x = x - n * Grad;

    % Calcula o novo erro
    f = x^2 + 2*x + 1;

    % Armazena os valores
    X = [X, x];  
    F = [F, f];  

    % Plot
    subplot(1,2,1);

    plot(theta, f_theta, 'b');
    hold on;
    plot(x, f, 'or', 'MarkerFaceColor', 'r');
    hold off;
    grid on;
    xlabel('x');
    ylabel('f(x)');
    title(['x_k = ', num2str(x)]);

    subplot(1,2,2);

    plot(F, 'r', 'LineWidth', 2);
    grid on;
    xlabel('Iteração k');
    ylabel('f(x_k)');
    axis([0 max(10, length(F)) 0 4]);
    title(['f_k = ', num2str(f)]);

    drawnow;
end

% Exibe o resultado final
disp(['Ponto de minimo encontrado: ', num2str(x)]);
disp(['Erro final: ', num2str(f)]);
disp(['Numero de iteracoes: ', num2str(length(F)-1)]);