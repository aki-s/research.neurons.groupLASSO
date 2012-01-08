function save_windows_all(savedirname)
%% sequentially save all windows as figures.
%% output name is serialized in turn.

figHandles = get(0,'Children');
for i1 = 1:length(figHandles)
  print(figHandles(i1),'-dpng',[sprintf('%s/%04d',savedirname,i1) '.png'] );
end


