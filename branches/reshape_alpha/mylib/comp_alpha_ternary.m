%function [Ealpha_hash] = judge_alpha_ternary(env,Ealpha)
function [Ealpha_hash] = judge_alpha_ternary(env,Ealpha,varargin)
%%
%function [Ealpha_hash] = judge_alpha_ternary(env,Ealpha,Ebias,FAC,alpha_hash)
%%

if optargin > 0
  Ebias = varargin{1};
  FAC = varargin{2};
  alpha_hash = varargin{3};
else
  FAC = 2;
end
cnum = env.cnum;

Eb_threshold = 5;
var_threshold = 1;
mean_threshold = 0.1;

Ealpha_hash = zeros(cnum,1);

kdelta = inline('a1 == a2','a1','a2'); % kronecker's delta

if iscell(Ealpha)
  [garbage, num ] = size(Ealpha);
  if num > 1
    countTotal = 0;
    for i1to = 1:cnum
      count = 0;
      for i2from = 1:cnum
        m = mean(Ealpha{FAC}{i1to}{i2from});
        v = var (Ealpha{FAC}{i1to}{i2from}); % large variance has high confident?
        Eb = Ebias{i1to}(FAC);

        if v < var_threshold
          if m > mean_threshold
            Eact = 1;
          elseif m < - mean_threshold
            Eact = -1;
          else
            Eact = 0;
          end
        end
        if Eb < Eb_threshold
          Etype = +1; % excitatory
        else
          Etype = -1; % inhibitory
        end
        Tact = alpha_hash( (i1to-1)*cnum + i2from) ;

        fprintf(1,'#%2d<-%2d M%10f V%10f Etype %2d FLAG %2d Eact %2d\n' ...
                , i1to ...
                , i2from ...
                , m ...
                , v ...
                , Etype ...
                , Tact ...
                , Eact ...
                );
        count = count + kdelta(Tact,Eact);
        Ealpha_hash((i1to-1)*cnum+i2from,1) = Eact;
      end
      fprintf(1,'\t\t\t\t\t\t\t\tCorrect_Rate: %f\n',count/cnum);
      fprintf(1,'\n');
      countTotal = countTotal + count;
    end
    Ealpha_hash = transpose(Ealpha_hash);
    fprintf(1,'\t\t\t\t\t\t\t\tCorrect_Rate(Total): %f\n',countTotal/cnum);
  end
end
