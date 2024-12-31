clc;
clear all;
close all;

%% Problem def
problemValue.CostFunction = @(x) MyCost(x); %Cost Function]
problemValue.dimension_swarm = 10; % dimensão do enxame = variaveis de projeto
problemValue.bound_lower = -30; % limite inferior
problemValue.bound_upper = 30; % limite superior

%% Parameters of PSO
paramsValues.Iter_max = 1000; % maxima iteração
paramsValues.particles_size = 10; % número de partículas
paramsValues.c1 = 1;
paramsValues.c2 = 1;
paramsValues.ShowIterInfo = true;

%% PSO return
tic;
out = PSO(problemValue, paramsValues);
elapsed_time = toc; % Tempo decorrido em segundos
disp(['Tempo de execução: ', num2str(elapsed_time), ' segundos']);

BestSol = out.BestSol;
BestCost = out.BestCost;

%% Result / Plot
figure;
semilogy(BestCost, 'LineWidth', 2);
xlabel('Iteração')
ylabel('Valor da função objetivo')
grid on;
