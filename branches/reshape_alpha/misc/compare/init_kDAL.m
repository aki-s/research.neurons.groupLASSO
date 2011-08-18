function kDAL = init_kDAL
%function kDAL = init_kDAL(kDrow)

kDAL = conf_DAL();
%kDAL.Drow = kDrow;
kDAL.opt.display = 1;
kDAL.regFac_UserDef =1;