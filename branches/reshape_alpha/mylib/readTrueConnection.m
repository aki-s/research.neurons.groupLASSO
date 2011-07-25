function  [alpha_fig,alpha_hash] = readTrueConnection()
%function  [alpha_fig,alpha_hash] = readTrueConnection(env,status)
%% ============ about: input file ============
%% read true connection of neurons
%% input file format)
%% -   [N,N] matrix with each +/0/- entry.
%% --               [column index #from]
%%   [row index #to]          '+'        denotes excitatory neuron from
%%   a neuron #from to #to.
%% --               [column index #from]
%%   [row index #to]          '0'        denotes no connection
%%   between neuron #from and #to.
%% --               [column index #from]
%%   [row index #to]          '-'        denotes inhibitory neuron from
%%   a neuron #from to #to.
%%

if 1 == 1
global env
global status

else

end

%if status.GUI
%if strcmp('GUI','_GUI')
if status.use.GUI == 1
fprintf('Which file describing neuronal connections do you want to use?');
tmp.in = uigetfile('*.con');
else
tmp.in  = input(['Which file describing neuronal connections do you ' ...
                'want to use?\n>> >> ']);
end
tmp.fid = fopen(tmp.in,'rt');

%[mat , matNum] = fscanf(tmp.fid,'%c');
%mat = str2mat(cellstr(mat));
%[mat , matNum] = fscanf(tmp.fid,'%[+0-]');
%[mat , matNum] = fscanf(tmp.fid,'%[+0-]*\r*\n');

%% Need exception hundler: if (#column ~= #row )  %%++improve
[alpha_hash, env.cnum ] = fscanf(tmp.fid,'%s'); % don't read LF.
alpha_hash = strrep(alpha_hash, '+','+1 ');
alpha_hash = strrep(alpha_hash, '0','0 ');
alpha_hash = strrep(alpha_hash, '-','-1 ');
alpha_hash = str2num(alpha_hash);

%% The shape of alpha_hash is 
%                =>[to #neuron]
%      ---------------
%  ||  |  alpha_hash |
%  \/  ---------------
% [from #neuron]

alpha_fig = transpose(reshape(alpha_hash, env.cnum , env.cnum));


fclose(tmp.fid);

%% calculate env.spar %++todo ++bug
if 1 == 1
env.spar.from = NaN;
env.spar.to   = NaN;
else
env.spar.from = sum(sum(alpha_fig ~= 0));
env.spar.to = env.spar.to;
end
