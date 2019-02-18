%% Run all code to generate figures for:
% Human Noise Blindness paper
% Herce Castanon et al

%% add accessory functions and data to the path
addpath('AccessoryFunctions/')
addpath('Data')

%% load behavioural data
load('data_human_noise_blindness_Exp_1236.mat')

% Get human summary choice measures for experiments 1,2 and 3
[acch, confh, biash, optoh]    = GetSummaryBehaviourMeasures_Exp123(data);

% Get Psychometric points
[PsychoMatH] = PsychometricPoints(data);

% Get regression coefficients
[betaschoiceH,  betasconfH, betasconfunsignedH, betasoptoH] = RunRegressionFull(data);

% Get behavioural measures related to confidence resolution
[ResMatH,CalMatH,ConfVarMatH,OptOutVarMatH,ConfMuMatH,OptOutMuMatH] = GetConfidenceResolution(data);

%% Generate Figures for main text
DefineFigureVariables

Create_Fig_main_2
Create_Fig_main_3
Create_Fig_main_5
Create_Fig_main_6

%% Now do Supplementary Information
Create_Fig_SI_2
Create_Fig_SI_3
Create_Fig_SI_4
Create_Fig_SI_6
Create_Fig_SI_7
Create_Fig_SI_8
