function echo_stdoutDivider(freq,varargin)
%% if ~empty(varargin{1}), don't fprintf('\n')

BLOCK = 30;
fprintf('%s',repmat('=',[1 BLOCK*freq]));
if nargin == 1
  fprintf('\n');
else

end
