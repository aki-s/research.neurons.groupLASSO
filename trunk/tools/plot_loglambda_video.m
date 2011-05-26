tmph=figure;
for i1 = 1: env.cnum 
    figure(tmph);
    plot(loglambda(:,i1)');
    system('/bin/sleep 2');
end;