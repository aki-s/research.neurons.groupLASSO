function mailMe(env,status,DAL,bases,title)
%% 
%function mailMe(env,status,DAL,'mail title')
%% 
if isfield(status,'inFiring')
  ;
else
  status.inFiring ='';
end

%%
if status.mail == 1
  setpref('Internet','SMTPServer',env.mail.smtp);
  sendmail( env.mail.to, title, ...
            ['program started   : ', mydate(status.time.start), 10,...
             'program ended     : ', mydate(status.time.end), 10, ...
             'time elapsed [sec]: ', num2str(etime(status.time.end,status.time.start)),10,...
             10,...
             'Used frame [ratio]   : ', num2str(DAL.Drow),'/', num2str(env.genLoop), 10,...
             'regularization factor:',num2str(DAL.regFac), 10,...
             'bases: ', bases.type, 10,...
             'time elapsed to estimae Kernel [sec]: ', num2str(status.time.estimate_TrueKernel), 10,...
             10,...
             'in_file: ', status.inStructFile, 10,...
             'in_Firing: ', status.inFiring, 10,...
             'outfile: ', status.outputfilename, 10,...
             10] );
end

function [time_] = mydate( out_clock )
time_=[];
for i1 = 1:3
  time_ = strcat(time_, num2str(out_clock(i1),'%02d') );
  time_ = strcat(time_, '-');
end
for i1 = 4:6
  time_ = strcat(time_, num2str(out_clock(i1),'%02d') );
  time_ = strcat(time_, ':');
end