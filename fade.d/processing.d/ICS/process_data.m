function process_data(filelist_load, filelist_save, blocks, block, varargin)

if nargin < 3
  blocks = 1;
  block = 1;
end

% if a filelist is a char array it is supposed to be a filelist
if ischar(filelist_load)
  filelist_load = textread(filelist_load,'%s','delimiter','\n');
end

if ischar(filelist_save)
  filelist_save = textread(filelist_save,'%s','delimiter','\n');
end

if length(filelist_load) == length(filelist_save) 
  num_files = length(filelist_load);
end

asciifill = '01234567899';

for i=block:blocks:num_files
  elData = MakeElectrodogram(filelist_load{i});
  filelist_save{i} = strrep(filelist_save{i},'.wav','.mat');
  save(filelist_save{i}, 'elData')
  fprintf(asciifill(1+floor(i/num_files*(length(asciifill)-1))));
end
fprintf('#');

end
