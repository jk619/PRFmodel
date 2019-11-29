classdef pmRF <   matlab.mixin.SetGet & matlab.mixin.Copyable
    % This is a superclass for RF-s. Every particular instance of this class
    % will have different parameters, so it will be a children class.
    %
    % Syntax:
    %      rf = RF();
    %
    % Inputs:
    %
    % Outputs:
    %
    % Optional key/value pairs:
    %
    % Description
    %
    % See also
    %
    
    % Examples
    %{
       
    %}
    
    properties
        PM;         % prfModel that has some of the variables we need, such as TR
        Centerx0;   % Deg
        Centery0;   % Deg
        Theta;      % Radians
        sigmaMajor; % Deg
        sigmaMinor; % Deg
        Type      ;
        % values;
    end
    properties (SetAccess = private, GetAccess = public)
         values;    % Result. Only can be changes from within this func.
    end
    properties(Dependent= true, SetAccess = private, GetAccess = public)
        TR;            % Seconds, it will be read from the parent class pm
    end
    
    
    
    %%
    methods (Static)
        function d = defaultsGet
            d.Centerx0   = 0;        % Deg
            d.Centery0   = 0;        % Deg
            d.Theta      = 0;        % Radians
            d.sigmaMajor = 1;        % deg
            d.sigmaMinor = 1;        % deg
            d.Type       = 'mrvista';
            % Convert to table and return
            d = struct2table(d,'AsArray',true);
        end
    end
    methods
        % Constructor
        function rf = pmRF(pm, varargin)
            % Obtain defaults table. If a parameters is not passed, it will use
            % the default one defined in the static function
            d = rf.defaultsGet;
            % Read the inputs
            varargin = mrvParamFormat(varargin);
            p = inputParser;
            p.addRequired ('pm'        ,              @(x)(isa(x,'prfModel')));
            p.addParameter('centerx0'  ,d.Centerx0  , @isnumeric);
            p.addParameter('centery0'  ,d.Centery0  , @isnumeric);
            p.addParameter('theta'     ,d.Theta     , @isnumeric);
            p.addParameter('sigmamajor',d.sigmaMajor, @isnumeric);
            p.addParameter('sigmaminor',d.sigmaMinor, @isnumeric);
            p.addParameter('type'      ,d.Type      , @ischar);
            p.parse(pm,varargin{:});
            
            % Initialize the pm model and hrf model parameters
            rf.PM           = pm;
            % The receptive field parameters
            rf.Centerx0     = p.Results.centerx0;
            rf.Centery0     = p.Results.centery0;
            rf.Theta        = p.Results.theta;
            rf.sigmaMajor   = p.Results.sigmamajor;
            rf.sigmaMinor   = p.Results.sigmaminor;
            rf.Type         = p.Results.type;
        end
        
        function v = get.TR(rf)
            v      = rf.PM.TR;
        end
        
        % Methods available to this class and childrens, if any
        function compute(rf)
            
            % Compute stimulus just in case
            rf.PM.Stimulus.compute;
            % Obtain grid XY
            XY = rf.PM.Stimulus.XY;
            % Calculate values
            if iscell(rf.Type);type = rf.Type{:};else;type=rf.Type;end
            switch type
                case {'mrvista'}
                    rf.values = rfGaussian2d(XY{1}, XY{2}, ...
                                rf.sigmaMajor,rf.sigmaMinor,rf.Theta, ...
                                rf.Centerx0,rf.Centery0);
                case {'analyzeprf'}
                    res     = max(size(XY{1},1), size(XY{1},1));
                    r       = rf.Centery0;
                    c       = rf.Centerx0;
                    sr      = rf.sigmaMajor;
                    sc      = rf.sigmaMinor;
                    xx      = XY{1};
                    yy      = XY{2};
                    ang     = rf.Theta;
                    omitexp = 0;
                    % calculate
                    rf.values = makegaussian2d(res,r,c,sr,sc,xx,yy,ang,omitexp);
                otherwise
                    error('%s not implemented yet', type)
            end
        end
        
        % Plot it
        function plot(rf,varargin)
            set(0, 'DefaultFigureRenderer', 'opengl');
            % Read the inputs
            varargin = mrvParamFormat(varargin);
            p = inputParser;
            p.addRequired ('rf'  ,  @(x)(isa(x,'pmRF')));
            p.addParameter('window',true, @islogical);
            p.parse(rf,varargin{:});
            w = p.Results.window;
            % Compute before plotting
            rf.compute
            % Plot it
            if w; mrvNewGraphWin('Receptive Field');end
            mesh(rf.values);
            grid on; 
            if w; xlabel('x'); ylabel('y'); end
            set(0, 'DefaultFigureRenderer', 'painters');
        end
    end
    
end



