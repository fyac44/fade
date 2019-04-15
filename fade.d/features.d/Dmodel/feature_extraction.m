function features = feature_extraction(yEl)

% load the degeneration status of nerves
%folder = '/media/dhz/Data/FAexp/SROpt1'; 
folder = pwd;
load(strcat(folder, '/parameters/CochleaGeometryData/nerveDegeneration.mat'))

posAlongFibers = nerveDegeneration(usedFibers);

[Results, Geometry] = elec2spikes_JoshiFA(yEl, usedFibers, posAlongFibers);

features = fredelake_centralAuditory(Results, Geometry);
