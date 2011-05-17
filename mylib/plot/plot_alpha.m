function plot_alpha(cnum,hnum,alpha0,alpha,title);
%%
%% Usage:
%% arg1 == variable: number of cells 
%% arg2 == variable: number of history windows
%% arg3 == variable: alpha
%% arg4 == string: title of plotted window
%%
%% Example:
%  plot_alpha(env.cnum,env.hnum,alpha0,alpha,'\alpha: Spatio-temporal Kernels');
%%

global env

%%% ===== PLOT alpha ===== START =====
if isfield(env,'SELF_DEPRESS_BASE') && isempty(getfield(env,'SELF_DEPRESS_BASE'))
  SELF_DEPRESS_BASE = 2;
else
  SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
end
if exist('gain') == 0
  gain = 1;
end
if exist('OUTPUT_EPS') == 0
  OUTPUT_EPS = 0;
end

if 1 == 1
  i3 = 1; i4 = 1;
  figure;
  %    h1=axes('Position',[.15 .1 0.8 0.65]);
  %    subplot(h1)
  %axes('Position',[.15 .1 0.8 0.65]);
  for i1 = 1:cnum*cnum
    %%    axis tight;
    grid on;
    %% subplot() delete existing Axes property.
    % subplot(cnum,cnum,i1,'Position',[.15 .1 0.8 0.75],'Visible','on')
    subplot(cnum,cnum,i1)
    %% < chage color ploted according to cell type >

    tmp1 = reshape(alpha(i3,i4,:),1,hnum);
    if i3 == i4
      tmp1 = tmp1 + alpha0(i3);
    end
    if tmp1 > 0
      plot( 1:hnum, reshape(tmp1,1,hnum),'r');
    elseif tmp1 < 0
      plot( 1:hnum, reshape(tmp1,1,hnum),'b');
    else 
      plot( 1:hnum, reshape(tmp1,1,hnum),'k');
    end
    %% </ chage color ploted according to cell type >
    xlim([0,hnum]);
    ylim([-SELF_DEPRESS_BASE*gain-2,2]);
    set(gca,'XAxisLocation','top');

    %% < from-to cell label >
    if (i3 == 1)     % When in the topmost margin.
      xlabel(i4);
    end
    if (i4 == 1) ylabel(i3); % When in the leftmost margin.
    end
    %% </ from-to cell label >

    %% < index config >
    if (i4 == cnum ) i3 = i3 +1; i4 = 0; end % When in the righmost margin.
    i4 = i4 +1;
    %% </ index config >
  end
  %%  axis tight;
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
  if OUTPUT_EPS == 1
    print -depsc -tiff artificial_alpha.eps
  end
end
