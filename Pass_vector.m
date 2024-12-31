function [all_iterations_velocity, all_iterations_position] = Pass_vector( ...
                                                                MaxVelocity, ...
                                                                MinVelocity, ...
                                                                bound_lower, ...
                                                                bound_upper, ...
                                                                size_swarm)
    all_iterations_velocity = [];
    all_iterations_position = [];

    for iter = 1:3
        % Gerando a matriz de velocidades para esta iteração
        velocity_i = unifrnd(MinVelocity, MaxVelocity, size_swarm);
        position_i = unifrnd(bound_lower, bound_upper, size_swarm);


        % Armazenando a matriz de velocidades e posições atuais
        all_iterations_velocity = cat(3, all_iterations_velocity, velocity_i);
        all_iterations_position = cat(3, all_iterations_position, position_i);
    end
end