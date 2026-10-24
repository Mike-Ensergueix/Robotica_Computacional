% ===============
% Robo Planar 2GL (Octave)
% ===============
clc; clear all; close all;

while true
  n_caminho = input(['Entre com o número do caminho:\n' ...
                     ' 1) Reta\n 2) Semi-círculo\n 3) Cúbica\n 4) Coração\n> ']);

  switch n_caminho
    case 1
      % Caminho 1: reta
      Caminho.x = -1:0.01:1;
      Caminho.y = tand(30) * Caminho.x + 0.5;
      break;


    otherwise
      disp('Opção inválida. Tente novamente.');
  endswitch
endwhile

%Exemplo de visualização rápida
figure; plot(Caminho.x, Caminho.y, 'LineWidth', 2); axis equal; grid on;
title(sprintf('Caminho %d', n_caminho));

% Comprimentos dos elos (links)
L1 = 1; % escolha como quiser
L2 = 1; % escolha como quiser

theta1=[];
theta2=[];
theta1c=[];
theta2c=[];

% Robo em acao:
for k = 1:length(Caminho.x)

 x = Caminho.x(k);
 y = Caminho.y(k);
c_th2 = (x.^2 + y.^2 - (L1^2 + L2^2))/(2*L1*L2);
if(abs(c_th2)>1)%fora workspace

    continue
else%cotovelo para cima
    s_th2 = sqrt(1 - (c_th2).^2);
    th2 = atan2(s_th2, c_th2);
    k1 = L1 + L2*c_th2;
    k2 = L2*s_th2;
    r = sqrt(k1.^2 + k2.^2);
    th1 = atan2(y./r, x./r) - atan2(k2, k1);

  %cotovelo para baixo
    s_th2 = -sqrt(1 - (c_th2).^2);%%%
    th2c = atan2(s_th2, c_th2);
    k1 = L1 + L2*c_th2;
    k2 = L2*s_th2;
    r = sqrt(k1.^2 + k2.^2);
    th1c = atan2(y./r, x./r) - atan2(k2, k1);
end

    th1=rad2deg(th1);
    th2=rad2deg(th2);
    th1c=rad2deg(th1c);
    th2c=rad2deg(th2c);
    % -------------
    % Robo completo
    % -------------
    % Link 1: da base (0,0) ate o final do link 1 (x1,y1)
    x1(k) = L1 * cosd(th1);
    y1(k) = L1 * sind(th1);
    % Link 2: do link 1 (x1,y1) ate o final do link 2 (x2,y2)
    % Neste local se encontra o punho do robo
    x2(k) = L1 * cosd(th1) + L2 * cosd(th1 + th2);
    y2(k) = L1 * sind(th1) + L2 * sind(th1 + th2);

    theta1=[theta1,th1];
    theta2=[theta2,th2];
    theta1c=[theta1c,th1c];
    theta2c=[theta2c,th2c];



    % -----
    % Plots
    % -----

    subplot(2,6,[3,4])
    axis([0 k -360 360])
    hold on
    plot( theta1, 'b')
    title('Junta 1 ')
    grid on
    hold off % terminamos de plotar tudo

    subplot(2,6,[5,6])
    axis([0 k -360 360])
    hold on
    plot(theta2 , 'b' )
    title('Junta 2 / Cotovelo para Cima')
    ylabel('Angulo da junta 2 [graus]') % nome do eixo-y
    set(gca,'yaxislocation','right');
    grid on
    hold off % terminamos de plotar tudo
%

 subplot(2,6,[9,10])
    axis([0 k -360 360])
    hold on
    plot( theta1c, 'r')
    title('Junta 1 ')
    grid on
    hold off % terminamos de plotar tudo

    subplot(2,6,[11,12])
    axis([0 k -360 360])
    hold on
    plot(theta2c , 'r' )
    title('Junta 2 / Cotovelo para Cima')
    ylabel('Angulo da junta 2 [graus]') % nome do eixo-y
    set(gca,'yaxislocation','right');
    grid on
    hold off % terminamos de plotar tudo
