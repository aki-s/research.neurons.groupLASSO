function  get_neuronType(env,status,alpha_fig);
%function [Tout] = get_neuronType(env,status,alpha_fig);

%if ( status.READ_NEURO_CONNECTION == 1 )
if 1 == 1
  global Tout;
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
  %  clear logicP logicN logicZ ;

  Tout.ctypesum.inhibitory = inhibitory;	 %clean inhibitory;
  Tout.ctypesum.excitatory = excitatory;	 %clean excitatory;
  Tout.ctypesum.hybrid     =     hybrid;	 %clean hybrid;
  Tout.ctypesum.zeroConnection = zeroConnection; % clean zeroConnection;

  %  clear inhibitory excitatory hybrid zeroConnection;
  %% ==</ get neuron type >==
end