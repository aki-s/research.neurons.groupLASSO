function plot_ResFuncALL(varargin)
%%
%% example)
%  plot_ResFuncALL('outdir/22-Oct-2011-start-22_34/',20)
%  plot_ResFuncALL(status.savedirname,20)
%  plot_ResFuncALL(status.savedirname,20,3000)
%  plot_ResFuncALL(status.savedirname,9,env.useFrame(4),graph)
%% plot_ResFuncALL()
%%  if (nargin == 1)
%%   varargin{1}: mat file containing variable 'env'.
%%  if (nargin >= 2)
%%   varargin{1}: dirname 
%%   varargin{2}: vector containing num of neuron to be plotted.
%%   varargin{3}: vector from env.userFrame()
%%   varargin{4}: override prameter to plot graph

if isdir(varargin{1})
  in = varargin{1};
  in = strcat(in,'/');
end

if nargin == 1 % use write outed setting
               %++bug: 
  if ischar(varargin{1})
    data = varargin{1};
    load(data,'env');
    in = regexprep(data,'(.*/)(.*)(.mat)','$1');
    if isfield(env,'inFiringUSE')
      cnum = env.inFiringUSE; % vector
      LOOPn = length(cnum);
    else
      error('set vector ''env.inFiringUSE''');
    end
  end
elseif nargin >= 2
  if isnumeric(varargin{2})
    cnum = varargin{2}; % vector
    LOOPn = length(cnum);
  end
else
  error('usage: plot_ResFuncALL(mat file) or plot_ResFuncALL(dirname,#neuron)');
end
LOOPf = 1;
if nargin >= 3
  if isnumeric(varargin{3})
    frame = varargin{3}; % vector
    LOOPf = length(frame);
  end
  LOOPfp = 1;
else
  LOOPfp = 0;
end

%% get mat file list to be plotted.
%{
listLS = textscan(ls([in,'*.mat']), ...
                  '%s','delimiter','\t\n'); % default list
listLS{1}{1:2}
%}
listLS = ls([in,'*.mat']); % default list

for i1 = 1:LOOPn
  for i2 = 1:LOOPf

    if LOOPfp == 0
      %% METHOD-REGFAC-FNAME-USEDFRAME-#NEURON.mat
      [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                          '\w*-[0-9\.]*-\w*-[0-9\.]*-',...
                          '0*',sprintf('%d',cnum(i1)),'.mat']);
    else
      %% METHOD-REGFAC-FNAME-USEDFRAME-#NEURON.mat
      [dum1 dum2 dum3 list dum5 dum6 dum7] = regexp(listLS,[in, ...
                          '\w*-[0-9\.]*-\w*-',...
                          '0*',sprintf('%d',frame(i2)),'-',...
                          '0*',sprintf('%d',cnum(i1)),'.mat']);
    end
    N = length(list);
    S = load(list{i2});
    regFacLen = length(S.DAL.regFac);
    for i3 = 1:N
      fprintf('loaded: %s\n',list{i3});
      S = load(list{i3});
      regFacIdx = str2double(regexprep(list{i3},...
                                       '(.*/)(\w*-)([0-9\.]*)(-.*.mat)','$3'));
      regFacIdx = find(S.DAL.regFac == repmat(regFacIdx,[1 regFacLen]));
      %{
      if ~mod(i3-1,regFacLen)
        regFacIdx = regFacLen;
      end
      %}
      if strcmp('rm_after_AROB','rm_after_AROB')
        %10-Nov-2011-start-18_54
        S.status.DEBUG.level=0;
        S.graph.prm.showWeightDistribution = 0;
      end
      S.graph.prm.auto = 0; % make comparison of ResFunc easy.
      if nargin >= 4 %% to hand over 'graph.prm'
        S.graph = varargin{4};
      end
      if 1 == 0
        plot_Ealpha(S.env,S.graph,S.status,S.DAL,S.bases,S.basisWeight ...
                    ,'',regFacIdx)
      else
        try
          plot_Ealpha(S.env,S.graph,S.status,S.DAL,S.bases,S.EbasisWeight ...
                      ,'',regFacIdx)

        catch errP
          warning('DEBUG:NOTICE','error hundling');
regFacIdx
          plot_Ealpha(S.env,S.graph,S.status,S.DAL,S.bases,S.EbasisWeight ...
                      ,'',regFacIdx)
          try
            plot_Ealpha(S.env,S.graph,S.status,S.DAL,S.bases,S.KerWeight ...
                        ,'',regFacIdx)
          catch err
            error()
          end
        end
      end
      %      regFacIdx = regFacIdx - 1;
    end
  end
end
