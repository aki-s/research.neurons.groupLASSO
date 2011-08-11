%function [Ealpha_hash] = judge_alpha_ternary(env,Ealpha)
function [Ealpha_hash,threshold,Econ] = judge_alpha_ternary(env,Ealpha,varargin)
%%
%function [Ealpha_hash] = judge_alpha_ternary(env,Ealpha,Ebias,regFacindex,alpha_hash)
%%

if size(varargin,2) > 0
  for k = 1:size(varargin,2)
    switch k
      case 1
        Ebias = varargin{k};
      case 2
        regFac = varargin{k}
      case 3
        alpha_hash = varargin{k};
    end
  end
end

if ~exist('regFac')
  regFac = 2;
end

cnum = env.cnum;

Eb_threshold = 5;

var_threshold = 0.1;

Ealpha_hash = zeros(cnum,1);

kdelta = inline('a1 == a2','a1','a2'); % kronecker's delta
%% == ==

%% == ==
% large variance to 0 has high confident if regFac is large enough.
% so, pull out the cell intern as regFac become small.
%% == ==
Mmat = zeros(cnum);
Vmat = zeros(cnum);
threshold = zeros(2,cnum);
if iscell(Ealpha)
  [garbage, num ] = size(Ealpha);
  if num > 1
    countTotal = 0;
    for i1to = 1:cnum
      count = 0;
      Rmean = 0;
      RVmean = 0;
      [threshold(1,i1to), threshold(2,i1to)] = caclThreshold(cnum,Ealpha,regFac,i1to);
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

        fprintf(1,'#%2d<-%2d M%10f V%10f Etype %2d Tact %2d Eact %2d\n' ...
                , i1to ...
                , i2from ...
                , Mmat(i1to,i2from) ...
                , Vmat(i1to,i2from) ...
                , Etype ...
                , Tact ...
                , Eact ...
                );
        count = count + kdelta(Tact,Eact);
        Ealpha_hash((i1to-1)*cnum+i2from,1) = Eact;
        Rmean = Rmean + Mmat(i1to,i2from);
        RVmean = RVmean + Vmat(i1to,i2from);
      end
      fprintf(1,'\tRmean%6f RVmean%6f\n',Rmean/cnum,RVmean/cnum);
      fprintf(1,'\tPthreshold %6f Nthreshold %6f\n ',threshold(1,i1to),threshold(2,i1to));
      fprintf(1,'\t\t\t\t\t\t\t\tCorrect_Rate: %f\n',count/cnum);
      fprintf(1,'\n');
      countTotal = countTotal + count;
    end
    Ealpha_hash = transpose(Ealpha_hash);
    fprintf(1,'\t\t\t\t\t\t\t\tCorrect_Rate(Total): %f\n',countTotal/(cnum*cnum));
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

function [ Pthreshold, Nthreshold] =  caclThreshold(cnum, Ealpha,regFac, i1to )
Pthreshold = 0;
P = 0;
Nthreshold = 0;
N = 0;
for i2from = 1:cnum
  m = mean( Ealpha{regFac}{i1to}{i2from} );
  if i1to == i2from

  elseif m > 0 
    Pthreshold = Pthreshold + m; % median may be good
    P = P + 1;
  else
    Nthreshold = Nthreshold + m;
    N = N + 1;
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