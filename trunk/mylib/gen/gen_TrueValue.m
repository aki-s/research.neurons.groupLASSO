%% function [rHistSec,rSimsec,alpha] = gen_TrueValue(env,HistSec,SimSec)
% [[arg]]
% cnum: number of cell
% HistSec: time scale affecting neuronal firing as history [sec]
% SimSec: sec during which 'TrueValues' are prepared.
% 	: Simsec = 1/Hz.video * genLoop [sec]
% [[return]]
% r{HistSec,Simsec}: real{History sec, simulation sec}


if strcmp('clear','clear_')
  clear all; close all;
end
%% ==< set local variables >==
%global env
Hz      = env.Hz     ;      
hwind   = env.hwind  ;   
genLoop = env.genLoop; 
cnum    = env.cnum   ;    
hnum    = env.hnum   ;    
spar    = env.spar   ;
SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;

%%% ===== prepare True Values ===== START ===== 
if strcmp('prepareTrueValues','prepareTrueValues')

  SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;

  ctype = floor(randn(1,cnum)/100); % tweek SD by deviding with 100
  ctype_hash = ctype;
  Tout.ctypesum.inhibitory = length(find(ctype == -1)); % number of inhibitory neurons.
  Tout.ctypesum.excitatory = length(find(ctype == 0)); % number of excitatory neurons.

  alpha = zeros(cnum,cnum,hnum); % connection 'false' at all elements.
  alpha_hash = zeros(cnum,cnum);
  alpha_hash(spar.from,spar.to) = 1; % connection 'true'.
  alpha_hash(logical(eye(cnum))) = 1; % diagonal element: connection 'true'.
  phase = rand([cnum cnum])/2;

  %% ctype: ctype of neuron. 0 == excitatory, -1 == inhibitory
  ctype = repmat(ctype*pi,cnum,1);
  ctype(logical(eye(cnum))) = -pi;  % All neuron must have self-depression.


  if 1 == 1
    for i1 = 1:hnum
      alpha(:,:,i1) = ( cos( phase + ctype + i1/hnum ) - ones(cnum)*SELF_DEPRESS_BASE )*exp(-(i1-1)/hnum*3 );
      %    alpha(:,:,) = sin(log(1:hnum*pi/hnum/20));
      %% use more trigonometric funcions with variety of angular frequency.
    end
    %    alpha = alpha - repmat(eye(cnum)*SELF_DEPRESS_BASE,[1 1
    %    hnum]);
