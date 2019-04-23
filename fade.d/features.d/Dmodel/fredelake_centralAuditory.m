function IR = fredelake_centralAuditory(Results, Geometry)
% Developed by Franklin Alvarez
% Taken from the Central Auditory Processing section in [1]
% Inputs: - Results: elec2spikes_joshi output with Options.SpikeTimes=true
%         - Geometry: elec2spikes_joshi geometry.
% Output: - IR ('num_elec'x'num_frames' double): Internal representation of
%                                                the spikes
%               num_elec = number of electrodes
%               num_frames = number of dowsampled frames
%% Downsampling to 5000Hz:
fs = 5000;                              % new sample frequency
num_fibers = Geometry.nF;               % number of fibers
durSignal = Results.t(end) / 1000000;   % duration of the audio signal
i_time = 1/fs;                          % Period of 5000Hz
num_frames = ceil(durSignal/i_time)+1;    % number of downsampled frames

SP = zeros(num_fibers, num_frames);     % Downsample fiber spiking
for i=1:num_fibers
    fST = Results.SpikeTimes{1,i};
    for j = 1:size(fST,2)
        k = round(fST(j)*fs/1000000)+1;
        SP(i,k) = 1;
    end
end

clear Results

%% Grouping integration:
% Group all the fibers by distance with electrodes
SPG = zeros(Geometry.nE, num_frames);
for i = 1:num_fibers
    posFiber = [Geometry.pAnfX(:,i), Geometry.pAnfY(:,i), Geometry.pAnfZ(:,i)]';
    beta = Geometry.betas(i);
    posP = posBeta(posFiber, beta);
    d = vecnorm(Geometry.pE - posP);
    fGroup = find(d == min(d));
    for j=1:num_frames
        SPG(fGroup,j) = SPG(fGroup,j) + SP(i,j); 
    end
end
num_elec = Geometry.nE;
clear SP Geometry

k = 0:num_frames-1;
taoLP = 0.001; % 1 ms
filter = exp(-((k./ (sqrt(2)*fs*taoLP)).^2));
SR = zeros(size(SPG));
tatt = 0.07; % attack time
trel = 0.07; % release time
Z = zeros(size(SPG));
Y = zeros(size(SPG));
IR = zeros(size(SPG));
for i=1:num_elec
    %% Convolutional Low-Pass Filter:
    sr_i = conv(SPG(i,:),filter);
    SR(i,:) = sr_i(1:num_frames);
    %% Non-linear Integrator:
    Y(i,1) = SR(i,1);
    for j = 2:num_frames
        if SR(i,j) >= Z(i,j-1)
            c1 = exp(-(1/(tatt*fs)));
            c2 = 1 - c1;
        else
            c1 = exp(-(1/(trel*fs)));
            c2 = 0;            
        end
        Z(i,j) = c1*Z(i,j-1) + c2*SR(i,j);
        %% Comparison:
        Y(i,j) = max(SR(i,j),Z(i,j));
    end
    %% Final filtering
    ir_i = conv(Y(i,:),filter);
    IR(i,:) = ir_i(1:num_frames);
end
end

% [1] Fredelake, S. & Hohmann, V. Factors affecting predicted speech
% intelligibility with cochlear implants in an auditory model for
% electrical stimulation. Hearing Research, 287, 76 – 90 (2012).
% URL = http://www.sciencedirect.com/science/article/pii/S0378595512000639
