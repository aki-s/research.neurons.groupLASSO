%function [EResFunc, Ograph] = reconstruct_EResFunc(env,graph,DAL,bases,EbasisWeight,varargin)
function [EResFunc, Ograph] = reconstruct_EResFunc(cnum,graph,DAL,bases,EbasisWeight,varargin)

%% EResFunc:
%%
Ograph = graph;

%cnum = env.cnum;
% $$$ if cnum == env.inFiringUSE
% $$$ 
% $$$ end
EResFunc = cell(zeros(1,length(DAL.regFac)));
%%  -----> regFac
%% |
%% |
%%\ /
%% used_frame

Mt = 0;
Md = 0;
mt = 0;
md = 0;
IN = 5;
if nargin >= IN +1
  %% reconstruct used_frame reconstruct corresponding with varargin{1}
  regFacIdx.from =  varargin{ 1};
  regFacIdx.to  = regFacIdx.from;
else% reconstruct using all given regFac
  regFacIdx.from = 1;
  regFacIdx.to = length(DAL.regFac);
end
if strcmp(bases.ihbasprs.basisType,'bar')
  for i0 = regFacIdx.from:regFacIdx.to
    for i1to = 1:cnum
      for i2from = 1:cnum
        EResFunc{i0}{i1to}{i2from} =  EbasisWeight{i0}{i1to}(:,i2from);
      end
    end
  end
elseif  strcmp(bases.ihbasprs.basisType,'glm')
  for i0 = regFacIdx.from:regFacIdx.to
    for i1to = 1:cnum
      for i2from = 1:cnum
        EResFunc{i0}{i1to}{i2from} = (bases.ihbasis* EbasisWeight{i0}{i1to}(:,i2from));
        M = max(EResFunc{i0}{i1to}{i2from});
        m = min(EResFunc{i0}{i1to}{i2from});
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
  fprintf(1,'\tregFac:%9.4f~%9.4f| ',DAL.regFac(regFacIdx.from),DAL.regFac(regFacIdx.to));
  %fprintf(1,'diag:[%f],~diag:[%f]\n',Ograph.prm.diag_Yrange_auto,Ograph.prm.Yrange_auto)
  fprintf(1, 'diag:[%5.2f,%5.2f] ',Ograph.prm.diag_Yrange_auto(1),Ograph.prm.diag_Yrange_auto(2))
  fprintf(1,'~diag:[%5.2f,%5.2f]\n',Ograph.prm.Yrange_auto(1),Ograph.prm.Yrange_auto(2))
end
