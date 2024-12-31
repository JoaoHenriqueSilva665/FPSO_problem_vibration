function out = PSO(problemValue, paramsValues)

    %% Problem def
    CostFunction = problemValue.CostFunction; %Cost Function
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
        %w = 1;
        w = 0.9 - 0.6 * (it / Iter_max);
    
        for i=1:dimension_swarm % Lógica para "varrer" toda as variáveis objetivo.
    
            % Lógica para atualização da velocidade segundo o algoritmo PSO
            particles(i).Velocity = w * particles(i).Velocity ...
                + c1*rand(size_swarm).*(particles(i).Best.Position - particles(i).Position) ...
                + c2*rand(size_swarm).*(Global_Best.Position - particles(i).Position);

            % Verificação do limite superior e inferior para a velocidade
            particles(i).Velocity = max(particles(i).Velocity, MinVelocity);
            particles(i).Velocity = min(particles(i).Velocity, MaxVelocity);
    
            % Lógica para atualização da posição segundo o algoritmo PSO
            particles(i).Position = particles(i).Position + particles(i).Velocity;

            % Verificação do limite superior e inferior
            particles(i).Position = max(particles(i).Position, bound_lower);
            particles(i).Position = min(particles(i).Position, bound_upper);
    
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