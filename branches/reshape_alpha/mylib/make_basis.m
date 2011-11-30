function [ihbas, ihbasis] = make_basis(ihbasprs,dt)
% [ihbas, ihbasis] = make_basis(ihbasprs,dt,numFrame);

%numFrame = ihbasprs.numFrame;
%%tail(log(max(1:x))/(pi/2) ) == nbase
nbase = ihbasprs.nbase;
nStrength = ihbasprs.b;
hpeaks = ihbasprs.hpeaks;
if isfield(ihbasprs, 'absref');
    absref = ihbasprs.absref;
else
    absref = 0;
end

% Check input values
if (hpeaks(1)+nStrength) < 0, % Because [hpeaks + nStrength] is args of nlin().
    error('nStrength + first peak location: must be greater than 0'); 
end
if dt> absref > 0
    warning('DEBUG:NOTICE',['Refractory period too small for time-bin sizes.\n Basis you set ' ...
             'is reduced by 1'])
end

% nonlinearity for stretching x axis (and its inverse)
if 1 == 1
nlin = @(x)log(x+1e-20);
invnl = @(x)exp(x)-1e-20; % inverse nonlinearity
else
nlin = @(x)(x+1e-20);
invnl = @(x)(x)-1e-20; % inverse nonlinearity
end
% Generate basis of raised cosines
yrnge = nlin(hpeaks+nStrength);  
db = diff(yrnge)/(nbase-1); % spacing between raised cosine peaks
%%ctrs = yrnge(1)-db:db:yrnge(2);   % centers for basis vectors
ctrs = yrnge(1):db:yrnge(2);   % centers for basis vectors
mxt = invnl(yrnge(2)+2*db)-nStrength;  % maximum time bin
numFrame = [dt:dt:mxt]';
nt = length(numFrame);        % number of points in numFrame
%% cos( -pi<=,<=pi ) , normalize by deviding (x-c) with dc*2
ff = @(x,c,dc)(cos(max(-pi,min(pi,(x-c)*pi/dc/2)))+1)/2; % raised cosine basis vector
ihbasis = ff(repmat(nlin(numFrame+nStrength), 1, nbase), repmat(ctrs, nt, 1), db);

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
