%%++improve
%% bases should be loaded from a mat file.
%% large argment of set_BasisStruct_glm() make small width of basis.
bases = set_BasisStruct_glm(bases,1/env.Hz.video); % Create GLM structure with default params
