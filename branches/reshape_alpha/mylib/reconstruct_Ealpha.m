function [Ealpha, Ograph] = reconstruct_Ealpha(env,graph,DAL,bases,EKerWeight,varargin)

%% Ealpha:
%%
Ograph = graph;

cnum = env.cnum;

Ealpha = cell(zeros(1,length(DAL.regFac)));

Mt = 0;
Md = 0;
mt = 0;
md = 0;
IN = 5;
if nargin >= IN +1
  FROM =  varargin{ 1};
  regFacLen  = FROM(end);
else
  FROM = 1;
  regFacLen = length(DAL.regFac);
end
if strcmp(bases.type,'bar')
  for i0 = FROM:regFacLen
    for i1to = 1:cnum
      for i2from = 1:cnum
        Ealpha{i0}{i1to}{i2from} =  EKerWeight{i0}{i1to}(:,i2from);
      end
    end
  end
elseif  strcmp(bases.type,'glm')
  for i0 = FROM:regFacLen
    for i1to = 1:cnum
      for i2from = 1:cnum
        Ealpha{i0}{i1to}{i2from} = (bases.ihbasis* EKerWeight{i0}{i1to}(:,i2from));
        M = max(Ealpha{i0}{i1to}{i2from});
        m = min(Ealpha{i0}{i1to}{i2from});
        if ( i1to ~= i2from )
          if ( M > Mt )
            Mt = M;
          end
          if ( m < mt )
            mt = m;
          end
        elseif ( i1to == i2from )
          if ( M > Md )
            Md = M;
          end
          if ( m < md)
            md = m;
          end
        end
      end
    end
  end
end
Ograph.prm.diag_Yrange_auto = [md,Md];
Ograph.prm.Yrange_auto      = [mt,Mt];
Ograph.prm.diag_Yrange = graph.prm.diag_Yrange;
Ograph.prm.Yrange = graph.prm.Yrange;

if strcmp('showMaxMin','showMaxMin')
  %fprintf(1,'diag:[%f],~diag:[%f]\n',Ograph.prm.diag_Yrange_auto,Ograph.prm.Yrange_auto)
  fprintf(1, 'diag:[%5f,%5f] ',Ograph.prm.diag_Yrange_auto(1),Ograph.prm.diag_Yrange_auto(2))
  fprintf(1,'~diag:[%5f,%5f]\n',Ograph.prm.Yrange_auto(1),Ograph.prm.Yrange_auto(2))
end
