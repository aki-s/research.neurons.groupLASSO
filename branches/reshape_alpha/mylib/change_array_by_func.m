function change_array_by_func()
  a = [1];
  assert(a(1) == 1, 'a(1) == 1');
  change_array(a, 2);
a
  assert(a(1) == 2, 'a(1) == 2');  % ここでエラー
  disp('OK');
end

function change_array(a, value)
  a(1) = value;
end
