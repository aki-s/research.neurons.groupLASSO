function kDAL = init_kDAL(kDrow)

kDAL = conf_DAL();
kDAL.Drow = kDrow;
kDAL.speedup =0;
kDAL.loop = 3;
kDAL.regFac = zeros(1,kDAL.loop); % kDAL.regFac: regularization factor.

