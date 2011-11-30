function [ihbas, ihbasis, Oihbasprs] = make_basis1(ihbasprs,dt,D2)

%%tail(log(max(1:x))/(pi/2) ) == nbase
Hz = 1/dt;
numFrame = ihbasprs.numFrame;
hpeaks   = ihbasprs.hpeaks;

if isfield(ihbasprs, 'absref');
  absref = ihbasprs.absref;
else
  absref = 0;
end

if dt> absref > 0
  warning('DEBUG:NOTICE',['Refractory period too small for time-bin sizes.\n Basis you set ' ...
                      'is reduced by 1'])
end

% nonlinearity for stretching x axis (and its inverse)

nlin = @(x)log(x);
invnl = @(x)exp(x); % inverse nonlinearity

% Generate basis of raised cosines
lagF = ceil(hpeaks*Hz);% scale unit from [sec] to [frame].
%%lagF = (lagF-1)*D2 +1;
D1=ihbasprs.xscale;
%% correspond hpeaks(2) to nbase
%nbase = ceil(D1*nlin(lagF(end)))
%nbase = ceil(2+2*D1*nlin(1+(lagF(end)-1)*D2))
%x2b = @(x)(2+2*D1*nlin(1+(x-1)*D2));
nbase = floor(2+2*D1*nlin(1+(lagF(end)-1)*D2));
%nbase = round(2+2*D1*nlin(1+(lagF(end)-1)*D2))
D1 = (nbase-2)/(2*nlin(1+D2*(lagF(end))));
nbase_1 = nbase - 1;

redge = (invnl( (2:(nbase))/(2*D1) ) -1)/D2 +1;

ctrs  = (0:nbase_1)-1;
%% check right margin
RDEL = 0;
if redge(end) > numFrame 
  warningMargin()
  RDEL = sum(redge>numFrame);
  nbase = nbase - RDEL;
  redge = redge(1:(end-RDEL));
  ctrs = ctrs(1:(end-RDEL));
end
%% check left margin
LDEL = 0;
if redge(1) < 0
  warningMargin()
  LDEL = sum(redge<0);
  nbase = nbase - LDEL;
  %  redge = redge((LDEL+1):end);
  ctrs = ctrs((LDEL+1):end);
end
%redge
%ctrs
numFrame=floor(redge(end));% cut off zeros
%nbase
xint = (0:(numFrame-1))'*D2 +1;

%% cos( -pi<=,<=pi ) , normalize by deviding (x-c) with dc*2
ff = @(x,c,scl)(cos(max(-pi,min(pi,(scl*nlin(x) - c/2 )*pi)))+1)/2;
ihbasis = ff(repmat(xint, 1, nbase), repmat(ctrs,numFrame,1), D1);

%% If absolute refractory period is efficient
%% create first basis vector as step-function for absolute refractory period.
if absref >= dt
  ii = find(numFrame <= absref);
  ih0 = zeros(size(ihbasis,1),1);
  ih0(ii) = 1;
  ihbasis(ii,:) = 0;
  ihbasis(ii,1) = 1;
  ihbasis = [ih0,ihbasis(:,1:nbase-1)]; 
end

ihbas = orth(ihbasis);  % use orthogonalized basis


Oihbasprs.numFrame = numFrame;
Oihbasprs.D1 = D1;
Oihbasprs.nbase = nbase;


function warningMargin()
  warning('DEBUG:NOTICE',...
          sprintf('%s',[...
              'make bases.ihbasprs.xscale smaller, or\n'...
              'make bases.ihbasprs.numFrame larger'...
                   ]))
