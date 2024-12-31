function Objective_fun = MyCost(x)
    Objective_fun = sum((1 - x(1:end-1)).^2 + 100 * (x(2:end) - x(1:end-1).^2).^2);
    %Objective_fun = sum(x.^2);
end
