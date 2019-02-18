function [] = SaveAnovaTables_responsetimes_human(rtsh)

% Exp1
[anova_tbl_rtsh_exp1,rm_rtsh_exp1,mauch_rtsh_exp1,epsi_rtsh_exp1] = RunRAnovaN(rtsh(1:20,1:6));
DF_1_exp1 = 2;
DF_2_exp1 = anova_tbl_rtsh_exp1.DF(3*DF_1_exp1);
GrenHouse_correction = epsi_rtsh_exp1.GreenhouseGeisser(3);
corrected_DF1_exp1 = DF_1_exp1.*GrenHouse_correction;
corrected_DF2_exp1 = DF_2_exp1.*GrenHouse_correction;
corrected_pval_exp1 = 1-fcdf(anova_tbl_rtsh_exp1.F(3.*DF_1_exp1 -1),corrected_DF1_exp1,corrected_DF2_exp1);

% Exp2
[anova_tbl_rtsh_exp2,rm_rtsh_exp2,mauch_rtsh_exp2,epsi_rtsh_exp2] = RunRAnovaN(rtsh(21:40,1:6));
DF_1_exp2 = 2;
DF_2_exp2 = anova_tbl_rtsh_exp2.DF(3*DF_1_exp2);
GrenHouse_correction = epsi_rtsh_exp2.GreenhouseGeisser(3);
corrected_DF1_exp2 = DF_1_exp2.*GrenHouse_correction;
corrected_DF2_exp2 = DF_2_exp2.*GrenHouse_correction;
corrected_pval_exp2 = 1-fcdf(anova_tbl_rtsh_exp2.F(3.*DF_1_exp2 -1),corrected_DF1_exp2,corrected_DF2_exp2);

% Exp12
[anova_tbl_rtsh_exp12,rm_rtsh_exp12,mauch_rtsh_exp12,epsi_rtsh_exp12] = RunRAnovaN(rtsh(1:40,1:6));
DF_1_exp12 = 2;
DF_2_exp12 = anova_tbl_rtsh_exp12.DF(3*DF_1_exp12);
GrenHouse_correction = epsi_rtsh_exp12.GreenhouseGeisser(3);
GrenHouse_correction_int = epsi_rtsh_exp12.GreenhouseGeisser(4);
corrected_DF1_exp12 = DF_1_exp12.*GrenHouse_correction;
corrected_DF1_exp12_int = DF_1_exp12.*GrenHouse_correction_int;
corrected_DF2_exp12 = DF_2_exp12.*GrenHouse_correction;
corrected_DF2_exp12_int = DF_2_exp12.*GrenHouse_correction_int;
corrected_pval_exp12 = 1-fcdf(anova_tbl_rtsh_exp12.F(3.*DF_1_exp12 -1),corrected_DF1_exp12,corrected_DF2_exp12);
corrected_pval_exp12_int = 1-fcdf(anova_tbl_rtsh_exp12.F(3.*DF_1_exp12 -1),corrected_DF1_exp12,corrected_DF2_exp12_int);

clear rtsh
save('Stats/anova_table_responsetimes_human')
end

