z=[0,1];
zz= {'exp(D)','-D + exp(D)'};
%zz= ['exp(D)','-D + exp(D)'];
width=5;
D=-width:1:width; %D: discriminant function
lambda = @(D) exp(D);
p = [];
figure;
hold on;
for num = z
     pp = @(D) -( num*log(lambda(D)) - lambda(D) );
     p =[p; pp(D)];
%           DprintD('%10.7D\n',p)
end
color=['b','g','r','c','m','b'];
%col=ceil(7*rand(1,2));

  for i1 = z +1
%h = plot(f,p(i1,:),color(col(i1)));
plot(D,p(i1,:),color(i1));
%legend(zz(i1))
%set(h,'Displayname',zz(i1))
  end
legend(zz)
