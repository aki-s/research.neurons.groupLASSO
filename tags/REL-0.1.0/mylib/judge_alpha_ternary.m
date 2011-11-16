function [Ealpha_hash,Ealpha_fig,threshold,Econ] = judge_alpha_ternary(env,Ealpha,varargin)
%%
%function [Ealpha_hash] = judge_alpha_ternary(env,Ealpha,alpha_hash,regFacindex,Ebias)
%%


if size(varargin,2) > 0
  for k = 1:size(varargin,2)
    switch k
      case 1
        alpha_hash = varargin{k};
      case 2
        regFac = varargin{k};
      case 3
        status = varargin{k};        
      case 4
        Ebias = varargin{k};
    end
  end
end

if ~exist('regFac') %++bug
  regFac = 2;
end

cnum = env.cnum;

if ~exist('Ebias')
  for i1 = 1:env.cnum
    Ebias{i1}(1:10) = zeros(1,10);
  end
end
Eb_threshold = 5;

var_threshold = 0.1;

Ealpha_hash = zeros(cnum*cnum,1);
rateZeroEach = zeros(cnum,1);

kdelta = inline('a1 == a2','a1','a2'); % kronecker's delta

%% == ==
%% == ==
% large variance to 0 has high confident if regFac is large enough.
% so, pull out the cell intern as regFac become small.
%% == ==
Mmat = zeros(cnum); % Mmat: matrix of Mean
Vmat = zeros(cnum); % Vmat: matrix of valiance
threshold = zeros(2,cnum);
if iscell(Ealpha)
  [garbage, num ] = size(Ealpha);
  if num > 0
    TcountTotal = 0;
    rateZero = zeros(cnum,1); 
    for i1to = 1:cnum
      Tcount = 0; % True count
      Rmean = 0; % Row mean
      RVmean = 0;% Row variance mean
      [threshold(1,i1to), threshold(2,i1to)] = calcThreshold(cnum,Ealpha,regFac,i1to);
      for i2from = 1:cnum
        Mmat(i1to,i2from) = mean( Ealpha{regFac}{i1to}{i2from} );

        Eb = Ebias{i1to}(regFac);

        Vmat(i1to,i2from) = sum(( Ealpha{regFac}{i1to}{i2from}).^2);
        %{
        v = var( Ealpha{regFac}{i1to}{i2from} );
        if v > var_threshold
        end
        %}
        if  Mmat(i1to,i2from) > threshold(1,i1to)
          Eact = 1;
        elseif  Mmat(i1to,i2from) < threshold(2,i1to)
          Eact = -1;
        else
          Eact = 0;
        end
        if Eb < Eb_threshold
          Etype = +1; % excitatory
        else
          Etype = -1; % inhibitory
        end
        Tact = alpha_hash( (i1to-1)*cnum + i2from) ;
        if ( status.DEBUG.level > 3 )
          fprintf(1,'#%2d<-%2d M%10f V%10f Etype %2d Tact %2d Eact %2d\n' ...
                  , i1to ...
                  , i2from ...
                  , Mmat(i1to,i2from) ...
                  , Vmat(i1to,i2from) ...
                  , Etype ...
                  , Tact ...
                  , Eact ...
                  );
        end
        Tcount = Tcount + kdelta(Tact,Eact);
        rateZero(i1to) = rateZero(i1to) + kdelta(0,Eact);
        Ealpha_hash((i1to-1)*cnum+i2from,1) = Eact;
        Rmean = Rmean + Mmat(i1to,i2from);
        RVmean = RVmean + Vmat(i1to,i2from);
      end
      if ( status.DEBUG.level > 3 )
        fprintf(1,'\tRmean%6f RVmean%6f\n',Rmean/cnum,RVmean/cnum);
        fprintf(1,'\tPthreshold %6f Nthreshold %6f\n ',threshold(1,i1to),threshold(2,i1to));
        fprintf(1,'\t\t\t\t\t\t\t\tCorrect_Rate: %f\n',Tcount/cnum);
        fprintf(1,'\n');
      end
      TcountTotal = TcountTotal + Tcount;
      rateZeroEach(i1to) = sum(rateZero)/cnum;
    end
    Ealpha_hash = transpose(Ealpha_hash);
    Econ.rateT = TcountTotal/(cnum*cnum);
    Econ.rateZero = sum(rateZero)/cnum;
    Econ.rateZeroEach = rateZeroEach;
    fprintf(1,'regFac%f \t\t\t\t\t\tCorrect_Rate(Total): %f\n',regFac,Econ.rateT);
  end
end

med = median(Vmat,2);
filter = false(zeros);
for i2from = 1:cnum
  filter(:,i2from) = Vmat(:,i2from) > med;
end


Econ.Mmat = Mmat;
Econ.Vmat = Vmat;
Econ.filter = filter; % valid under high regFac. (Econ.Mmat).*(Econ.filter);
Ealpha_fig = reshape(Ealpha_hash,[],env.cnum);

function [ Pthreshold, Nthreshold] =  calcThreshold(cnum, Ealpha,regFac, i1to )
Pthreshold = 0;
P = 0;
Nthreshold = 0;
N = 0;

H = 0;
for i2from = 1:cnum
  m = mean( Ealpha{regFac}{i1to}{i2from} );
  if i1to == i2from

  elseif m > 0 % excitatory
    Pthreshold = Pthreshold + m; % median may be good
    P = P + 1;
  elseif m < 0 % inhibitory
    Nthreshold = Nthreshold + m;
    N = N + 1;
  else % hybrid
    H = H + 1;
  end
end
if P == 0
  Pthreshold = 0;
else
  Pthreshold = Pthreshold/P;
end
if N == 0
  Nthreshold = 0;
else
  Nthreshold = Nthreshold/N;
end
