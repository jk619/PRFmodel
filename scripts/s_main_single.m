%% MAIN SCRIPT: for a single synthetic BOLD signal generation and testing
% 
% This script is a wrapper that generates A SINGLE synthetic BOLD signal and 
% estimates calculated with different pRF implementations. It is intended to be
% used as a learning and testing tool. Once it is mastered and tested with a
% single BOLD series that this is what we want to do, we can create multiple
% variations in s_main_table.m, analyze them with different implementations and
% test them.
% 
% The unit element of this software is a prfModel class. 
    % BRIAN: there is the main class which is prfModel, and prfModel_basic and
    %        prfModel_CSS are inherited classes. I can create a wrapper function
    %        that implements the required one. 
    %                    pm = pmModelCreateWithDefaults('Type', 'CSS')
    %        for example. It will do this: pm = prfModel_CSS;
% 
% Most basic full circle example:
                % Create default values:
                pm = prfModel_basic;
                % Visualize them
                pm.plot('with noise');
                % And compute it with, for example, analyzePRF
                results = pmModelFit(pm, 'analyzePRF');
                % Evaluation: TODO
                % TODO: make sense of the analyzePRF output and relate to the input
                
% We can make changes to the parameters to check both the signal and the results. 
                pm.TR = 1.82;
                % We need to compute again the BOLD signal after any change in params
                pm.compute;
                pm.plot('both')
                
                
                
                
                
                
                
% CHECK/VISUALIZE/CHANGE THE INDIVIDUAL COMPONENTS. 
% The logical order is:

% 1./ STIMULUS: 
                % Visualize
                pm.Stimulus.plot
                % pm.Stimulus.toVideo (creates a video and saves it in folder local)
                % Change a parameter
                pm.Stimulus.Binary   = false; % TODO: it will generate the same thing
                pm.Stimulus.barWidth =     2; % TODO: it will generate the same thing
                % Compute new stimulus based on the new parameters
                pm.Stimulus.compute; % If exists the file, read it, otherwise, create it and save it. 
                % Visualize it
                pm.Stimulus.plot
                % See how the predicted synthetic BOLD signal changed
                pm.compute;
                pm.plot('with noise');
                
% 2./ RF: Receptive Field
                % Visualize
                pm.RF.plot
                % Change a couple of parameters
                pm.RF.sigmaMajor = 3; 
                pm.RF.Theta      = pi/2; 
                % NOTE::: RF.COMPUTE: not required, this is light and everything done on the fly
                % TODO: Let's discuss this, maybe you want to always have it for coherence
                % Visualize
                pm.RF.plot
                % See the new predicted synthetic BOLD signal
                % We need to compute it first. 
                % TODO: I think I would avoid the compute steps and internally
                %       always launch the compute function when the BOLD signal is
                %       required. 
                pm.compute;
                pm.plot('with noise');
                
% 3./ HRF: Hemodynamic Response Function
                % Visualize
                pm.HRF.plot
                % Change a parameter
                pm.HRF.params.c = 0.7;
                % Visualize (no HRF.compute required, calculated on the fly)
                pm.HRF.plot
                
% 4./ Noise
                % Visualize the default noise models
                pm.Noise
                % Visualize respiratory
                pm.Noise{3}.plot
                % Change a parameter
                pm.Noise{3}.params.amplitude = 0.9;
                % Visualize it (no compute required, calculated on the fly)
                pm.Noise{3}.plot   
                % Compute and visualize the new synthetic BOLD with noise
                pm.compute;
                pm.plot('with noise');