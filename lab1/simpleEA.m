function [bestSoFarFit ,bestSoFarSolution ...
    ]=simpleEA( ...  % name of your simple EA function
    fitFunc, ... % name of objective/fitness function
    T, ... % total number of evaluations
    input) % replace it by your input arguments

% Check the inputs
if isempty(fitFunc)
    warning(['Objective function not specified, ''' objFunc ''' used']);
    fitFunc = 'objFunc';
end
if ~ischar(fitFunc)
    error('Argument FITFUNC must be a string');
end
if isempty(T)
    warning(['Budget not specified. 1000000 used']);
    T = '1000000';
end
eval(sprintf('objective=@%s;',fitFunc));
% Initialise variables
nbGen = 0; % generation counter
nbEval = 0; % evaluation counter
bestSoFarFit = 0; % best-so-far fitness value
bestSoFarSolution = NaN; % best-so-far solution
%recorders
fitness_gen=[]; % record the best fitness so far
solution_gen=[];% record the best phenotype of each generation
fitness_pop=[];% record the best fitness in current population
%% Below starting your code

% Initialise a population
%% TODO
population = randi([input.min,input.max],input.pop_size,1);
genotype = dec2bin(population);
% Evaluate the initial population
fitness = objFunc(population);

[fitness_max,index_max] = max(fitness);
if fitness_max > bestSoFarFit
    bestSoFarFit = fitness_max;
    bestSoFarSolution = population(index_max);
end

nbGen = nbGen +1;
nbEval = nbEval +input.pop_size;
fitness_gen = [fitness_gen, bestSoFarFit];
solution_gen = [solution_gen, population(index_max)];
fitness_pop = [fitness_pop, fitness_max];
%% TODO

% Start the loop
while (nbEval<T)
    % Reproduction (selection, crossver)
    %% TODO
    offspring = []; % offspring is of the genotype
    selectionion_prob = fitness./sum(fitness);
    for i=1:input.pop_size/2
        % selection
        parent_index = [];
        for j=1:2
            r = rand();
            for index = 1:input.pop_size
                if r>sum(selectionion_prob(1:index-1)) && r<=sum(selectionion_prob(1:index))
                    break;
                end
            end
            parent_index = [parent_index, index];
        end
        % crossover
        crossover_point = randi(input.gen_len - 1);
        offspring= [offspring;[genotype(parent_index(1),1:crossover_point),genotype(parent_index(2),crossover_point+1:end)]];
        offspring= [offspring;[genotype(parent_index(2),1:crossover_point),genotype(parent_index(1),crossover_point+1:end)]];
    end
    % Mutation
    %% TODO
    mutation_prob = 1/input.gen_len;
    for i=1:input.pop_size
        for j=1:input.gen_len
            if rand()<mutation_prob
                if offspring(i,j)=='0'
                    offspring(i,j)='1';
                else
                    offspring(i,j)='0';
                end
            end
        end
    end
    % replacement
    genotype = offspring;
    population = bin2dec(genotype);
    fitness = objFunc(population);
    
    [fitness_max,index_max] = max(fitness);
    if fitness_max > bestSoFarFit
        bestSoFarFit = fitness_max;
        bestSoFarSolution = population(index_max);
    end
    % update the counter
    nbGen = nbGen +1;
    nbEval = nbEval +input.pop_size;
    fitness_gen = [fitness_gen, bestSoFarFit];
    solution_gen = [solution_gen, population(index_max)];
    fitness_pop = [fitness_pop, fitness_max];
end
% Visualization
%% TODO
bestSoFarFit
bestSoFarSolution
figure,plot(1:nbGen,fitness_gen),title('FitnessGen');
figure,plot(1:nbGen,solution_gen),title('SolutionGen');
figure,plot(1:nbGen,fitness_pop),title('FitnessPop');
end




