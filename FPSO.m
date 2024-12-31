function out = FPSO(problemValue, paramsValues, paramsFPSO)

    %% Problem def
    CostFunction = problemValue.CostFunction; % Função objetivo
    dimension_swarm = problemValue.dimension_swarm; % dimensão do enxame = variaveis de projeto
    size_swarm = [1 dimension_swarm]; % Matriz de armazenamento de soluções
    
    bound_lower = problemValue.bound_lower; % limite inferior
    bound_upper = problemValue.bound_upper; % limite superior
    
    
    %% Parameters of PSO
    Iter_max = paramsValues.Iter_max; % maxima iteração
    particles_size = paramsValues.particles_size; % número de partículas

    c1 = paramsValues.c1;
    c2 = paramsValues.c2;
    ShowIterInfo = paramsValues.ShowIterInfo;

    MaxVelocity = 0.2*(bound_upper - bound_lower);
    MinVelocity = -MaxVelocity;

    %% Fractional Params
    alpha_value = paramsFPSO.alpha_value;
    beta_value = paramsFPSO.beta_value;

    [pass_velocity, pass_position] = Pass_vector( ... 
                                      MaxVelocity, ...
                                      MinVelocity, ...
                                      problemValue.bound_lower, ...
                                      problemValue.bound_upper, ...
                                      size_swarm);
    
    %% initialization Paramenters
    
    %Estrutura (Template) inicial da população, vetores iniciais
    empty_particles.Position = [];
    empty_particles.Velocity = [];
    empty_particles.CostValues = [];
    empty_particles.Best.Position = [];
    empty_particles.Best.CostValues = [];
    
    %criação da população, contendo (para cada particula das 50) possíveis
    %soluções, considerando as 5 variáveis de projeto
    particles = repmat(empty_particles, particles_size, 1);
    
    % Inicializando o melhor valor global com o maior valor obtido antes da iteração.
    Global_Best.CostValues = inf;
    
    % Inicialização da população (Posição, valocidade, primeiros valores da
    % função objetivo.
    for i=1:particles_size
    
        % Geração das particulas (possiveis soluções iniciais).
        particles(i).Position = unifrnd(bound_lower, bound_upper, size_swarm);
    
        % Iniciação do vetor de velocidade
        particles(i).Velocity = zeros(size_swarm);
    
        % Solução da função objetivo.
        particles(i).CostValues = CostFunction(particles(i).Position);
        
        %Atualização da melhor posição e valor da função objetivo na iteração
        %ith respectivamente.
        particles(i).Best.Position = particles(i).Position;
        particles(i).Best.CostValues = particles(i).CostValues;
    
        % Atualizando a melhor posição global.
        if particles(i).Best.CostValues < Global_Best.CostValues
            Global_Best = particles(i).Best;
        end
    end
    
    % vetor que armazena o melhor valor em cada iteração, após as iterações
    % acabarem.
    BestCost = zeros(Iter_max, 1);
    
    %% PSO initialization / Loop of PSO
    
    for it=1:Iter_max % Lógica para "Varrer" todas as iterações
        %w = 0.9 - 0.6 * (it / Iter_max); % coeficiente de inércia
        num_rand = rand();
        zr = 4 * num_rand * (1 - num_rand);
        w = ((0.9 - 0.4) * (Iter_max - it) / Iter_max) + 0.4 * zr;
    
        for i=1:dimension_swarm % Lógica para "varrer" toda as variáveis objetivo.
    
            % Lógica para atualização da velocidade segundo o algoritmo PSO
            particles(i).Velocity = (w + alpha_value(it) - 1) * particles(i).Velocity ...
                + c1*rand(size_swarm) .* (particles(i).Best.Position - particles(i).Position) ...
                + c2*rand(size_swarm) .* (Global_Best.Position - particles(i).Position) ...
                + ((1 / 2) * alpha_value(it) * (1 - alpha_value(it)) * pass_velocity(1, i, 1)) ...
                + ((1 / 6) * alpha_value(it) * (1 - alpha_value(it)) * (2 - alpha_value(it)) * pass_velocity(1, i, 2)) ...
                + ((1 / 24) * alpha_value(it) * (1 - alpha_value(it)) * (2 - alpha_value(it)) * (3 - alpha_value(it)) * pass_velocity(1, i, 3));

            % Lógica para substituir os primeiros valores do vetor de
            % velocidade no passado.
            % Deslocar 'pass_velocity' ao longo da primeira dimensão (shift=1, axis=0)]
            %display(['antes ' num2str(pass_velocity)]);
            pass_velocity(:,:,2:end) = pass_velocity(:,:,1:end-1);
            pass_velocity(:, :, 1) = particles(i).Velocity;
            %display(['depois ' num2str(pass_velocity)]);

            % Verificação do limite superior e inferior para a velocidade
            particles(i).Velocity = max(particles(i).Velocity, MinVelocity);
            particles(i).Velocity = min(particles(i).Velocity, MaxVelocity);
    
            % Lógica para atualização da posição segundo o algoritmo PSO
            particles(i).Position = beta_value(it) * particles(i).Position ...
                                    + particles(i).Velocity ...
                                    + ((1 / 2) * beta_value(it) * (1 - beta_value(it)) * pass_position(1, i, 1)) ...
                                    + ((1 / 6) * beta_value(it) * (1 - beta_value(it)) * (2 - beta_value(it)) * pass_position(1, i, 2)) ...
                                    + ((1 / 24) * beta_value(it) * (1 - beta_value(it)) * (2 - beta_value(it)) * (3 - beta_value(it)) * pass_position(1, i, 3));
                                   

            % Lógica para substituir os primeiros valores do vetor de
            % velocidade no passado.
            pass_position(:,:,2:end) = pass_position(:,:,1:end-1);
            pass_position(:, :, 1) = particles(i).Position;

            % Verificação do limite superior e inferior
            particles(i).Position = max(particles(i).Position, bound_lower);
            particles(i).Position = min(particles(i).Position, bound_upper);

            % Insere o valor da particula na função objetivo para avalição.
            particles(i).CostValues = CostFunction(particles(i).Position);
    
            % Lógica para atualização da melhor posição obtida a cada iteração
            % e a atualização do valor da função custo obtida, levando em
            % consideração o Melhor Valor da função objetivo obtida.
            if particles(i).CostValues < particles(i).Best.CostValues
                particles(i).Best.Position = particles(i).Position;
                particles(i).Best.CostValues = particles(i).CostValues;
    
                % Atualizando a melhor posição global.
                if particles(i).Best.CostValues < Global_Best.CostValues
                    Global_Best = particles(i).Best;
                end
            end
        end 
        
        % Histórico da melhor posição obtida
        BestCost(it) = Global_Best.CostValues;
        %display(BestCost(it));
        if ShowIterInfo
            display(['iteração ' num2str(it) ':Melhor valor da função objetivo = ' num2str(BestCost(it))]);
        end 
    end

    out.pop = particles;
    out.BestSol = Global_Best;
    out.BestCost = BestCost;
end