function [] = SaveAnovaTables_accuracies_human(acch)

% Exp1
[anova_tbl_acch_exp1,rm_acch_exp1,mauch_acch_exp1,epsi_acch_exp1] = RunRAnovaN(acch(1:20,1:6));
DF_1_exp1 = 2;
DF_2_exp1 = anova_tbl_acch_exp1.DF(3*DF_1_exp1);
GrenHouse_correction = epsi_acch_exp1.GreenhouseGeisser(3);
corrected_DF1_exp1 = DF_1_exp1.*GrenHouse_correction;
corrected_DF2_exp1 = DF_2_exp1.*GrenHouse_correction;
corrected_pval1 = 1-fcdf(anova_tbl_acch_exp1.F(3.*DF_1_exp1 -1),corrected_DF1_exp1,corrected_DF2_exp1);

% Exp2
[anova_tbl_acch_exp2,rm_acch_exp2,mauch_acch_exp2,epsi_acch_exp2] = RunRAnovaN(acch(21:40,1:6));
DF_1_exp2 = 2;
DF_2_exp2 = anova_tbl_acch_exp2.DF(3*DF_1_exp2);
GrenHouse_correction = epsi_acch_exp2.GreenhouseGeisser(3);
corrected_DF1_exp2 = DF_1_exp2.*GrenHouse_correction;
corrected_DF2_exp2 = DF_2_exp2.*GrenHouse_correction;
corrected_pval2 = 1-fcdf(anova_tbl_acch_exp2.F(3.*DF_1_exp2 -1),corrected_DF1_exp2,corrected_DF2_exp2);

% Exp12
[anova_tbl_acch_exp12,rm_acch_exp12,mauch_acch_exp12,epsi_acch_exp12] = RunRAnovaN(acch(1:40,1:6));
DF_1_exp12 = 2;
DF_2_exp12 = anova_tbl_acch_exp12.DF(3*DF_1_exp12);
GrenHouse_correction = epsi_acch_exp12.GreenhouseGeisser(3);
corrected_DF1_exp12 = DF_1_exp12.*GrenHouse_correction;
corrected_DF2_exp12 = DF_2_exp12.*GrenHouse_correction;
corrected_pval12 = 1-fcdf(anova_tbl_acch_exp12.F(3.*DF_1_exp12 -1),corrected_DF1_exp12,corrected_DF2_exp12);

clear acch
save('Stats/anova_table_accuracies_human')
end

