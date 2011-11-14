function plot_Ealpha_profile(env,graph,status,DAL)
%%
%%
%% usage)
% plot_Ealpha_profile(env,graph,status,DAL)
%%
%% varargin{1}: index to select and plot only one sample.
%%            index correspond with index of DAL.regFac.

graph.prm.showWeightDistribution = 1;
WIDTH = 550;
switch 4
  case 1
    legendLoc = 'South';
  case 2
    legendLoc = 'Best';
  case 3
    legendLoc = 'WestOutside';
  case 4
    legendLoc = 'SouthWest';
end

nargin_NUM = 4;
if nargin >= ( nargin_NUM +1 )% only one frame
  FROM = varargin{1};
  uF = FROM;
else % mix ALL
  FROM = 1;
  uF = status.validUseFrameIdx;
end

uR = length(DAL.regFac);
cSET = length(env.inFiringUSE);

uFnum = cell(1,uF);
XLABEL = cell(1,uF);
regFac = cell(1,uR);
inFiringUSE = cell(1,cSET);

for i1 =1:uF
  uFnum{i1} = num2str(sprintf('%07d',env.useFrame(i1)));
  XLABEL{i1} = num2str(sprintf('%.0e',env.useFrame(i1)));
end
for i1 =1:uR
  regFac{i1} = num2str(sprintf('%09.4f',DAL.regFac(i1)));
  %  XLABELrf{i1} = num2str(sprintf('%d',DAL.regFac(i1)));
end
XLABELrf = num2cell(DAL.regFac);
for i1 = 1:cSET
  inFiringUSE{i1} = num2str(sprintf('%03d',env.inFiringUSE(i1)));
end
fFNAME = regexprep(status.inFiring,'(.*/)(.*)(.mat)','$2');
inRoot = regexprep(status.outputfilename,'(.*/)(.*)(.mat)','$1');
%%%%%%%%%%%%%%%%%%%%%%%%
for j0 = FROM:uF
disp( sprintf( 'usedFrame: %9.4f',env.useFrame(j0)))
  for i0 = 1:cSET
    for regFacIdx = 1:uR
      filename =sprintf('%s-%s-%s-%s-%s.mat',status.method, regFac{regFacIdx}, ...
                        fFNAME, uFnum{j0}, inFiringUSE{i0});
      s = load( [inRoot '/' filename], 'bases','EbasisWeight');%++bug:name
      %%    fprintf(1,'loaded:\t Frame: %9.4f\n',env.useFrame(i1));
      plot_Ealpha(env,graph,DAL,s.bases,s.EbasisWeight,regFacIdx,... 
                  sprintf('elapsed:%s', ...
                          num2str(status.time.regFac(j0,regFacIdx))) ...
                  )
      %{
 % change plot locate for each useFrame
      set(gcf, 'Color', 'White', 'Position',[WIDTH*(j0-1), ...
                          800,400,400])
      %}
    end
  end
  fprintf(1,'\n');
end
