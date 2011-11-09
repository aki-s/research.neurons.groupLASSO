function plot_ResFuncALL(varargin)
%%
%% example)
%  plot_ResFuncALL('outdir/22-Oct-2011-start-22_34/',20)
%% plot_ResFuncALL(mat file)
%%   varargin{1}: dirname or mat file containing variable 'env'.
%%
%% plot_ResFuncALL(dirname,#neuron)');
%%   varargin{1}: dirname 
%%   varargin{2}: vector containing num of neuron to be plotted.
if nargin == 1 % use write outed setting
               %++bug: 
  if isdir(varargin{1})
    in = varargin{1};
    in = strcat(in,'/');
    LOOP =  1;
  elseif ischar(varargin{1})
    data = varargin{1};
    load(data,'env');
    in = regexprep(data,'(.*/)(.*)(.mat)','$1');
    if isfield(env,'inFiringUSE')
      cnum = env.inFiringUSE; % vector
      LOOP =  length(cnum);
    else
      error('set vector ''env.inFiringUSE''');
    end
  end
elseif nargin == 2
  if isdir(varargin{1})
    in = varargin{1};
    in = strcat(in,'/');
  end
  if isnumeric(varargin{2})
    cnum = varargin{2}; % vector
    LOOP = length(cnum);
  end
else
  error('usage: plot_ResFuncALL(mat file) or plot_ResFuncALL(dirname,#neuron)');
end

for i1 = 1:LOOP
  try 
    list = textscan(ls([in,'*',sprintf('%d',cnum(i1)),'.mat']), ...
                    '%s','delimiter','\t\n');
  catch err
    list = textscan(ls([in,'*.mat']), ...
                    '%s','delimiter','\t\n');
  end
  N = size(list{1},1);
  for i2 = 1:N
    fprintf('loaded: %s\n',list{1}{i2});
    S = load(list{1}{i2});
    try
      plot_Ealpha(S.env,S.graph,S.DAL,S.bases,S.basisWeight,N+1- ...
                  i2,'')
    catch errP
      plot_Ealpha(S.env,S.graph,S.DAL,S.bases,S.EKerWeight,N+1- ...
                  i2,'')
    end
  end
end
