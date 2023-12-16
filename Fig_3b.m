 clear

% =========================================================================
% DEFINE THE K-WAVE GRID
% =========================================================================

% create the computational grid
% dx is spacing between ultrasonic transducers
Nx = 120;          % number of grid points in the x (row) direction
Ny = 120;          % number of grid points in the y (column) direction
Nz = 120;
dx = 2e-4;      	% grid point spacing in the x direction [m]
dy = dx;            % grid point spacing in the y direction [m]
dz = dx;
kgrid = kWaveGrid(Nx, dx, Ny, dy, Nz, dz);

% =========================================================================
% DEFINE THE MEDIUM PARAMETERS
% =========================================================================

% define the properties of the propagation medium
medium.sound_speed = 1638.8 * ones(Nx, Ny, Nz);    
medium.density = 1032 * ones(Nx, Ny, Nz);           
medium.alpha_coeff = 0.0992 * ones(Nx, Ny, Nz);     
medium.alpha_power = 1.5;


cx = floor((Nx + 1)/2);                               % [grid points] -> [m]
cy = floor((Ny + 1)/2);                               % [grid points]
radius = 10e-3/dx;                                    % [grid points] -> [m]

A=makeDisc(Nx, Ny, cx, cy, radius);
B=zeros(Nx, Ny, Nz);
for i = 22:Nz/4
    B(:,:,i)=A;
end

medium.sound_speed(B==1) = 1500;       % [m/s]
medium.density(B==1) = 1200;           % [kg/m^3]
medium.alpha_coeff(B==1) = 0.7942;     % [dB/(MHz^y cm)]


% 眼球  -声速-密度-吸收系数
radius = 7.5e-3/dx;                                                      % [grid points] -> [m]
cz = floor((Nz + 1)/2);
medium.sound_speed(makeBall(Nx, Ny, Nz, cx, cy, cz, radius) == 1) = 1525.8;     
medium.density(makeBall(Nx, Ny, Nz, cx, cy, cz, radius) == 1) = 1005;       
medium.alpha_coeff(makeBall(Nx, Ny, Nz, cx, cy, cz, radius) == 1) = 0.5459;       


% create the time array
Fs = 20e6;  
c_ref = 1638.8;  
kgrid.makeTime(c_ref, c_ref/dx/Fs, 30e-3/c_ref);  
% =========================================================================
% DEFINE THE INPUT SIGNAL
% =========================================================================

% define properties of the input signal
source_strength = 58180;               % [Pa]
carrier_freq  = 633e3;             % [Hz]

% create the input signal
carrier_signal  = source_strength * cos(2*pi*carrier_freq *kgrid.t_array);

% filter the source to remove high frequencies not supported by the grid
carrier_signal  = filterTimeSeries(kgrid, medium, carrier_signal);

% =========================================================================
% DEFINE THE ULTRASOUND TRANSDUCER
% =========================================================================
radius = 10e-3/dx;                                        % [grid points] -> [m]

A=makeDisc(Nx, Ny, cx, cy, radius);
B=zeros(Nx, Ny, Nz);
B(:,:,22)=A;

source.p_mask = B;

% define the time varying sinusoidal source
source.p = carrier_signal;

% =========================================================================
% DEFINE SENSOR MASK
% =========================================================================

% define a binary sensor mask
sensor.mask = ones(Nx, Ny, Nz);

% set the record mode to capture the final wave-field and the statistics at
% each sensor point
sensor.record = {'p'};

% =========================================================================
% RUN THE SIMULATION
% =========================================================================


% assign the input options
input_args = { 'PMLSize', [10, 10, 10], 'PMLInside', true, 'PlotScale', 'auto', 'DisplayMask', source.p_mask};

% run the simulation
sensor_data = kspaceFirstOrder3D(kgrid, medium, source, sensor, input_args{:});

data = sensor_data.p;
data_rs = reshape(data, Nx, Ny, Nz, []);