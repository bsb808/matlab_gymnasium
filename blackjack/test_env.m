env = BlackJackEnv(1);

% Test the set function
observation = env.reset();
for ii = 4:21
    for jj = 1:10
        for kk = 0:1
            observation = [ii, jj, kk];
            [new_observation, info] = env.set(observation);
            if ~isequal(observation, new_observation)
                fprintf('Test of .set failed: Observation: [%d, %d, %d], New Observation: [%d, %d, %d]\n', observation, new_observation);
            end
        end
    end
end
%% 

% Test the setall
env = BlackJackEnv(1);
observation = env.reset();
playerscards = [1 5];
dealerscards = [10 1];
[new_observation, info] = env.setall(playerscards, dealerscards)