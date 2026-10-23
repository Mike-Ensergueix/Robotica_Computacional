clear all;
close all;
clc;

% Pacote de variáveis simbólicas
pkg load symbolic

% ============================================================
% 1) DECLARAÇÃO DAS VARIÁVEIS SIMBÓLICAS
% ============================================================
syms th dz a alpha real
syms th1 th2 th3 d1 a2 a3 real
one = sym(1); zero = sym(0);
deg2rad_sym = @(d) sym(d) * sym(pi) / sym(180);

% ============================================================
% 2) MATRIZ DE TRANSFORMAÇÃO DE DENAVIT-HARTENBERG
% ============================================================
% A matriz da convenção DH:
%
% A = [ cos(th)  -sin(th)*cos(alpha)   sin(th)*sin(alpha)   a*cos(th);
%       sin(th)   cos(th)*cos(alpha)  -cos(th)*sin(alpha)   a*sin(th);
%          0             sin(alpha)           cos(alpha)          dz;
%          0                0                    0                 1 ]

function A = DH(th, dz, a, alpha)

    A = [cos(th), -sin(th)*cos(alpha),  sin(th)*sin(alpha), a*cos(th);
         sin(th),  cos(th)*cos(alpha), -cos(th)*sin(alpha), a*sin(th);
         zero,        sin(alpha),          cos(alpha),          dz;
         zero,        zero,                zero,                one];

endfunction

% ============================================================
% 3) MATRIZES HOMOGÊNEAS INDIVIDUAIS
% ============================================================

% Junta 1:
% theta1 = th1
% d1 = d1

