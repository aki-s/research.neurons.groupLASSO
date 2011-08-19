function [iht, ihbas, ihbasis] = make_basis(ihbasprs,dt);
% [iht, ihbas, ihbasis] = make_basis(ihbasprs,dt,iht);

nbase = ihbasprs.nbase;
b = ihbasprs.b;
hpeaks = ihbasprs.hpeaks;
if isfield(ihbasprs, 'absref');
    absref = ihbasprs.absref;
else
    absref = 0;
end

% Check input values
if (hpeaks(1)+b) < 0, % Because [hpeaks + b] is args of nlin().
    error('b + first peak location: must be greater than 0'); 
end
if dt> absref > 0
    warning(['Refractory period too small for time-bin sizes.\n Basis you set ' ...
             'is reduced by 1'])
end

% nonlinearity for stretching x axis (and its inverse)
nlin = @(x)log(x+1e-20);
invnl = @(x)exp(x)-1e-20; % inverse nonlinearity

% Generate basis of raised cosines
yrnge = nlin(hpeaks+b);  
%db = diff(yrnge)/(nbase-1);    % spacing between raised cosine peaks
db = diff(yrnge)/(nbase-1); 
%%ctrs = yrnge(1)-db:db:yrnge(2);   % centers for basis vectors
ctrs = yrnge(1):db:yrnge(2);   % centers for basis vectors
mxt = invnl(yrnge(2)+2*db)-b;  % maximum time bin
iht = [dt:dt:mxt]';
nt = length(iht);        % number of points in iht
%% cos( -pi<=,<=pi ) , normalize by deviding (x-c) with dc*2
ff = @(x,c,dc)(cos(max(-pi,min(pi,(x-c)*pi/dc/2)))+1)/2; % raised cosine basis vector
ihbasis = ff(repmat(nlin(iht+b), 1, nbase), repmat(ctrs, nt, 1), db);

%% If absolute refractory period is efficient
%% create first basis vector as step-function for absolute refractory period.
if absref >= dt
  ii = find(iht <= absref);
    ih0 = zeros(size(ihbasis,1),1);
    ih0(ii) = 1;
    ihbasis(ii,:) = 0;
    ihbasis(ii,1) = 1;
    ihbasis = [ih0,ihbasis(:,1:nbase-1)]; 
end

ihbas = orth(ihbasis);  % use orthogonalized basis
