function dt = pmForwardModelCalculate(dt)
% Creates a table with all parameters (defaults) required to perform a forward
% calculation
% 
%  Inputs: table with one or several rows of parameters to calculate bold series
%          in fwd model
% 
%  Outputs: returns the same table with the last column of pm-s calculated
% 
%  See also: forwardModelTableCreate
% 
%  GLU Vistalab 2019.05



for ii=1:height(dt)
    % Do it row to row and parameter to parameter first, for debugging
    
    %% Initialize the basic model with defaults
    pm = dt.pm(ii);
    
    %% TR
    pm.TR = dt.TR(ii);

    %% Stimulus
    for jj=1:width(dt.Stimulus)
        paramName               = dt.Stimulus.Properties.VariableNames{jj};
        pm.Stimulus.(paramName) = dt.Stimulus.(paramName)(jj);
    end
    pm.Stimulus.compute;
    
    
    %% RF
    for jj=1:width(dt.RF)
        paramName         = dt.RF.Properties.VariableNames{jj};
        pm.RF.(paramName) = dt.RF.(paramName)(jj);
    end
    pm.RF.compute;
    
    %% HRF
    for jj=1:width(dt.HRF)
        paramName          = dt.HRF.Properties.VariableNames{jj};
        val                = dt.HRF.(paramName)(jj);
        if iscell(val)
            pm.HRF.(paramName) = val{:};
        else
            pm.HRF.(paramName) = val;
        end
    end
    pm.HRF.compute;
    
    
    %% Noise
    % Read values from table
    % pm.Noise.Type    = dt.Noise.Type(ii);
    % pm.noise.white_k = dt.Noise.white_k(ii);
    % pm.Noise.compute;
    
    
    %% Compute the synthetic signal
    pm.compute;
    %% Write back the updated pm model
    dt.pm(ii) = pm;
    
end
