function save_plottedGraphAll(FnamePrefix,varargin)
%%
%% example)
% save_plottedGraphAll('FnamePrefix',status.savedirname)
% save_plottedGraphAll('FnamePrefix',status.savedirname,DAL)
% save_plottedGraphAll('FnamePrefix',status.savedirname,DAL,eval(cnum))
% save_plottedGraphAll('FnamePrefix',status.savedirname,DAL,eval(cnum),4)
%%
%% the name of figure wrote out is print out to sdout.

%% ==< init >==
figHandles = get(0,'Children');
hdl = length(figHandles);
ARGNUM = 0;
IN = 1;
GROUP = 1;
%% ==</init >==

%% example)
%% save_plottedGraphAll('status.outdirname')
if isdir(varargin{1}) && (nargin == IN+1)
  savedirname = varargin{1};
  ARGNUM = 1;
end
if nargin >= IN+2
  %% example)
  %% save_plottedGraphAll(status.savedirname,DAL)
  if isdir(varargin{1}) 
    savedirname = varargin{1};
  else
    error('varargin{1} must be save dirname')
  end
  if isstruct(varargin{2})
    DAL = varargin{2};
    Dlen = length(DAL.regFac);
    ARGNUM = 2;
  end
end
if nargin >=IN+3
  %% example)
  %% save_plottedGraphAll(status.savedirname,DAL,eval(cnum))
  cnum = varargin{3};
  ARGNUM = 3;
end
if nargin >=IN+4
  %% example)
  %% save_plottedGraphAll(status.savedirname,DAL,eval(cnum),4)
  GROUP = varargin{4}; % 'GROUP' figures are from the same condition.
  ARGNUM = 4;
end
if nargin >=IN+5
  ARGNUM = 5;
  regCount = varargin{5};
end
%% ==< CHECK >==
%{
if (Dlen*GROUP) == hdl
  % check o.k.
else
  error('length(DAL.regFac) ~= #(figure handler)');
end
%}
plate = (sqrt(GROUP).^2);
gnum = hdl / plate;
%% ==</CHECK >==
switch ARGNUM
  case 1
    for i1 = 1:hdl
      print(figHandles(i1),'-dpng',[sprintf('%s/%s%02d',savedirname,FnamePrefix,i1) ...
            '.png']);
      fprintf(1,'saved:%s/%s%02d.png\n',savedirname,FnamePrefix,i1);
    end
  case 2
    for i1 = 1:hdl
      print(figHandles(i1),'-dpng',sprintf(['%s/' ...
                          'regFac=%05d'],savedirname,DAL.regFac(i1)) );
fprintf('saveas\')
      saveas(figHandles(i1),sprintf(['%s/' ...
                          'regFac=%05d'],savedirname,DAL.regFac(i1)),'epsc2' )
    end
  case 3
    for i1 = 1:hdl
      print(figHandles(i1),'-dpng',sprintf(['%s/' ...
                          'regFac=%05d_cnum=%05d'],savedirname,DAL.regFac(i1),cnum));
      fprintf(1,'saved:%s/regFac=%05dcnum=%05d.png\n',savedirname,DAL.regFac(i1),cnum);
    end
  case 4
    regCount = 1;
    count = plate;
    for i1 = 1:hdl
      print(figHandles(i1),'-dpng',...
            sprintf('%s/regFac=%05d_cnum=%05d_%0plate',...
                    savedirname,DAL.regFac(regCount),cnum,count));
      fprintf(1,'saved:%s/regFac=%05dcnum=%05d_%0plate.png\n',...
              savedirname,DAL.regFac(regCount),cnum,count);
      if ~mod(count,GROUP)
        count = plate;
        regCount = regCount +1;
      end
    end
  case 5
    idx = regCount+(0:gnum-1);
    regCount = 1;
    idx = fliplr(idx);
    count = plate;
    for i1 = 1:hdl
      print(figHandles(i1),'-dpng',...
            sprintf('%s/%sregFac=%05d_cnum=%05d_%0plate',...
                    savedirname,FnamePrefix,DAL.regFac(idx(regCount)),cnum,count));
      fprintf(1,'saved:%s/%sregFac=%05dcnum=%05d_%0plate\n',...
              savedirname,FnamePrefix,DAL.regFac(idx(regCount)),cnum,count);
      count = count -1;
      if ~mod(count,GROUP)
        count = plate;
        regCount = regCount +1;
      end
    end
end

