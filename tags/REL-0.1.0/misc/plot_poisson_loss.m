z=[0,1];
zz= {'\lambda_i','(-1) \cdot ( log(\lambda_i) - \lambda _i)'};
%zz= {'exp(D)','-D + exp(D)'};
%zz= ['exp(D)','-D + exp(D)'];
width=5;
D=-width:1:width; %D: discriminant function
lambda = @(D) exp(D);
p = [];
figure;
hold on;
set(gcf,'color','white')
for num = z
  pp = @(D) -( num*log(lambda(D)) - lambda(D) );
  p =[p; pp(D)];
  %           DprintD('%10.7D\n',p)
end
color={'b','g','r','c','m','b'};
%col=ceil(7*rand(1,2));
choice = [1 5];
for i1 = 1:length(z)
  plot(D,p(i1,:),color{choice(i1)},'LineWidth',3);
  %legend(zz(i1))
  %set(h,'Displayname',zz(i1))
end
legend(zz,'FontSize',14,'LineWidth',3);
set(gca,'FontSize',18)
ylim([0 10])
widthp = 4;
xlim([-widthp widthp])