% $$$ for i1 =1:cnum
% $$$   for i2 =1:hnum
% $$$     alpha( i1,i1,i2) =  ( cos( phase + ctype + i2/hnum ) ...
% $$$                          -SELF_DEPRESS_BASE)*exp(-(i2-1)/hnum*3 );
% $$$   end
% $$$ end

  elseif strcmp('tmp','tmp_')
      for i1 = 1:cnum
        for i2 = 1:cnum
          alpha(i1,i2,:) = gg.ihbasis(1:hnum,4)/3;
        end
      end
  end
  alpha = alpha.*repmat(alpha_hash,[1 1 hnum]); % make connection sparse.
  %  I = zeros(hnum*hwind,cnum);
  I = zeros(hnum*hwind,cnum);

  %% nI:  Empty array: 0-by-6-by-10. (time,number of cells, number of history)
  nIt = zeros([],cnum,hnum);

  %%% ===== SET AUTO FIRING RATE ===== START =====                                          
  fprintf(1,'Total history width %f[sec]\n',hnum*hwind/Hz.video);

  Hz.fn = Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  %% alpha0: (1,cnum) matrix. correspond to auto firing of each cell.
  if strcmp('gen_individuality','gen_individuality')
    alpha0 = Hz.fn*(1 + rand(1,cnum) ); % alpha0: self firing-depress weight.
  else
    alpha0 = repmat(Hz.fn,1,cnum);
  end
  %%% ===== PLOT alpha ===== START =====
  if ( 1 == graph.PLOT_T )
    %% ++bug: func plot_alpha must be given 'env'.
    plot_alpha(cnum,hnum,alpha0,alpha,'\alpha: Spatio-temporal Kernels');
  end
  if graph.SAVE_EPS == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/true_alpha.eps'])
  end

  %%% ===== SET AUTO FIRING RATE ===== END =====            
  Tout.simtime = genLoop/Hz.video;
  fprintf(1,'Time of simulation %f[sec]\n',Tout.simtime);
  Tout.simtime = sprintf('%f[sec]',Tout.simtime);
  %% lambda: (genLoop,cnum) matrix. Firing rate per frame. [rate/frame]
  lambda = [];
  loglambda = []; % loglambda: log( lambda )
                  %nI = zeros(1+genLoop,cnum,hnum);
  %% i2: correspond to 'time' t.

  %%%% GENERATE LAMBDA (FIRING RATES OF NERURONS) == START ==
  %% def: I, nI, loglambda, lambda
  for i2 = 1:genLoop
    %% ( genLoop -1 [frame] ) * dt [time/frame] == T [time]
    %%%% ===== renew number of spikes fired by cell c at lag m ===== 
    %%%% ===== START =====
    for i1 = 1:hnum
      %% nIt(t,c,m): number of firing in cell c at lag m.
      %% correspond to I_{c,m}(t).                                   
      nIt(i2,:,i1) = sum(I(end - i1*hwind +1 : end - (i1-1)*hwind,:),1);
    end
    %%%% ===== renew number of spikes fired by cell c at lag m ===== 
    %%%% ===== END =====
    %% nItrep: [ time cnum cnum hnum ] matrix.
    nItrep(i2,:,:,:) = repmat( nIt(i2,:,:),[cnum 1 1]);
    %% tmp1: equation (1)
    tmp1 = alpha0 + transpose(sum(sum(alpha.*shiftdim(nItrep(i2,:,:,:)),3),2));
    %% I don't know dot() is more faster than sum().
    %    tmp1 = alpha0 + transpose(sum(dot(alpha, shiftdim(nItrep(i2,:,:,:)),3)),2);
    loglambda = [ loglambda; tmp1 ];
    tmp2 = exp( tmp1 ); 
    lambda = [ lambda; tmp2 ]; % store time series of lambda
                               %    rand('seed',randIndex);
                               %    randIndex = randIndex +1;
    %% poisson process. 
    %%    tmp3 = poissrnd(tmp2,1,cnum);
    tmp3 = exp(-tmp2/Hz.video).*(tmp2/Hz.video); 
    tmp3 = rand(1,cnum) < tmp3;
    I = [I;tmp3];
  end
end
Tout.ctype = sprintf('%4d',ctype_hash);
Tout.I = sprintf('%4d',sum(I,1));
I = sparse(I);
%%% ===== PLOT LAMBDA ===== START =====
if 1 == graph.PLOT_T
  plot_lambda(cnum,genLoop,lambda,'\lambda: Firing Rates [per frame]');
  %%% ===== PLOT LAMBDA ===== END =====
  %% write out eps file
  if graph.SAVE_EPS == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_lambda.eps'])
  end
end
%%% ===== PLOT LAMBDA ===== END =====

%%% ===== PLOT I(t) ===== START =====
if 1 == graph.PLOT_T
  plot_I(cnum,genLoop,hnum,hwind,I,'I(t): Spikes [per frame]')
  %%% ===== PLOT I(t) ===== END =====
  %% write out eps file
  if graph.SAVE_EPS == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_I.eps'])
  end
end
%%% ===== PLOT I(t) ===== START =====

%% ==< clean variables >== % for when this file wasn't called as a function.
clear Hz           
clear hwind     
clear genLoop 
clear cnum       
clear hnum       
clear spar   
clear SELF_DEPRESS_BASE 
clear ctype ctype_hash
%% ==</ clean variables >==
