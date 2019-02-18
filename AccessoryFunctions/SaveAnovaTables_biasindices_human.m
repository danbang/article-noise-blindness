function [] = SaveAnovaTables_biasindices_human(biash)
[anova_table_biash_exp12,rm_biash_exp12,mauch_biash_exp12,epsi_biash_exp12] = RunRAnovaN(biash(1:40,7:12));
DF_1 = 2;
DF_2 = anova_table_biash_exp12.DF(3*DF_1);
GrenHouse_correction = epsi_biash_exp12.GreenhouseGeisser(3);
corrected_DF1 = DF_1.*GrenHouse_correction;
corrected_DF2 = DF_2.*GrenHouse_correction;
corrected_pval = 1-fcdf(anova_table_biash_exp12.F(3.*DF_1 -1),corrected_DF1,corrected_DF2);
clear biash
save('Stats/anova_table_biasindices_human')
end