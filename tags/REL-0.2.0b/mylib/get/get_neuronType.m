function [OTout] = get_neuronType(env,status,ResFunc_fig,Tout)

OTout = Tout;

%% ==< get neuron type >==
tmp_ResFunc_fig = ResFunc_fig;
%% ignore property of diagonal elements.
tmp_ResFunc_fig( logical( eye( env.cnum))) = 0;

inhibitory = 0; % number of inhibitory neurons.
excitatory = 0; % number of excitatory neurons
hybrid =     0; % number of hybrid (excitatory,inhibitory) neurons
zeroConnection =     0; % number of zero connection neurons
%%  OTout.ctype = false(1,env.cnum);
OTout.ctype = zeros(1,env.cnum);
for i1 = 1:env.cnum %++parallel
  notI = isempty(find(tmp_ResFunc_fig(:,i1)<0));
  notE = isempty(find(tmp_ResFunc_fig(:,i1)>0));
  logicZ = notI & notE ;
  switch( logicZ )
    case 0
      if ( notI || notE )
        excitatory = excitatory +notI; % number of excitatory neurons
        inhibitory = inhibitory +notE; % number of inhibitory neurons.

        OTout.ctype(1,i1) = +1 * notI -1 * notE; % excitatory/inhibitory
      else
        hybrid     = hybrid     + 1; % number of excitatory neurons.                                       
        OTout.ctype(1,i1) = Inf; % hybrid
      end
    case 1
      zeroConnection = zeroConnection +1;
      OTout.ctype(1,i1) = NaN; % hybrid
  end
end

OTout.ctypesum.inhibitory = inhibitory;	 %clean inhibitory;
OTout.ctypesum.excitatory = excitatory;	 %clean excitatory;
OTout.ctypesum.hybrid     =     hybrid;	 %clean hybrid;
OTout.ctypesum.zeroConnection = zeroConnection; % clean zeroConnection;

%  clear inhibitory excitatory hybrid zeroConnection;
%% ==</ get neuron type >==
%end
