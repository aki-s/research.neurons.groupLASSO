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

if strcmp('GUI','_GUI')
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

[alpha_hash, env.cnum ] = fscanf(tmp.fid,'%s'); % don't read LF.
alpha_hash = strrep(alpha_hash, '+','+1 ');
alpha_hash = strrep(alpha_hash, '0','0 ');
alpha_hash = strrep(alpha_hash, '-','-1 ');
alpha_hash = str2num(alpha_hash);

%alpha_hash = reshape( alpha_hash , env.cnum , [] ); %worked well
%++bug : next line would fail if input has other than '[+0-\n]'
%env.cnum = sqrt(matNum);

fclose(tmp.fid);
% LocalWords:  excitatory
