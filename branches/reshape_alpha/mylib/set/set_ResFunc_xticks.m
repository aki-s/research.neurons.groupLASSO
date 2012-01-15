if strcmp('set_xticks','set_xticks')
  Lnum = 2; % Lnum: the number of x label
  dh = floor((hnum*hwind)/Lnum); %dh: width of each tick.
  ddh = dh/Hz; %  convert XTick unit from [frame] to [sec]
  TIMEL = cell(1,Lnum+1);
  for i1 = 1:Lnum+1
    DIGIT = 2;
    SHIFT = 10^DIGIT; %%++bug: round off for easy observation.
    TIMEL{i1} = round((i1-1)*ddh*SHIFT)/SHIFT;
    %%++bug: %4.2f may be be better than round()
    %  TIMEL{i1} = sprintf( '%.3d',(i1-1)*ddh);
  end
end
XSIZE = 1; %++bug: to watch hem of ResFunc.
