function figures(results_file, figures_path, version_string)

if nargin > 1 && ~isempty(figures_path)
  mkdir(figures_path);
  savefigures = true;
else
  figures_path = [];
  savefigures = false;
end

if nargin < 3
  version_string ='';
end

evaluation(results_file, figures_path, version_string)

end