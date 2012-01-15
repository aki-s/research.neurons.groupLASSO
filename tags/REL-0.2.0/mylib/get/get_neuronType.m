function [OenvSummary] = get_neuronType(env,status,ResFunc_fig,envSummary)

OenvSummary = envSummary;

%% ==< get neuron type >==
tmp_ResFunc_fig = ResFunc_fig;
%% ignore property of diagonal elements.
tmp_ResFunc_fig( logical( eye( env.cnum))) = 0;

inhibitory = 0; % number of inhibitory neurons.
excitatory = 0; % number of excitatory neurons
hybrid =     0; % number of hybrid (excitatory,inhibitory) neurons
zeroConnection =     0; % number of zero connection neurons
%%  OenvSummary.ctype = false(1,env.cnum);
OenvSummary.ctype = zeros(1,env.cnum);
for i1 = 1:env.cnum %++parallel
  notI = isempty(find(tmp_ResFunc_fig(:,i1)<0));
  notE = isempty(find(tmp_ResFunc_fig(:,i1)>0));
  logicZ = notI & notE ;
  switch( logicZ )
    case 0
      if ( notI || notE )
        excitatory = excitatory +notI; % number of excitatory neurons
        inhibitory = inhibitory +notE; % number of inhibitory neurons.

        OenvSummary.ctype(1,i1) = +1 * notI -1 * notE; % excitatory/inhibitory
      else
        hybrid     = hybrid     + 1; % number of excitatory neurons.                                       
        OenvSummary.ctype(1,i1) = Inf; % hybrid
      end
    case 1
      zeroConnection = zeroConnection +1;
      OenvSummary.ctype(1,i1) = NaN; % hybrid
  end
end

OenvSummary.ctypesum.inhibitory = inhibitory;	 %clean inhibitory;
OenvSummary.ctypesum.excitatory = excitatory;	 %clean excitatory;
OenvSummary.ctypesum.hybrid     =     hybrid;	 %clean hybrid;
OenvSummary.ctypesum.zeroConnection = zeroConnection; % clean zeroConnection;

%  clear inhibitory excitatory hybrid zeroConnection;
%% ==</ get neuron type >==
%end
