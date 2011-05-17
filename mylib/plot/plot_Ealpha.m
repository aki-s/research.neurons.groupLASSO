function [ Ealpha ] = plot_Ealpha(EKerWeight,Ebias,env,ggsim,title)
%%
%% Generate and plot estimated alpha.
%% INPUT)
%%
%% USAGE)
%  plot_Ealpha(EKerWeight,Ebias,env,ggsim,'title')
%%
SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
if exist('SELF_DEPRESS_BASE') == 0
  SELF_DEPRESS_BASE = 2;
end
if exist('gain') == 0
  gain = 1;
end

% $$$ run('../../conf/setpaths.m');
% $$$ run('../../conf/conf_graph.m');
global rootdir_
run([rootdir_ '/conf/setpaths.m']);
run([rootdir_ '/conf/conf_graph.m']);

% $$$ if exist('OUTPUT_EPS') == 0
% $$$   OUTPUT_EPS = 0;
% $$$ end

if exist('graph') == 0
  graph.TIGHT = 1
end

cnum = env.cnum;
hnum = env.hnum;
hwind = env.hwind;
nbase = ggsim.ihbasprs.nbase;
M = hnum*hwind; % M: total history frame.
for i1to = 1:cnum
  for i2from = 1:cnum
    %    Ealpha{i1to}{i2from} = 0;
    %    for i3 = 1:nbase
      %      Ealpha{i1to}{i2from}= Ealpha{i1to}{i2from} +
      %      EKerWeight{i1to}((i2from-1)*nbase +
      %      i3).*ggsim.ihbasis(:,i2from);
      Ealpha{i1to}{i2from} = (ggsim.ihbasis* EKerWeight{i1to}(:,i2from))';
      %          EKerWeight{i1to}( (i2from-1)*nbase + (1:nbase) );      
      %    end
  end
end

figure;
i2to =1; % cell to
i3from =1; % cell from
for i1 = 1:cnum*cnum % subplot select
if  graph.TIGHT == 1;
  axis tight;
end
  grid on;
  subplot(cnum,cnum,i1);
  %  tmp1 = Ealpha{i2to}( ( (i3from-1) - (i2to-1)*cnum )*hnum + 1:hnum );
  tmp1 = Ealpha{i2to}{i3from};
  if i2to == i3from
    tmp1 = tmp1 + Ebias{i2to};
  end
  if tmp1 > 0
    %    plot(1:M,tmp1(1::,'r');
    plot(tmp1,'r');
  elseif tmp1 < 0
    %    plot(1:M,tmp1,'b');
    plot(tmp1,'b');
  else 
    plot(tmp1,'k');
    %    plot(1:M,tmp1,'k');
  end
  %% </ chage color ploted according to cell type >
  xlim([0,env.hnum*2]);
  ylim([-SELF_DEPRESS_BASE*gain-2,2]);
  set(gca,'XAxisLocation','top');

  %% < from-to cell label >
  if (i2to == 1)     % When in the topmost margin.
    xlabel(i3from); xlim([0,hnum]);
  end
  if (i3from == 1) ylabel(i2to); % When in the leftmost margin.
  end
  %% </ from-to cell label >

  %% < index config >
  if (i3from == cnum ) i2to = i2to +1; i3from = 0; end % When in the righmost margin.
  i3from = i3from +1;
  %% </ index config >
end
if  graph.TIGHT == 1;
  axis tight;
end
grid on; % for right-bottom subplot.
%% h: description about outer x-y axis
h = axes('Position',[0 0 1 1],'Visible','off'); 
set(gcf,'CurrentAxes',h)
text(.4,.95,title,'FontSize',12)
text(.12,.90,'Triggers')
text(.08,.85,'Targets')

%{
xlabel(h,'Trigger')
ylabel(h,'Target')
%}

%%% ===== PLOT alpha ===== END =====
%% write out eps file
%if graph.PLOT_T == 1
if 1 == 1
  print -depsc -tiff Estimated_alpha.eps
end

%% == CLEAN var ==
% clear SELF_DEPRESS_BASE;