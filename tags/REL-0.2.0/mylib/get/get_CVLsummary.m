function [CVLs] = get_CVLsummary(CVL,useFrameLen,cnum)
for i1 =1:useFrameLen
  %% get minimum from overall log likelihood of
  %% crossValidation with different regFac at each used frame.
  [CVLs.minTotal(i1),CVLs.idxTotal(i1)]    = min(sum(CVL(:,:,i1),2),[],1);
  %% corresponding regularization factor: DAL.regFac(CVLs.idxTotal)
  [CVLs.minEach(i1,1:cnum),CVLs.idxEach(i1,1:cnum)] = min(CVL(:,:,i1),[],1); % each neuron
end

