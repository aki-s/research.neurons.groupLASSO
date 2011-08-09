function [I,lambda,loglambda] = gen_TrueI(env,alpha0,alpha)
%function [I,lambda,loglambda] = gen_TrueI(env,alpha0,alpha)


global Tout;
global status;

%% ==< set local variables >==
if strcmp('setlocal_var','setlocal_var')
  Hz      = env.Hz     ;      
  hwind   = env.hwind  ;   
  genLoop = env.genLoop; 
  cnum    = env.cnum   ;    
  hnum    = env.hnum   ;    
  SELF_DEPRESS_BASE = env.SELF_DEPRESS_BASE;
end
histSize = hnum*hwind;
%% ==</ set local variables >==

%I = zeros(histSize+genLoop,cnum); % mallloc
I = false(histSize+genLoop,cnum); % mallloc logical var.

%% lambda: (genLoop,cnum) matrix. Firing rate per frame. [rate/frame]
lambda    = zeros(histSize+ genLoop,env.cnum); % mallloc
loglambda = zeros(histSize+ genLoop,env.cnum); % mallloc

if strcmp('genLoop','genLoop')
  nIs = zeros(hnum,cnum); % nIs: number of I stack.
  tmp0.showProg = floor(genLoop/10);
  tmp0.count = 0;
  fprintf('generating time serise of firing:\tprogress(%%): ');
  %  for i1 = 1:genLoop
  for i1 = (histSize+ 1):(histSize)+ genLoop
    if ~mod(i1- histSize,tmp0.showProg) %% show progress.
      fprintf('%d ',tmp0.count*10)
      tmp0.count = tmp0.count +1;
    end
    Tptr = 0; %Tptr: Tail Pointer
    if strcmp('bug','bug_')
      %% ( genLoop -1 [frame] ) * dt [time/frame] == T [time]
      %%%% ===== renew number of spikes fired by cell c at lag m ===== 
      %%%% ===== START =====
      for i2 =1:hnum
        % most old I is at the first of index
        nIs(i2,:) = sum(I( (i1-1+Tptr+1):(i1-1+Tptr+hwind),:),1);
        Tptr = Tptr+hwind;
      end
    end
    % most old I is at the last of index
    if hwind == 1
      nIs = I(i1 - (1:hnum), 1:cnum);
    else % hwind > 1 : This condition cause calculation too slow.
      for i2 = 1:hnum
        nIs(i2,:) = sum( I( (i1-1-Tptr):(i1-hwind-Tptr),: ),1);
        Tptr = Tptr +hwind;
      end
    end
    %%%% ===== renew number of spikes fired by cell c at lag m ===== 
    %%%% ===== END =====
    loglambda(i1,:) = alpha0 + sum( alpha.*repmat(reshape(nIs,[],1), [1 cnum]) ,1);
    if strcmp('may_bug','may_bug_')
    %% old: This may be correct non stable poisson process.
    tmp3 = exp(-exp(loglambda(i1,:))/Hz.video).*(exp(loglambda(i1,:))/Hz.video); 
    tmp3 = rand(1,cnum) < tmp3;
    end

    tmp3 = exp(-exp(loglambda(i1,:))/Hz.video);
    tmp3 = rand(1,cnum) > tmp3;

    %    I(histSize+ i1,:) = tmp3;
    I(i1,:) = tmp3;
  end
  fprintf('\n');
  clear Tptr nIs;
end

lambda = exp(loglambda);

%Tout.I = sprintf('%8d',sum(I,1));
%Tout.I = int64(sum(I,1)); %++bug: forced to be int.
Tout.I = (sum(I,1));

%I = logical(sparse(I)); %<->full(), logical()


