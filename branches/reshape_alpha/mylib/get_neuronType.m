function  get_neuronType(env,status,alpha_fig)
%function [Tout] = get_neuronType(env,status,alpha_fig);

%if ( status.READ_NEURO_CONNECTION == 1 )
if 1 == 1
  global Tout;
  %% ==< get neuron type >==
  tmp_alpha_fig = alpha_fig;
  %% ignore property of diagonal elements.
  tmp_alpha_fig( logical( eye( env.cnum))) = 0;

  inhibitory = 0; % number of inhibitory neurons.
  excitatory = 0; % number of excitatory neurons
  hybrid =     0; % number of hybrid (excitatory,inhibitory) neurons
  zeroConnection =     0; % number of zero connection neurons
  %%  Tout.ctype = false(1,env.cnum);
  Tout.ctype = zeros(1,env.cnum);
  for i1 = 1:env.cnum %++parallel
    notI = isempty(find(tmp_alpha_fig(:,i1)<0));
    notE = isempty(find(tmp_alpha_fig(:,i1)>0));
    logicZ = notI & notE ;
    switch( logicZ )
      case 0
        if ( notI || notE )
          excitatory = excitatory +notI; % number of excitatory neurons
          inhibitory = inhibitory +notE; % number of inhibitory neurons.

          Tout.ctype(1,i1) = +1 * notI -1 * notE; % excitatory/inhibitory
        else
          hybrid     = hybrid     + 1; % number of excitatory neurons.                                       
          Tout.ctype(1,i1) = Inf; % hybrid
        end
      case 1
        zeroConnection = zeroConnection +1;
        Tout.ctype(1,i1) = NaN; % hybrid
    end
  end

  Tout.ctypesum.inhibitory = inhibitory;	 %clean inhibitory;
  Tout.ctypesum.excitatory = excitatory;	 %clean excitatory;
  Tout.ctypesum.hybrid     =     hybrid;	 %clean hybrid;
  Tout.ctypesum.zeroConnection = zeroConnection; % clean zeroConnection;

  %  clear inhibitory excitatory hybrid zeroConnection;
  %% ==</ get neuron type >==
end