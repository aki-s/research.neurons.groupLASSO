function [ResFunc] = kernel00(ResFunc_hash,env)

global graph;
cnum = env.cnum;
hnum = env.hnum;


% $$$ weight_kernel = zeros(1,hnum);
% $$$ for i1 = 1:hnum
% $$$   %++improve: generate characteristic of neuron.
% $$$   weight_kernel(i1) = cos( (i1/hnum)*(pi/2) )*exp(-(i1-1)/hnum*3);
% $$$ end

if 1 == 1
  N = 100;
else
  N = 10;
end
GAIN_SELF = 1;

W=(1:hnum)/hnum;
weight_kernel = GAIN_SELF * cos( (W)*(pi/2) ).*exp(-(W)*3);
%weight_kernel = cos(exp(-(W)*3).^2);

ABS = max(weight_kernel);
graph.prm.Yrange = 1.5 * [ -ABS, ABS ];

switch 3
  case 0
    W = zeros(1,bases.ihbasprs.nbase);
    W(1) = 5;
    weight_kernel_1 = gen_kernel0(bases,W); % good
  case 1
    weight_kernel_1 = gen_kernel1(hnum); % no good
  case 2
    weight_kernel_1 = N*loren(0.1,0,hnum); % not so good
  case 3              
    weight_kernel_1 = N*chi2pdf(1,1:hnum);
end

ABS = max(weight_kernel_1);
graph.prm.diag_Yrange = 1 * [ -ABS, ABS ];

ResFunc = zeros(cnum*hnum,cnum);
i3 =0;
for i1 = 1:cnum %%++parallel
  for i2 = 1:cnum
    i3 = i3 + 1;
    flag = ResFunc_hash(i3); %flag: +/0/-, exitatory/0/inhibitory
    ptr = (i2-1)*hnum; %ptr: pointer

    if i1 == i2 
      ResFunc(ptr+1:ptr+hnum,i1) = flag*(weight_kernel_1);
    else
      switch ( flag ) 
        case +1
          ResFunc(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
        case -1                 
          ResFunc(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
        case 0                  
          ResFunc(ptr+1:ptr+hnum,i1) = zeros(1,hnum);
      end
    end
  end
end

