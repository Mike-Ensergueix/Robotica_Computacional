clear;      %limpa workspace
close all;  %fecha todas as abas (figures)
clc;        %limpa command window
## Pacote simbólico
pkg load symbolic  %baixa pacote para baixar variáveis simbólicas
% --------- Simbólico base ---------
syms th dx dy dz L1 L2 L3 L4 L5 L6 L7 real      %criação de variaveis simbolicas pertecentes aos Reais
syms th1 th2 th3 th4 th5 th6 th7 real           %criação de variaveis simbolicas pertecentes aos Reais
one = sym(1); zero = sym(0);                    %criação de variaveis com enquivalência simbólica de 1 e 0
deg2rad_sym = @(d) sym(d) * sym(pi) / sym(180); %criação de variável simbolica que transforma graus em radiano
T = [ one zero zero dx                          %criação da matriz de translação simbolica
zero one zero dy
zero zero one dz
zero zero zero one ]
Rx = [ one zero zero zero                       %criação da matriz de rotação do eixo X simbolica
zero cos(th) -sin(th) zero
zero sin(th) cos(th) zero
zero zero zero one ]
Rz = [ cos(th) -sin(th) zero zero               %criação da matriz de rotação do eixo Z simbolica
sin(th) cos(th) zero zero
zero zero one zero
zero zero zero one ]
F0 = sym(eye(4))                                %F0 = Frame Zero contendo uma matriz identidade simbolica (plano cartesiano)
% --------- Cadeia de frames (100% simbólica) ---------
%Tr é a matriz de transformação, representa o deslocamento entre os frames
Tr_0_1 = subs(T, [dx dy dz], [zero zero zero])  %Tr_0_1 substitui os deltas da matriz T por Zeros, transformação de 0 pra 1 sem deslocamento
%TH é a junção do deslocamento com a rotação de um frame pra outro
TH_0_1 = Tr_0_1 * subs(Rz, th, th1)             %TH_0_1 substitui os valores dos angulos da matriz Rz do frame 0 pelos valores dos angulos do frame 1 e multiplica com a TR_0_1 (rotação sem deslocamento)
F1 = F0 * TH_0_1                                %F1 = Frame Um, rotação sem deslocamento em relação ao frame 0
pi2 = sym(pi)/2                                 %pi2 = pi/2
Tr_1_2 = subs(T, [dx dy dz], [zero zero L1]) * subs(Rx, th, pi2) %Tr_1_2 substitui os deltas X e Y em T por zeros e delta Z por L1 (deslocamento no eixo Z) + Rotação no eixo X em 90°
TH_1_2 = Tr_1_2 * subs(Rz, th, th2)             %junção de deslocamento no Eixo Z + rotação do Eixo X com rotação do Eixo Z (contendo os angulos do Frame 2)
F2 = F1 * TH_1_2;                               %F2 = Frame 2, deslocamento no Eixo Z + rotação do eixo X e rotação do Eixo Z em relação ao Frame 1
Tr_2_3 = subs(T, [dx dy dz], [zero L2 zero]) * subs(Rx, th, -pi2) %Tr_2_3 substitui os deltas X e Z em T por zeros e delta Y por L2 (deslocamento no eixo Y) + Rotação no eixo X em 90°
TH_2_3 = Tr_2_3 * subs(Rz, th, th3);            %junção de deslocamento no Eixo Y + rotação do Eixo X com rotação do Eixo Z (contendo os angulos do Frame 3)
F3 = F2 * TH_2_3;                               %F3 = Frame 3, deslocamento no Eixo Y + rotação do eixo X e rotação do Eixo Z em relação ao Frame 2
Tr_3_4 = subs(T, [dx dy dz], [zero zero L3]) * subs(Rx, th, pi2); %Tr_3_4 substitui os deltas X e Y em T por zeros e delta Z por L1 (deslocamento no eixo Z) + Rotação no eixo X em 90°
TH_3_4 = Tr_3_4 * subs(Rz, th, th4);            %junção de deslocamento no Eixo Z + rotação do Eixo X com rotação do Eixo Z (contendo os angulos do Frame 4)
F4 = F3 * TH_3_4;                               %F4 = Frame 4, deslocamento no Eixo Z + rotação do eixo X e rotação do Eixo Z em relação ao Frame 3
Tr_4_5 = subs(T, [dx dy dz], [zero L4 zero]) * subs(Rx, th, -pi2);%Tr_4_5 substitui os deltas X e Z em T por zeros e delta Y por L2 (deslocamento no eixo Y) + Rotação no eixo X em 90°
TH_4_5 = Tr_4_5 * subs(Rz, th, th5);            %junção de deslocamento no Eixo Y + rotação do Eixo X com rotação do Eixo Z (contendo os angulos do Frame 5)
F5 = F4 * TH_4_5;                               %F5 = Frame 5, deslocamento no Eixo Z + rotação do eixo X e rotação do Eixo Z em relação ao Frame 4
Tr_5_6 = subs(T, [dx dy dz], [zero zero L5]) * subs(Rx, th, pi2); %Tr_5_6 substitui os deltas X e Y em T por zeros e delta Z por L1 (deslocamento no eixo Z) + Rotação no eixo X em 90°
TH_5_6 = Tr_5_6 * subs(Rz, th, th6);            %junção de deslocamento no Eixo Z + rotação do Eixo X com rotação do Eixo Z (contendo os angulos do Frame 6)
F6 = F5 * TH_5_6;                               %F6 = Frame 6, deslocamento no Eixo Z + rotação do eixo X e rotação do Eixo Z em relação ao Frame 5
Tr_6_7 = subs(T, [dx dy dz], [zero L6 zero]) * subs(Rx, th, -pi2);%Tr_6_7 substitui os deltas X e Z em T por zeros e delta Y por L2 (deslocamento no eixo Y) + Rotação no eixo X em 90°
TH_6_7 = Tr_6_7 * subs(Rz, th, th7);            %junção de deslocamento no Eixo Z + rotação do Eixo X com rotação do Eixo Z (contendo os angulos do Frame 7)
F7 = F6 * TH_6_7;                               %F7 = Frame 7, deslocamento no Eixo Z + rotação do eixo X e rotação do Eixo Z em relação ao Frame 6
Tr_7_8 = subs(T, [dx dy dz], [zero zero L7]);   %Tr_7_8 substitui os deltas X e Y em T por zeros e delta Z por L1 (deslocamento no eixo Z)
F8 = F7 * Tr_7_8;                               %F8 = Frame 8, deslocamento no Eixo Z em relação ao Frame 7, no exercicio não é solicitado a ação do end-effector
% --------- Parâmetros numéricos ---------
% comprimentos (strings -> simbólico)
l1s = sym('0.18'); l2s = sym('0.169'); l3s = sym('0.159');
l4s = sym('0.14825'); l5s = sym('0.12825'); l6s = sym('0.12585');
l7s = sym('0.04585');
% ângulos em rad (simbólicos)
t1s = deg2rad_sym(0); t2s = deg2rad_sym(45); t3s = deg2rad_sym(0);
t4s = deg2rad_sym(0); t5s = deg2rad_sym(0); t6s = deg2rad_sym(0);
t7s = deg2rad_sym(45); % pose exemplo
% --------- Substituições -> vpa -> double ---------
F0 = eye(4);
F1 = double(vpa(subs(F1, th1, t1s), 12));
F2 = double(vpa(subs(F2, [L1 th1 th2], [l1s t1s t2s]), 12));
F3 = double(vpa(subs(F3, [L2 L1 th1 th2 th3], [l2s l1s t1s t2s t3s]), 12));
F4 = double(vpa(subs(F4, [L3 L2 L1 th1 th2 th3 th4], [l3s l2s l1s t1s t2s t3s t4s]), 12));
F5 = double(vpa(subs(F5, [L4 L3 L2 L1 th1 th2 th3 th4 th5], [l4s l3s l2s l1s t1s t2s t3s t4s t5s]),12));
F6 = double(vpa(subs(F6, [L5 L4 L3 L2 L1 th1 th2 th3 th4 th5 th6], [l5s l4s l3s l2s l1s t1s t2s t3s t4s t5s t6s]), 12));
F7 = double(vpa(subs(F7, [L6 L5 L4 L3 L2 L1 th1 th2 th3 th4 th5 th6 th7], [l6s l5s l4s l3s l2s l1s t1s t2s t3s t4s t5s t6s t7s]), 12));
F8 = double(vpa(subs(F8, [L7 L6 L5 L4 L3 L2 L1 th1 th2 th3 th4 th5 th6 th7], [l7s l6s l5s l4s l3s l2s l1s t1s t2s t3s t4s t5s t6s t7s]), 12));
% ==== Plot ====
figure(1); clf;
axis equal; grid on; view(3);
xlabel('x'); ylabel('y'); zlabel('z'); hold on;
esc = 0.1;
mark = 5;
% ---------- Frame {0} ----------
plot3(F0(1,4), F0(2,4), F0(3,4), 'om', 'linewidth', 2, 'markersize', mark);
plot3([F0(1,4) F0(1,4)+esc*F0(1,1)], [F0(2,4) F0(2,4)+esc*F0(2,1)], [F0(3,4) F0(3,4)+esc*F0(3,1)], 'b','linewidth', 2);
text( F0(1,4)+esc*F0(1,1), F0(2,4)+esc*F0(2,1), F0(3,4)+esc*F0(3,1), 'x_{\{0\}}');
plot3([F0(1,4) F0(1,4)+esc*F0(1,2)], [F0(2,4) F0(2,4)+esc*F0(2,2)], [F0(3,4) F0(3,4)+esc*F0(3,2)], 'g','linewidth', 2);
text( F0(1,4)+esc*F0(1,2), F0(2,4)+esc*F0(2,2), F0(3,4)+esc*F0(3,2), 'y_{\{0\}}');
plot3([F0(1,4) F0(1,4)+esc*F0(1,3)], [F0(2,4) F0(2,4)+esc*F0(2,3)], [F0(3,4) F0(3,4)+esc*F0(3,3)], 'r','linewidth', 2);
text( F0(1,4)+esc*F0(1,3), F0(2,4)+esc*F0(2,3), F0(3,4)+esc*F0(3,3), 'z_{\{0\}}');
plot3([F0(1,4) F1(1,4)], [F0(2,4) F1(2,4)], [F0(3,4) F1(3,4)], 'k');
% ---------- Frame {1} ----------
plot3(F1(1,4), F1(2,4), F1(3,4), 'om','linewidth',2,'markersize',mark);
text(F1(1,4), F1(2,4), F1(3,4)-0.2, '\{1\}')
plot3([F1(1,4) F1(1,4)+esc*F1(1,1)], [F1(2,4) F1(2,4)+esc*F1(2,1)], [F1(3,4) F1(3,4)+esc*F1(3,1)],'b','linewidth',2)
text(F1(1,4)+esc*F1(1,1), F1(2,4)+esc*F1(2,1), F1(3,4)+esc*F1(3,1), 'x_{\{1\}}')
plot3([F1(1,4) F1(1,4)+esc*F1(1,2)], [F1(2,4) F1(2,4)+esc*F1(2,2)], [F1(3,4) F1(3,4)+esc*F1(3,2)],'g','linewidth',2)
text(F1(1,4)+esc*F1(1,2), F1(2,4)+esc*F1(2,2), F1(3,4)+esc*F1(3,2), 'y_{\{1\}}')
plot3([F1(1,4) F1(1,4)+esc*F1(1,3)], [F1(2,4) F1(2,4)+esc*F1(2,3)], [F1(3,4) F1(3,4)+esc*F1(3,3)],'r','linewidth',2)
text(F1(1,4)+esc*F1(1,3), F1(2,4)+esc*F1(2,3), F1(3,4)+esc*F1(3,3), 'z_{\{1\}}')
plot3([F1(1,4) F2(1,4)], [F1(2,4) F2(2,4)], [F1(3,4) F2(3,4)], 'k')
% ---------- Frame {2} ----------
plot3(F2(1,4), F2(2,4), F2(3,4), 'om','linewidth',2,'markersize',mark);
text(F2(1,4), F2(2,4), F2(3,4)-0.2, '\{2\}')
plot3([F2(1,4) F2(1,4)+esc*F2(1,1)], [F2(2,4) F2(2,4)+esc*F2(2,1)], [F2(3,4) F2(3,4)+esc*F2(3,1)],'b','linewidth',2)
text(F2(1,4)+esc*F2(1,1), F2(2,4)+esc*F2(2,1), F2(3,4)+esc*F2(3,1), 'x_{\{2\}}')
plot3([F2(1,4) F2(1,4)+esc*F2(1,2)], [F2(2,4) F2(2,4)+esc*F2(2,2)], [F2(3,4) F2(3,4)+esc*F2(3,2)],'g','linewidth',2)
text(F2(1,4)+esc*F2(1,2), F2(2,4)+esc*F2(2,2), F2(3,4)+esc*F2(3,2), 'y_{\{2\}}')
plot3([F2(1,4) F2(1,4)+esc*F2(1,3)], [F2(2,4) F2(2,4)+esc*F2(2,3)], [F2(3,4) F2(3,4)+esc*F2(3,3)],'r','linewidth',2)
text(F2(1,4)+esc*F2(1,3), F2(2,4)+esc*F2(2,3), F2(3,4)+esc*F2(3,3), 'z_{\{2\}}')
plot3([F2(1,4) F3(1,4)], [F2(2,4) F3(2,4)], [F2(3,4) F3(3,4)], 'k')
% ---------- Frame {3} ----------
plot3(F3(1,4), F3(2,4), F3(3,4), 'om','linewidth',2,'markersize',mark);
text(F3(1,4), F3(2,4), F3(3,4)-0.2, '\{3\}')
plot3([F3(1,4) F3(1,4)+esc*F3(1,1)], [F3(2,4) F3(2,4)+esc*F3(2,1)], [F3(3,4) F3(3,4)+esc*F3(3,1)],'b','linewidth',2)
text(F3(1,4)+esc*F3(1,1), F3(2,4)+esc*F3(2,1), F3(3,4)+esc*F3(3,1), 'x_{\{3\}}')
plot3([F3(1,4) F3(1,4)+esc*F3(1,2)], [F3(2,4) F3(2,4)+esc*F3(2,2)], [F3(3,4) F3(3,4)+esc*F3(3,2)],'g','linewidth',2)
text(F3(1,4)+esc*F3(1,2), F3(2,4)+esc*F3(2,2), F3(3,4)+esc*F3(3,2), 'y_{\{3\}}')
plot3([F3(1,4) F3(1,4)+esc*F3(1,3)], [F3(2,4) F3(2,4)+esc*F3(2,3)], [F3(3,4) F3(3,4)+esc*F3(3,3)],'r','linewidth',2)
text(F3(1,4)+esc*F3(1,3), F3(2,4)+esc*F3(2,3), F3(3,4)+esc*F3(3,3), 'z_{\{3\}}')
plot3([F3(1,4) F4(1,4)], [F3(2,4) F4(2,4)], [F3(3,4) F4(3,4)], 'k')
% ---------- Frame {4} ----------
plot3(F4(1,4), F4(2,4), F4(3,4), 'om','linewidth',2,'markersize',mark);
text(F4(1,4), F4(2,4), F4(3,4)-0.2, '\{4\}')
plot3([F4(1,4) F4(1,4)+esc*F4(1,1)], [F4(2,4) F4(2,4)+esc*F4(2,1)], [F4(3,4) F4(3,4)+esc*F4(3,1)],'b','linewidth',2)
text(F4(1,4)+esc*F4(1,1), F4(2,4)+esc*F4(2,1), F4(3,4)+esc*F4(3,1), 'x_{\{4\}}')
plot3([F4(1,4) F4(1,4)+esc*F4(1,2)], [F4(2,4) F4(2,4)+esc*F4(2,2)], [F4(3,4) F4(3,4)+esc*F4(3,2)],'g','linewidth',2)
text(F4(1,4)+esc*F4(1,2), F4(2,4)+esc*F4(2,2), F4(3,4)+esc*F4(3,2), 'y_{\{4\}}')
plot3([F4(1,4) F4(1,4)+esc*F4(1,3)], [F4(2,4) F4(2,4)+esc*F4(2,3)], [F4(3,4) F4(3,4)+esc*F4(3,3)],'r','linewidth',2)
text(F4(1,4)+esc*F4(1,3), F4(2,4)+esc*F4(2,3), F4(3,4)+esc*F4(3,3), 'z_{\{4\}}')
plot3([F4(1,4) F5(1,4)], [F4(2,4) F5(2,4)], [F4(3,4) F5(3,4)], 'k')
% ---------- Frame {5} ----------
plot3(F5(1,4), F5(2,4), F5(3,4), 'om','linewidth',2,'markersize',mark);
text(F5(1,4), F5(2,4), F5(3,4)-0.2, '\{5\}')
plot3([F5(1,4) F5(1,4)+esc*F5(1,1)], [F5(2,4) F5(2,4)+esc*F5(2,1)], [F5(3,4) F5(3,4)+esc*F5(3,1)],'b','linewidth',2)
text(F5(1,4)+esc*F5(1,1), F5(2,4)+esc*F5(2,1), F5(3,4)+esc*F5(3,1), 'x_{\{5\}}')
plot3([F5(1,4) F5(1,4)+esc*F5(1,2)], [F5(2,4) F5(2,4)+esc*F5(2,2)], [F5(3,4) F5(3,4)+esc*F5(3,2)],'g','linewidth',2)
text(F5(1,4)+esc*F5(1,2), F5(2,4)+esc*F5(2,2), F5(3,4)+esc*F5(3,2), 'y_{\{5\}}')
plot3([F5(1,4) F5(1,4)+esc*F5(1,3)], [F5(2,4) F5(2,4)+esc*F5(2,3)], [F5(3,4) F5(3,4)+esc*F5(3,3)],'r','linewidth',2)
text(F5(1,4)+esc*F5(1,3), F5(2,4)+esc*F5(2,3), F5(3,4)+esc*F5(3,3), 'z_{\{5\}}')
plot3([F5(1,4) F6(1,4)], [F5(2,4) F6(2,4)], [F5(3,4) F6(3,4)], 'k')
% ---------- Frame {6} ----------
plot3(F6(1,4), F6(2,4), F6(3,4), 'om','linewidth',2,'markersize',mark);
text(F6(1,4), F6(2,4), F6(3,4)-0.2, '\{6\}')
plot3([F6(1,4) F6(1,4)+esc*F6(1,1)], [F6(2,4) F6(2,4)+esc*F6(2,1)], [F6(3,4) F6(3,4)+esc*F6(3,1)],'b','linewidth',2)
text(F6(1,4)+esc*F6(1,1), F6(2,4)+esc*F6(2,1), F6(3,4)+esc*F6(3,1), 'x_{\{6\}}')
plot3([F6(1,4) F6(1,4)+esc*F6(1,2)], [F6(2,4) F6(2,4)+esc*F6(2,2)], [F6(3,4) F6(3,4)+esc*F6(3,2)],'g','linewidth',2)
text(F6(1,4)+esc*F6(1,2), F6(2,4)+esc*F6(2,2), F6(3,4)+esc*F6(3,2), 'y_{\{6\}}')
plot3([F6(1,4) F6(1,4)+esc*F6(1,3)], [F6(2,4) F6(2,4)+esc*F6(2,3)], [F6(3,4) F6(3,4)+esc*F6(3,3)],'r','linewidth',2)
text(F6(1,4)+esc*F6(1,3), F6(2,4)+esc*F6(2,3), F6(3,4)+esc*F6(3,3), 'z_{\{6\}}')
plot3([F6(1,4) F7(1,4)], [F6(2,4) F7(2,4)], [F6(3,4) F7(3,4)], 'k')
% ---------- Frame {7} ----------
plot3(F7(1,4), F7(2,4), F7(3,4), 'om','linewidth',2,'markersize',mark);
text(F7(1,4), F7(2,4), F7(3,4)-0.2, '\{7\}')
plot3([F7(1,4) F7(1,4)+esc*F7(1,1)], [F7(2,4) F7(2,4)+esc*F7(2,1)], [F7(3,4) F7(3,4)+esc*F7(3,1)],'b','linewidth',2)
text(F7(1,4)+esc*F7(1,1), F7(2,4)+esc*F7(2,1), F7(3,4)+esc*F7(3,1), 'x_{\{7\}}')
plot3([F7(1,4) F7(1,4)+esc*F7(1,2)], [F7(2,4) F7(2,4)+esc*F7(2,2)], [F7(3,4) F7(3,4)+esc*F7(3,2)],'g','linewidth',2)
text(F7(1,4)+esc*F7(1,2), F7(2,4)+esc*F7(2,2), F7(3,4)+esc*F7(3,2), 'y_{\{7\}}')
plot3([F7(1,4) F7(1,4)+esc*F7(1,3)], [F7(2,4) F7(2,4)+esc*F7(2,3)], [F7(3,4) F7(3,4)+esc*F7(3,3)],'r','linewidth',2)
text(F7(1,4)+esc*F7(1,3), F7(2,4)+esc*F7(2,3), F7(3,4)+esc*F7(3,3), 'z_{\{7\}}')
plot3([F7(1,4) F8(1,4)], [F7(2,4) F8(2,4)], [F7(3,4) F8(3,4)], 'k')
% ---------- Frame {8} ----------
plot3(F8(1,4), F8(2,4), F8(3,4), 'om','linewidth',2,'markersize',mark);
text(F8(1,4), F8(2,4), F8(3,4)-0.2, '\{8\}')
plot3([F8(1,4) F8(1,4)+esc*F8(1,1)], [F8(2,4) F8(2,4)+esc*F8(2,1)], [F8(3,4) F8(3,4)+esc*F8(3,1)],'b','linewidth',2)
text(F8(1,4)+esc*F8(1,1), F8(2,4)+esc*F8(2,1), F8(3,4)+esc*F8(3,1), 'x_{\{8\}}')
plot3([F8(1,4) F8(1,4)+esc*F8(1,2)], [F8(2,4) F8(2,4)+esc*F8(2,2)], [F8(3,4) F8(3,4)+esc*F8(3,2)],'g','linewidth',2)
text(F8(1,4)+esc*F8(1,2), F8(2,4)+esc*F8(2,2), F8(3,4)+esc*F8(3,2), 'y_{\{8\}}')
plot3([F8(1,4) F8(1,4)+esc*F8(1,3)], [F8(2,4) F8(2,4)+esc*F8(2,3)], [F8(3,4) F8(3,4)+esc*F8(3,3)],'r','linewidth',2)
text(F8(1,4)+esc*F8(1,3), F8(2,4)+esc*F8(2,3), F8(3,4)+esc*F8(3,3), 'z_{\{8\}}')
