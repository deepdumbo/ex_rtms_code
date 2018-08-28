clear; close all; clc;

% This script can be used to return the main outcome measures for the
% stop-signal task across the ex rTMS participant sample 


ActiveID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S16_YS';'S17_YS';'S19_JA';'S20_WO';'S22_NS';'S25_SC';'S27_ANW';'S34_ST';'S35_TG';'S36_AY'};

InactiveID = {'S1_JC';'S7_PK';'S13_MD';'S15_AZ';'S18_KF';'S21_KC';'S24_AU';'S26_KW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

timePoint = {'pre';'post';'follow_up'};

% Condition = {'wk1_llpc';'wk2_sma'} - This was replaced for pathIn_mod ln
% 19 - allowing use of wildcard for stimulation conditions 

pathIn = '/Volumes/Lacie/Ex_rTMS_study/Data';

%% loop over subjects in active group

for x = 1:length(ActiveID)
    
    pathIn_mod = dir([char(pathIn),'/Active/',char(ActiveID(x,1)),'/Cognitive/','wk*']);  % Used the dir function to permit use of wildcard * for the two stimulation condition directories
    
    Condition = {pathIn_mod(1).name; pathIn_mod(2).name}; % This cell indexes into structure pathIn_mod to access two strings identifying stim condition
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            filename_SST = [char(pathIn),'/Active/',char(ActiveID(x,1)),'/Cognitive/',char(Condition(y,1)),'/SST/',char(timePoint(z,1)),'/',char(ActiveID(x,1)),'_',char(timePoint(z,1)),'.dat'];
            
            % filename = [pathIn,'/','Active','/',ActiveID(x,1),'/','Cognitive','/',Condition(y,1),'/','SST','/',timePoint(z,1),'/','SST_',ActiveID(x,1),'_',timePoint(z,1),'.dat'] 
            
             [Active_data.(ActiveID{x}).(Condition{y}).(timePoint{z}).ssrt_integration,Active_data.(ActiveID{x}).(Condition{y}).(timePoint{z}).ssrt_mean] = sst_master(filename_SST);
        end
    end
end

%% loop over subjects in inactive group 

for x = 1:length(InactiveID)
    
    pathIn_mod = dir([char(pathIn),'/Inactive/',char(InactiveID(x,1)),'/Cognitive/','wk*']);  % Used the dir function to permit use of wildcard * for the two stimulation condition directories
    
    Condition = {pathIn_mod(1).name; pathIn_mod(2).name}; % This cell indexes into structure pathIn_mod to access two strings identifying stim condition
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            filename_SST = [char(pathIn),'/Inactive/',char(InactiveID(x,1)),'/Cognitive/',char(Condition(y,1)),'/SST/',char(timePoint(z,1)),'/','SST_',char(InactiveID(x,1)),'_',char(timePoint(z,1)),'.dat'];
            
            % filename = [pathIn,'/','Active','/',ActiveID(x,1),'/','Cognitive','/',Condition(y,1),'/','SST','/',timePoint(z,1),'/','SST_',ActiveID(x,1),'_',timePoint(z,1),'.dat'] 
            
             [Inactive_data.(ID{x}).(Condition{y}).(timePoint{z}).ssrt_integration,Inactive_data.(ActiveID{x}).(Condition{y}).(timePoint{z}).ssrt_mean] = sst_master(filename_SST);
        end
    end
end

%======Output cell================

