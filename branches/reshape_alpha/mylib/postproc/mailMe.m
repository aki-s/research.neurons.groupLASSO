function mailMe(env,status,DAL,bases,title)
%% 
%function mailMe(env,status,DAL,bases,'mail title')
%% 
if ~isfield(status,'inFiring')
  status.inFiring ='';
end
if ~isfield(status,'outputfilename')
  status.outputfilename ='User saved at their liking, or no output.';
end
if ~( isfield(env,'Hz') && isfield(env.Hz,'video') )
  env.Hz.video ='';
end
if ~isfield(status.time,'estimate_TrueKernel')
  status.time.estimate_TrueKernel ='Not estimated.';
end
useFrameLen = length(env.useFrame);
FRAME = '[ ';
for i1 =1:useFrameLen
  FRAME = strcat(FRAME,num2str(env.useFrame(i1)));
  FRAME = strcat(FRAME,', ');
end
FRAME = strcat(FRAME,' ]');

%%
if status.mail == 1
  setpref('Internet','SMTPServer',env.mail.smtp);
  Tcost = tidyElapsedTime(env,status,useFrameLen);
  if 1 == 1
    sendmail( env.mail.to, title, ...
              { 
                  ['program started   : ', mydate(status.time.start)],...
                  ['program ended     : ', mydate(status.time.end)],...
                  ['time elapsed [sec]: ', num2str(etime(status.time.end,status.time.start))],...
                  ['env.inFiringUSE: ',  num2str(env.inFiringUSE)], ...
                  ['Hz.video: ',  num2str(env.Hz.video)], ...
                  ['Used frame [ratio]   : ',FRAME ,' out of ', num2str(env.genLoop)],...
                  ['regularization factor[regFac]:',sprintf('%3.3f ',DAL.regFac)],...
                  ['bases: ', bases.ihbasprs.basisType],...
                  repmat('-',[1 100]),...
                  ['in_nueroStructFile: ', status.inStructFile],...
                  ['in_Firing: ', status.inFiring],...
                  ['method: ', status.method],...
                  [''],...
                  [''],...
                  ['savedirname: ', status.savedirname],...
                  ['All_Variable_outfile: ', status.outputfilename],...
                  [''],...
                  repmat('-',[1 100]),...
                  ['[usedFrame\regFac|]',sprintf('%3.3f ',DAL.regFac)],...
                  Tcost...
              },status.userDef);
    %% attach 'conf_user_*'
  else % debug
    sendmail( env.mail.to, title, ...
              { ['program started   : ', mydate(status.time.start)],...
                'text1','text2'...
                Tcost...
              });
  end
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

function [ ret ] = tidyElapsedTime(env,status,useFrameLen)
ret = '';
N_SIZE=5;
MEMO='neuron used:';
%for i1 = 1:env.useNeuroLen
a = env.useFrame;
[d1 d2] = size(a);
if d1 == 1
  a = a';
elseif d2 == 1
  % o.k.
end
b = nan(useFrameLen, 1);
c = status.time.regFac;

tmp = [ a b c ];

for i2 = 1:useFrameLen
  ret = strcat(ret,'[');
  ret = strcat(ret,sprintf('%7.1f',tmp(i2,:)));
  ret = strcat(ret,'],');
end
tmp1 = sprintf('%s%s#%5d',repmat('.',[1 floor(size(ret,2)/2)-1-N_SIZE-length(MEMO)]),MEMO,env.inFiringUSE(end));%++future:index
ret = sprintf('%s\n%s',tmp1,ret);
%end
ret = regexprep(num2str(ret),'NaN','\t|');
ret = regexprep(ret,',','\n');

