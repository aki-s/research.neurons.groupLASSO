clear ans
%% ==< clear const variables >==
%% clear rootdir_ % don't clean variable having suffic '_'.

%% ==< clear tmp files >==
clear -regexp ^tmp([0-9_]*)
clear -regexp ^i([0-9]*)

clear   tenv   tgraph  tstatus 
