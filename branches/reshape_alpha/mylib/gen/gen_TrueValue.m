%% function [rHistSec,rSimsec,alpha] = gen_TrueValue(env,HistSec,SimSec)
% [[arg]]
% cnum: number of cell
% HistSec: time scale affecting neuronal firing as history [sec]
% SimSec: sec during which 'TrueValues' are prepared.
% 	: Simsec = 1/Hz.video * genLoop [sec]
% [[return]]
% {rHistSec,rSimsec}: real{History sec, simulation sec}

%% ==< set local variables >==
Hz      = env.Hz     ;      
hwind   = env.hwind  ;   
genLoop = env.genLoop; 
cnum    = env.cnum   ;    
hnum    = env.hnum   ;    
SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
%% ==</ set local variables >==

alpha = zeros(hnum*cnum,cnum);
if ( status.READ_NEURO_CONNECTION == 1 )
  %% ==< get neuron type >==
  tmp_alpha_fig = alpha_fig;
  tmp_alpha_fig( logical( eye( env.cnum))) = 0; % ignore property
                                                % of diagonal elements.

  inhibitory = 0; % number of inhibitory neurons.
  excitatory = 0; % number of excitatory neurons
  hybrid =     0; % number of hybrid (excitatory,inhibitory) neurons
  zeroConnection =     0; % number of zero connection neurons
  for i1 = 1:env.cnum %++parallel
    logicP = isempty(find(tmp_alpha_fig(:,i1)<0));
    logicN = isempty(find(tmp_alpha_fig(:,i1)>0));
    logicZ = logicP & logicN ;
    switch( logicZ )
      case 0
        if ( logicP | logicN )
          excitatory = excitatory +logicP; % number of excitatory neurons
          inhibitory = inhibitory +logicN; % number of inhibitory neurons.
        else
          hybrid     = hybrid     + 1; % number of excitatory neurons.                                       
        end
      case 1
        zeroConnection = zeroConnection +1;
    end
  end
  Tout.ctypesum.inhibitory = inhibitory;	 %clean inhibitory;
  Tout.ctypesum.excitatory = excitatory;	 %clean excitatory;
  Tout.ctypesum.hybrid     =     hybrid;	 %clean hybrid;
  Tout.ctypesum.zeroConnection = zeroConnection; % clean zeroConnection;
  %% ==</ get neuron type >==

  if ( Tout.ctypesum.hybrid > 0 )
    warning('some neuron is hybrid.')
  end
  %% ==< generate alpha>==
  %% --< init >--
  tmp_alpha_weight = zeros(1,hnum);
  for i1 = 1:hnum
    %++improve: generate characteristic of neuron.
    tmp_alpha_weight(i1) = cos( i1/hnum )*exp(-(i1-1)/hnum*3);
  end
  i3 = 0;
  %% --</init >--
  for i1 = 1:cnum %%++parallel
    for i2 = 1:cnum
      i3 = i3 + 1;
      flag = alpha_hash(i3);
      ptr = (i2-1)*hnum;

      if i1 == i2
        alpha(ptr+1:ptr+hnum,i1) = flag*(tmp_alpha_weight);
      else
        switch ( flag ) 
          case +1
            alpha(ptr+1:ptr+hnum,i1) = flag*(tmp_alpha_weight);
          case -1                 
            alpha(ptr+1:ptr+hnum,i1) = flag*(tmp_alpha_weight);
          case 0                  
            alpha(ptr+1:ptr+hnum,i1) = zeros(1,hnum);
        end
      end
    end
  end
  clear ptr flag tmp_alpha_weight;
  %% ==</ generate alpha>==

  %%% ===== prepare True Values ===== START ===== 
elseif strcmp('prepareTrueValues','prepareTrueValues')
  spar    = env.spar   ;
  ctype = 2*(randn(1,cnum)>0) - 1; 
  ctype_hash = ctype;
  Tout.ctypesum.inhibitory = length(find(ctype == -1)); % number of inhibitory neurons.
  Tout.ctypesum.excitatory = length(find(ctype == +1)); % number of excitatory neurons.

  alpha_hash = zeros(cnum,cnum);
  alpha_hash(spar.from,spar.to) = 1; % connection 'true'.
  alpha_hash(logical(eye(cnum))) = 1; % diagonal element: connection 'true'.

  iniPhase = rand([cnum cnum])/2;
  %% ctype: ctype of neuron. 0 == excitatory, -1 == inhibitory
  ctype = repmat(ctype*(pi/2),cnum,1);
  ctype(logical(eye(cnum))) = -pi;  % All neuron must have self-depression.

  for i1 = 1:cnum
    error('temporary this functionality is disabled');
    %   alpha=;
  end
  nIt = zeros([],cnum,hnum);
  Tout.ctype = sprintf('%4d',ctype_hash);
  clear ctype ctype_hash
end

%% I: zeros(hnum*hwind,cnum), initial time series of firing.
I = zeros(hnum*hwind+genLoop,cnum); % mallloc

