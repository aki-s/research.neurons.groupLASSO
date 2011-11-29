function myColor = setMyColor(useFrameLen)
%% color allocated for each elemenths from env.useFrame
% myColor = setMyColor(length(env.useFrame))
%%
METHOD = 'tight';
%% avoid yellow
%% colorBase={'b','g','r','c','m','k'};
colorBase={[0 0 1],[0 1 0],[1 0 0],[0 1 1],[1 0 1],[0 0 0]};
colorBaseLen = size(colorBase,2);

switch METHOD
  case 'normalized_extra'
    TERM = ceil(useFrameLen / colorBaseLen);
    LENGTH = colorBaseLen*TERM;
    myColor = cell(1,LENGTH);
    for j1 = 1:TERM
      for j2 = 1:colorBaseLen
        myColor{(j1-1)*colorBaseLen+j2} = (colorBase{j2}*j1 + .2*rand(1,1))/TERM;
      end
    end
  case 'tight'
    myColor = cell(1,useFrameLen);
    LENGTH = useFrameLen;
    for j1 = 0:(useFrameLen-1)
      myColor{j1+1} = colorBase{mod(j1,colorBaseLen)+1}*.5 + .2*rand(1,3);
    end
end

norm = cell2mat(myColor);
while sum(( norm > 1 ))
  norm( norm >1) =   norm( norm >1) - 1;
end
myColor = mat2cell(norm,1,repmat(3,[1 LENGTH]));

%{
color = zeros(useFrameLen,3);
for j1 = 1:useFrameLen
  color(j1,:) = rand(1,3);
  %% avoid yellow
  while ( color(j1,1) > .6 ) && ( color(j1,2) > .6 )
    color(j1,:) = rand(1,3);
  end
end
%}
