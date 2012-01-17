function range = set_frameRange(N_in,N_default,FROM,varargin)

nargin_NUM = 3;
if nargin >= nargin_NUM +1
  TO = varargin{1};
end

if N_in > N_default % only one frame
  range.from = FROM;
  range.to = range.from;
else % mix ALL
  range.from = 1;
  range.to = TO;
end

