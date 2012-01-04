function range = set_frameRange(N_default,N_in,FROM,TO)

if N_default > N_in % only one frame
  range.from = FROM;
  range.to = range.from;
else % mix ALL
  range.from = 1;
  range.to = TO;
end

