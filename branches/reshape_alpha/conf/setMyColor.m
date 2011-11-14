function myColor = setMyColor(useFrameLen)
%% color allocated for each elemenths from env.useFrame
%% colorB={'b','g','r','c','m','k'};

colorB={[0 0 1],[0 1 0],[1 0 0],[0 1 1],[1 0 1],[0 0 0]};
colorLen = size(colorB,2);
TERM = ceil(useFrameLen / colorLen);
myColor= cell(1,colorLen*TERM);
for j1 = 1:TERM
  for j2 = 1:colorLen
    myColor{(j1-1)*colorLen+j2} = (colorB{j2}*j1 + .2*rand(1,1))/TERM;
  end
end
norm = cell2mat(myColor);
while sum(( norm > 1 ))
  norm( norm >1) =   norm( norm >1) - 1;
end
myColor= mat2cell(norm,1,repmat(3,[1 colorLen*TERM]));
