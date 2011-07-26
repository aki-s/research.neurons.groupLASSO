function [kernel] = gen_kernel1(hnum);

DEBUG = 1;
if DEBUG == 1
  hold on
end

%++improve: generate characteristic of neuron.

%  kernel(i1) = sin( ((i1-1)/hnum)*(pi/2) )*exp((-(i1-1)/hnum)*1);
%  kernel(i1) = 1/(pi*(1+(i1/hnum)^2 ))
%  kernel(i1) = sin( (1:hnum) ).*1/(pi*(1+((1:hnum)/hnum)^2 ))

phase = pi/2;

half = floor(hnum/2);
H = ((1:hnum)/hnum);
H2 = (((1:hnum)-half)/hnum).^2;
kernel = sin( (H)*pi - phase  ).* ...
         exp(-(H))
%         1./(pi*(1+(H2)))

kernel1 =  1./(pi*(1+(H2)))
a = lorentz(0.5,hnum);
if DEBUG == 1
  plot(kernel)

  plot(kernel1)

  plot(a);
end