%%% ===== SET AUTO FIRING RATE ===== START =====                                          
fprintf(1,'Total history width %f[sec]\n',hnum*hwind/Hz.video);

%% alpha0: (1,cnum) matrix. correspond to auto firing of each cell.
if 1
  alpha0 = repmat(SELF_DEPRESS_BASE,[1 cnum]);
elseif   strcmp('gen_individuality','gen_individuality')
  %++bug: Hz.neuro <-> SELF_DEPRESS_BASE
  Hz.fn = Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  alpha0 = Hz.fn*(1 + rand(1,cnum) ); % alpha0: self firing-depress weight.
else
  Hz.fn = Hz.neuro/Hz.video; % Hz of firing per frame: [rate/frame]
  alpha0 = repmat(Hz.fn,1,cnum);
end
%%% ===== PLOT alpha ===== START =====
if ( 1 == graph.PLOT_T )
  %% ++bug: func plot_alpha must be given 'env'.
  plot_alpha(graph,env,alpha0,alpha,'\alpha: Spatio-temporal Kernels');
end
if graph.SAVE_EPS == 1
  print('-depsc','-tiff',[rootdir_ '/outdir/true_alpha.eps'])
end

%%% ===== SET AUTO FIRING RATE ===== END =====            
Tout.simtime = genLoop/Hz.video;
fprintf(1,'Time of simulation %f[sec]\n',Tout.simtime);
Tout.simtime = sprintf('%f[sec]',Tout.simtime);
%% lambda: (genLoop,cnum) matrix. Firing rate per frame. [rate/frame]
lambda    = zeros(genLoop,env.cnum);
loglambda = zeros(genLoop,env.cnum);

if ( status.READ_NEURO_CONNECTION == 1 )
  nIs = zeros(hnum,cnum); % nIs: number of I stack.
  tmp0.showProg=floor(genLoop/10);
  tmp0.count = 0;
  fprintf('\tprogress(%%): ');
  for i1 = 1:genLoop
    if ~mod(i1,tmp0.showProg) %% show progress.
      fprintf('%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    Tptr = 0; %Tptr: Tail Pointer
    %% ( genLoop -1 [frame] ) * dt [time/frame] == T [time]
    %%%% ===== renew number of spikes fired by cell c at lag m ===== 
    %%%% ===== START =====
    for i2 =1:hnum
      nIs(i2,:) = sum(I( (i1-1+Tptr+1):(i1-1+Tptr+hwind),: ),1);
      Tptr = Tptr+hwind;
    end
    %%%% ===== renew number of spikes fired by cell c at lag m ===== 
    %%%% ===== END =====
    tmp1 = alpha0 + sum( alpha.*repmat(reshape(nIs,[],1), [1 cnum]) ,1);
    %% I don't know dot() is more faster than sum().
    loglambda(i1,:) = tmp1;
    tmp2_lambda = exp( tmp1 ); 
    lambda(i1,:) = tmp2_lambda;
    %{
    %% old
    tmp3 = exp(-tmp2_lambda/Hz.video).*(tmp2_lambda/Hz.video); 
    tmp3 = rand(1,cnum) < tmp3;
    %}
    tmp3 = exp(-tmp2_lambda/Hz.video);
    tmp3 = rand(1,cnum) > tmp3;

    I(hnum*hwind+ i1,:) = tmp3;
  end
  fprintf('\n');
else

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
    tmp2_lambda = exp( tmp1 ); 
    lambda = [ lambda; tmp2_lambda ]; % store time series of lambda
                                      %    rand('seed',randIndex);
                                      %    randIndex = randIndex +1;
    %% poisson process. 
    %%    tmp3 = poissrnd(tmp2_lambda,1,cnum);

    %{
    %% old
    tmp3 = exp(-tmp2_lambda/Hz.video).*(tmp2_lambda/Hz.video); 
    tmp3 = rand(1,cnum) < tmp3;
    %}
    tmp3 = exp(-tmp2_lambda/Hz.video)/Hz.video;
    tmp3 = rand(1,cnum) < tmp3;
    I = [I;tmp3];
  end
end
Tout.I = sprintf('%6d',sum(I,1));
I = logical(sparse(I)); %<->full(), logical()
%%% ===== PLOT LAMBDA ===== START =====
if 1 == graph.PLOT_T
  plot_lambda(graph,env,lambda,'\lambda: Firing Rates [per frame]');
  %%% ===== PLOT LAMBDA ===== END =====
  %% write out eps file
  if graph.SAVE_EPS == 1
    print('-depsc','-tiff',[rootdir_ '/outdir/artificial_lambda.eps'])
  end
end
%%% ===== PLOT LAMBDA ===== END =====

%%% ===== PLOT I(t) ===== START =====
if 1 == graph.PLOT_T
  plot_I(graph,env,I,'I(t): Spikes [per frame]')
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
%% ==</ clean variables >==
