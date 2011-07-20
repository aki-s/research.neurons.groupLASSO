%% calculating with DAL takes some time.
%% So I prepared the method to notify you via mail
%%  when this calculation finished.

if isfield(env,'mail')
  status.mail = 1; % 1: notify with mail when program ended.
else
  status.mail = 0;
end
%if ~exist('env')
if exist('env') && ~isfield(env ,'mail')
  %% Set YOUR_MAIL_ADDRESS your mail address to which
  %% finish of program is notified 
  env.mail.to='YOUR_MAIL_ADDRESS';
  if ~isfield(env.mail,'smpt')
    %% Set your 'YOUR_SMTP_SERVER'
    env.mail.smtp='YOUR_SMTP_SERVER';
  end
end
