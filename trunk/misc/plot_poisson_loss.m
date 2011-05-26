z=[0,1];
zz= {'exp(f)','-f + exp(f)'};
%zz= ['exp(f)','-f + exp(f)'];
width=5;
f=-width:1:width;
lambda = @(f) exp(f);
p = [];
figure;
hold on;
for num = z
     pp = @(f) -( num*log(lambda(f)) - lambda(f) );
     p =[p; pp(f)];
%           fprintf('%10.7f\n',p)
end
color=['b','g','r','c','m','b'];
%col=ceil(7*rand(1,2));

  for i1 = z +1
%h = plot(f,p(i1,:),color(col(i1)));
plot(f,p(i1,:),color(i1));
%legend(zz(i1))
%set(h,'Displayname',zz(i1))
  end
legend(zz)
