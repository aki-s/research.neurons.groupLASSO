%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Place this file at outdir/DD-M-YY_start_HH_M/
%% cd to the directory.
%% Tweek a bit and run to obtain estimated connection on real data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%< Tweek_here >%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FNAME_ID='120113_1305'
if 1
  %  cd outdir/13-Jan-2012_start_13_5/
  run ../../conf/setpaths.m
end
load 14-Jan-2012_start_13_5.mat
CVIN = [rootdir_ '/outdir/13-Jan-2012-start-13_5/CV/'];
matlist = {[CVIN '/Aki-0004.0000-rec072b-0033732-060-CV1.mat']};
graph.PRINT_T =1;
env.inFiringUSE = [60];
FLAG_4LATEX=1; % save parameter for output filename.
CLOSE = 1; %++bug: not recommended to set 'CLOSE = 0'.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%< Tweek_here/>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if 0
  for i0=1:length(env.inFiringUSE)
    [CVLs{i0}] = get_CVLsummary(CVL{i0},length(env.useFrame),env.inFiringUSE(i0));
    status.validUseFrameIdx = sum(~isnan(CVLs{i0}.minTotal));
    status.DEBUG.level=0;
    env.cnum=(env.inFiringUSE(i0));
    plot_CVLwhole(env,status,graph,DAL,CVL{1},1)
% $$$   ylim([1 2])
  end
  %% fname date-sort for latex
  if FLAG_4LATEX
    save_plottedGraphAll('%s_CVL_',FNAME_ID,status.savedirname)
  end
  if CLOSE
    close all
  end
end

if 0 
  %% If env.cnum >= c.a. 30
  %% Use plot_CausalMatrix(), which is better.
  for i1= 1:length(matlist)
    s1 = load(matlist{i1});
    s1.graph.PLOT_MAX_NUM_OF_NEURO = 60;
    %% bug++: s1.EbasisWeight had no value
    s1.graph.PRINT_T =1;
    plot_EResFunc(s1.env,s1.graph,s1.status,s1.DAL,s1.bases,s1.EbasisWeight,'',10)
    %% fname date-sort for latex
    if FLAG_4LATEX
      save_plottedGraphAll('_EResFunc_',status.savedirname)
    end
% $$$   s1.DAL.regFacLen=1;%++bug
% $$$   s1.env.cnum = env.inFiringUSE(i1); %++bug
% $$$   plot_ResFunc(s1.graph,s1.env,s1.EResFunc,'',status.savedirname,sprintf('%s_ResFunc_%d',FNAME_ID,i1))
    if CLOSE
      close all
    end
  end
end

%%%%%%%%%% plot_ResFuncSuperpose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%< Tweek_here >%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
intensityTHRESH=170;
YRANGEIN=[-1 1]*4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%< Tweek_here/>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Fpeaks = get_basisPeaks(bases.ihbasis);
[conMat0] = plot_ResFuncSuperpose(status.savedirname,DAL.regFac(10),33732,60,[0 bases.ihbasprs.numFrame],YRANGEIN,Fpeaks,intensityTHRESH);
%% fname date-sort for latex
save_plottedGraphAll('%s_disfunc_',FNAME_ID,status.savedirname)
if CLOSE
  close all;
end

%%%%%%%%%% drow arrow on 2D slice of a brain sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%< Tweek_here >%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
peakTHRESH = 0.01;
s2 = load([rootdir_ '/indir/gaya/rec072b.mat']);
location = s2.u;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%< Tweek_here/>%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i1 = 1:length(matlist)
  s3 = load(matlist{1});
  %% threshold is determined based on plot_ResFuncSuperpose().
  [conMat1] = plot_con2Dslice(location,matlist{i1},peakTHRESH,intensityTHRESH);
  plot_CausalMatrix(sign(conMat1),sprintf('%4d',s3.env.inFiringUSE(i1)))
  save_plottedGraphAll(sprintf('%s_realData_%04d_' ...
                               ,FNAME_ID,s3.env.inFiringUSE(i1)),status.savedirname)
  if CLOSE
    close all;
  end
end
