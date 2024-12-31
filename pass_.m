clear all;
close all;
clc

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

%% FPSO params
paramsFPSO.alpha_value = 0.1 + (1.2 * (1:paramsValues.Iter_max) / paramsValues.Iter_max);
paramsFPSO.beta_value = 0.1 + (1.2 * (1:paramsValues.Iter_max) / paramsValues.Iter_max);

%% Pass velocity and position
tic;
out = FPSO(problemValue, paramsValues, paramsFPSO);
elapsed_time = toc; % Tempo decorrido em segundos
disp(['Tempo de execução: ', num2str(elapsed_time), ' segundos']);

BestSol = out.BestSol;
BestCost = out.BestCost;

%% Result / Plot
figure;
semilogy(BestCost, 'LineWidth', 2);
%plot(BestCost, 'LineWidth', 2);
xlabel('Iteração')
ylabel('Valor da função objetivo')
%grid on;