%

     subplot(2,6,[1,2,7,8])
    % Link1: da base (0,0) ate o final do primeiro link (x1,y1)
    plot([0 x1(k)] , [0 y1(k)] , 'k' , 'linewidth' , 2)
    hold on % plotaremos mais coisas na mesma figura
    % Link2: do link1 (x1,y2) ate o final do segundo link (x2,y2)
    plot([x1(k) x2(k)] , [y1(k) y2(k)] , 'k' , 'linewidth' , 2)
    % Primeira junta rotacional: esta na base
    plot(0 , 0 , 'og' , 'linewidth' , 2 , 'markersize' , 10)
    plot(0 , 0 , 'og' , 'linewidth' , 2 , 'markersize' , 15)
    % Segunda junta rotacional: esta no final do primeiro link
    plot(x1(k) , y1(k) , 'or' , 'linewidth' , 2 , 'markersize' , 10)
    plot(x1(k) , y1(k) , 'or' , 'linewidth' , 2 , 'markersize' , 15)
    % Punho: esta no final do segundo link
    plot(x2(k) , y2(k) , 'sb' , 'linewidth' , 2 , 'markersize' , 10)
    plot(x2(k) , y2(k) , 'sb' , 'linewidth' , 2 , 'markersize' , 15)
    % Caminho da segunda junta:
    %plot(x1 , y1 , 'r')
    % Caminho do punho:
    plot(x2 , y2 , 'b')
    % Textos:
    text(0 , 0.2 , 'junta1')
    text(x1(k) , y1(k)+0.2 , 'junta2')
    text(x2(k) , y2(k)+0.2 , 'punho')


    %cotovelo para baixo
    x1(k) = L1 * cosd(th1c);
    y1(k) = L1 * sind(th1c);
    % Link 2: do link 1 (x1,y1) ate o final do link 2 (x2,y2)
    % Neste local se encontra o punho do robo
    x2(k) = L1 * cosd(th1c) + L2 * cosd(th1c + th2c);
    y2(k) = L1 * sind(th1c) + L2 * sind(th1c + th2c);

    plot([0 x1(k)] , [0 y1(k)] , 'k' , 'linewidth' , 2)
    hold on % plotaremos mais coisas na mesma figura
    % Link2: do link1 (x1,y2) ate o final do segundo link (x2,y2)
    plot([x1(k) x2(k)] , [y1(k) y2(k)] , 'k' , 'linewidth' , 2)
    % Primeira junta rotacional: esta na base
    plot(0 , 0 , 'og' , 'linewidth' , 2 , 'markersize' , 10)
    plot(0 , 0 , 'og' , 'linewidth' , 2 , 'markersize' , 15)
    % Segunda junta rotacional: esta no final do primeiro link
    plot(x1(k) , y1(k) , 'or' , 'linewidth' , 2 , 'markersize' , 10)
    plot(x1(k) , y1(k) , 'or' , 'linewidth' , 2 , 'markersize' , 15)
    % Punho: esta no final do segundo link
    plot(x2(k) , y2(k) , 'sb' , 'linewidth' , 2 , 'markersize' , 10)
    plot(x2(k) , y2(k) , 'sb' , 'linewidth' , 2 , 'markersize' , 15)
    % Caminho da segunda junta:
    %plot(x1 , y1 , 'r')
    % Caminho do punho:
    plot(x2 , y2 , 'b')
    % Textos:
    text(0 , 0.2 , 'junta1')
    text(x1(k) , y1(k)+0.2 , 'junta2')
    text(x2(k) , y2(k)+0.2 , 'punho')




    hold off % terminamos de plotar tudo
    xlabel('x') % nome do eixo-x
    ylabel('y') % nome do eixo-y
    axis equal % eixos com a mesma escala
    grid on % linhas verticais e horizontais
    drawnow % desenhe enquanto o loop roda
end

