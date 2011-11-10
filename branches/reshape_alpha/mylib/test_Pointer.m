function p1 = test_Pointer()
  p1 = Pointer(1)
  p2 = p1;
  assert(p1.get() == 1, 'p1.get() == 1');
  assert(p2.get() == 1, 'p2.get() == 1');    
  change_pointer(p1, 2);
  assert(p1.get() == 2, 'p1.get() == 2');
  assert(p2.get() == 2, 'p2.get() == 2');  
  disp('OK');
end

function change_pointer(p, value)
  p.set(value);
end
