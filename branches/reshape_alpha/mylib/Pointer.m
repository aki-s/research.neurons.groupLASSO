function self = Pointer(pointee)
  pointer = pointee;
  self = struct;
  function retval = get()
    retval = pointer;
  end
  function retval = set(new_pointee)
    pointer = new_pointee;
    retval = self;
  end  self.get = @get;
  self.set = @set;
end
