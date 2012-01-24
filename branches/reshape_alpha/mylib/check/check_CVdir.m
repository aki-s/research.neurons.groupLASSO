function [inRoot listLS] = check_CVdir(inRoot,list)
if isempty(list)
  %  error('screened list is empty')
  fprintf('supposed status.crossVal_rough==1\n')
  inRoot = strcat(inRoot,'/CV/');
  listLS = ls([in,'*.mat']); % default list
end

