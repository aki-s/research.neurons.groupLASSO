function  [CVL CVLs]  = init_CVL(useNeuroLen,veccnum,useFrameLen,regFacLen)
%%
%% CVL: 
%% CVLs: CVL summary
%%
CVL                   = cell(1,useNeuroLen);
CVLs                  = cell(1,useNeuroLen);

for i1                = 1:useNeuroLen
    CVL{i1}           = nan(regFacLen,veccnum(i1),useFrameLen);
    CVLs{i1}.minTotal = nan(useFrameLen,1);
    CVLs{i1}.idxTotal = nan(useFrameLen,1);
    CVLs{i1}.minEach  = nan(useFrameLen,veccnum(i1));
    CVLs{i1}.idxEach  = nan(useFrameLen,veccnum(i1));
end
