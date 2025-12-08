function [rewards, mu, conf95] = blackjack_evaluate_policy(policy_fun, N, use_seed)
    % BLACKJACK_EVALUATE_POLICY Function to evaluate a user-specified policy over N hands.
    % Syntax:
    %   [rewards, mu, conf95] = blackjack_evaluate_policy(policy_fun, N)
    %
    % Inputs:
    %   policy_fun - Function handle to the policy that determines the action
    %                   to take given the current observation. The function should
    %                   have the signature: 
    %                   **action = policy_fun(observation)**
    %   N          - Integer specifying the number of hands to play.
    %   use_seed   - Optional.  Set to "true" to make the evaluation
    %                   determinisitc by using a seed value.
    %                   Default is "false".  
    %   
    %
    % Outputs:
    %   rewards    - Nx1 array containing the rewards for each hand played.
    %   mu         - Mean reward for the sample
    %   conf95     - 1x2 array containing the lower and upper 95%
    %                   confidence interval.
    %
    % Example:
    %   % Define a simple policy function
    %   policy_fun = @(obs) randi([1, 2]); % Randomly choose action 1 or 2
    %   
    %   % Evaluate the policy over 100 hands
    %   rewards = evaluate_policy(policy_fun, 100);

    
    if nargin < 4
        use_seed = false;
    end
     
    % Initialize the rewards array
    rewards = zeros(N, 1);

    % Intitialize the environment
    if use_seed
        env = BlackJackEnv(1, 42);
    else
        env = BlackJackEnv(1);
    end

    % Loop to play N hands
    for ii = 1:N
        % Reset the environment to start a new hand
        obs = env.reset();
        terminated = false;
        
        % Play the hand until it is done
        while ~terminated
            % Choose an action based on the policy
            action = policy_fun(obs);
            
            [observation, reward, terminated, truncated, info] = env.step(action);
            
            % Update the observation
            obs = observation;
        end        
        % Accumulate the reward
        rewards(ii) = reward;
    end

    % Calculate reward statistics and print.
    mu = mean(rewards);
    sem = std(rewards)/sqrt(N);
    conf95 = [mu-(1.95*sem), mu+(1.95*sem)];
    fprintf("Mean reward: %.3f, We are 95%% confident that the mean reward is between %.3f and %.3f\n", ...
            mu, conf95(1), conf95(2));

end