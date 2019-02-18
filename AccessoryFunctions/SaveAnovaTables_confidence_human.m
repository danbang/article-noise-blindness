function [] = SaveAnovaTables_confidence_human(confh)
[anova_tbl_confh_exp2,rm_confh_exp2,mauch_confh_exp2,epsi_confh_exp2] = RunRAnovaN(confh(21:40,1:6));
DF_1 = 2;
DF_2 = anova_tbl_confh_exp2.DF(3*DF_1);
GrenHouse_correction = epsi_confh_exp2.GreenhouseGeisser(3);
corrected_DF1 = DF_1.*GrenHouse_correction;
corrected_DF2 = DF_2.*GrenHouse_correction;
corrected_pval = 1-fcdf(anova_tbl_confh_exp2.F(3.*DF_1 -1),corrected_DF1,corrected_DF2);

clear confh
save('Stats/anova_table_confidence_human')
end