function  [ResFunc_fig,ResFunc_hash,Oenv,Ostatus] = readTrueConnection(env,status,varargin)
%% read true connection of neurons
%% ============ about: input file ============
%% input file format)
%%  [N,N] matrix with each +/0/- entry.
%%    '+'        denotes excitatory neuron from
%%    '0'        denotes no connection
%%    '-'        denotes inhibitory neuron from
%% The shape of ResFunc_hash is 
%%           1:N         => [from #neuron]
%%   1  ---------------
%%  ||  |  ResFunc_fig |
%%  \/  ---------------
%%   N
%% [to #neuron]
%%
Oenv = env;
Ostatus = status;
tmp.in ='';

if nargin > 2
  tmp.in = varargin{1}; % must be absolute path
  tmp.in = char(tmp.in);
elseif isfield(status,'inStructFile')
  tmp.in = status.inStructFile;
end
if ~isempty(tmp.in)
elseif status.use.GUI == 1
  fprintf('Which file describing neuronal connections do you want to use?');
  tmp.in = uigetfile('*.con');
else
  tmp.in  = input(['Which file describing neuronal connections do you ' ...
                   'want to use?\n>> >> ']);
end
tmp.fid = fopen(tmp.in,'rt');

%% Need exception hundler: if (#column ~= #row )  %%++improve
%% fscanf repeat reading in dimention 2
[ResFunc_hash, Oenv.cnum ] = fscanf(tmp.fid,'%s'); % don't read LF.
                                                 %[ResFunc_hash, Oenv.cnum ] = fscanf(tmp.fid,'%s[+0-]'); % don't read LF.
ResFunc_hash = strrep(ResFunc_hash, '+','+1 ');
ResFunc_hash = strrep(ResFunc_hash, '0','0 ');
ResFunc_hash = strrep(ResFunc_hash, '-','-1 ');
%% remove comment line.
ResFunc_hash = regexprep(ResFunc_hash,'[a-z,A-Z,'','',''.'']','#');
ResFunc_hash = regexprep(ResFunc_hash,'(\#[0-9\ ]*)','');

ResFunc_hash = str2num(ResFunc_hash);
[garbage,N] = size(ResFunc_hash);
Oenv.cnum = uint64(sqrt(N));
if Oenv.cnum*Oenv.cnum ~= N
  error('Check your inputfile')
end
Oenv.cnum = double(Oenv.cnum);

%% The shape of ResFunc_hash is 
%                =>[to #neuron]
%      ---------------
%  ||  |  ResFunc_hash |
%  \/  ---------------
% [from #neuron]

ResFunc_fig = transpose(reshape(ResFunc_hash, Oenv.cnum , Oenv.cnum));


fclose(tmp.fid);

%% properly calculate Oenv.spar %++todo ++bug
if 1 == 1
  Oenv.spar.from = NaN;
  Oenv.spar.to   = NaN;
else
  Oenv.spar.from = sum(sum((ResFunc_fig ~= 0),1)>0)/Oenv.cnum;
  Oenv.spar.to =  sum(sum((ResFunc_fig ~= 0),2)>0)/Oenv.cnum;
end

Ostatus.inStructFile = tmp.in;
