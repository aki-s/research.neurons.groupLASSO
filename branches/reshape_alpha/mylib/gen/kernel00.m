function [alpha] = kernel00(alpha_hash,env)

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
W=(1:hnum)/hnum;
weight_kernel = 0.5 * cos( (W)*(pi/2) ).*exp(-(W)*3);
%weight_kernel = cos(exp(-(W)*3).^2);

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

i3 =0;
for i1 = 1:cnum %%++parallel
  for i2 = 1:cnum
    i3 = i3 + 1;
    flag = alpha_hash(i3); %flag: +/0/-, exitatory/0/inhibitory
    ptr = (i2-1)*hnum; %ptr: pointer

    if i1 == i2 
      alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel_1);
    else
      switch ( flag ) 
        case +1
          alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
        case -1                 
          alpha(ptr+1:ptr+hnum,i1) = flag*(weight_kernel);
        case 0                  
          alpha(ptr+1:ptr+hnum,i1) = zeros(1,hnum);
      end
    end
  end
end

