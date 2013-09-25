%%%%%%% this function generates followup database (after 1 year) for analysis %%%%%%%%%%%%%
%%%%%%%% the data are RAW (unfiltered and unprocessed) 
%%%%%% system initialization %%%%%%
clear all;
clc;
close all;
%%%% Add NIfTi toolbox to load .nii data %%%%%%
[~,pcUserName] = dos('echo %username%'); %%% Get the username of the current pc account  
addpath(genpath(strcat('C:\Users\',pcUserName,'\Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Dr Nourhans Data\NIFTI_20110921'))); %%% Add NIfTi toolbox to load .nii data 

%%% fMRI images: V1 =ANAMASK.nii MAINIMG =filtered_func_data.nii TFRegions = CLGN1-----CSPA2 %%%% 
%%% masks remains same, main images will change after 1 year %%%%%

%%% datasource directories %%%%
root_mask_controls = strcat('C:\Users\',pcUserName,'\Downloads\All Data for thesis\Data_old_ver1\controls');
root_mask_patients = strcat('C:\Users\',pcUserName,'\Downloads\All Data for thesis\Data_old_ver1\patients');

% root_mainImage_control = strcat('C:\Users\',pcUserName,'\Downloads\All Data for thesis\Data_old_ver1\controls'); %%%% Since for control subjects there are no new data, I've used the previous one
% root_mainImage_patient = strcat('C:\Users\',pcUserName,'\Downloads\All Data for thesis\New Data_ver1\PATIENTS_FILTERED');

root_mainImage_control = strcat('C:\Users\',pcUserName,'\Downloads\All Data for thesis\New Data_Fil_Feb2013\Controls');
root_mainImage_patient = strcat('C:\Users\',pcUserName,'\Downloads\All Data for thesis\New Data_Fil_Feb2013\Patients');

%%%% Baseline Data
% control_data={'C1'}; CAPITAL LETTER
% patient_data={'p1'}; SMALL LETTER
% control_data={'C1','C2','C3','C4','C5','C6','C7','C8','C9','C10','C11','C12'};
% patient_data={'p1','p2','p3','p8','p10','p12','p13','p14','p15','p16','p17','p19','p20','p21','p22','p23','p24','p25','p26','p27','p28'};

% %%%% 6 months followup Data
% control_data_after6Months  = {'AG', 'AR', 'C12', 'CF', 'CP', 'CS', 'GH', 'JF', 'JT', 'NA', 'NZ', 'TZ'}; %%% 6 month followup data corresponds to control_data sequence (c1 - c12)
% control_dataBaseline  =      {'C1', 'C2', 'C3',  'C4', 'C5', 'C6', 'C7', 'C8', 'C9', 'C10','C11','C12'};
% patient_data_after6Months  = {'SBi','ZW','SJBU','LS','CDD','JV', 'JJS','RS', 'JB', 'LH', 'AJ', 'MID','EC', 'NW', 'NR', 'MC', 'RF', 'HB', 'WW', 'SA', 'CP'}; %%% 6 month followup data corresponds to patient_data sequence, eg. SJBU ==> p3, LS ==> p8 etc
% patient_dataBaseline   =     {'p1', 'p2', 'p3', 'p8','p10','p12','p13','p14','p15','p16','p17','p19','p20','p21','p22','p23','p24','p25','p26','p27','p28'};

%%%% 1 year followup Data
control_data_after1Year  = {'AG2', 'CP2', 'JT2','NZ2', 'TZ2'}; %%% 1 year followup data corresponds to control_data sequence (c1 - c12)
control_dataBaseline  =    {'C1',  'C5',  'C9', 'C11', 'C12'}; %%% corresponding controls at baseline
patient_data_after1Year  = {'SBi','LS','CDD','JV', 'JB', 'LH', 'AJ', 'EC', 'NR', 'MC', 'RF', 'HB', 'WW', 'SA', 'CP'}; %%% 1 year followup data corresponds to patient_data sequence, eg. SBi ==> p1, LS ==> p8 etc
patient_dataBaseline   =   {'p1', 'p8','p10','p12','p15','p16','p17','p20','p22','p23','p24','p25','p26','p27','p28'}; %%% corresponding patients at baseline

w=cd;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
database_after1Year = struct;
%%%%%%% Define time and frequency vectors and other parameters %%%%%%%%%%
sampleNumber = 1; %%% 1: consider all samples, 2: downsample by 2
T=1.5*sampleNumber; %%%%% Sampling Time
L= 160/sampleNumber; %%%% Signal Length
NFFT = 2^(nextpow2(L)); %%%%%% Number of FFT point 
time_vector = (0:L-1)*T;
frequency_vector = 0:1/(L*T):1/(2*T); %%% for normal FFT
frequency_vector_NFFT = 0:1/(NFFT*T):1/(2*T); %%% for NFFT-point FFT
L_NFFT=length(frequency_vector_NFFT);

%%%%% Store the overhead information in the database header file for further use (if necessary)%%%%%
database_after1Year.header.T=T; %%%%% Sampling Time
database_after1Year.header.NFFT = NFFT; %%%%%% Number of FFT point 
database_after1Year.header.time_vector = time_vector;
database_after1Year.header.frequency_vector = frequency_vector; %%% for normal FFT
database_after1Year.header.frequency_vector_NFFT = frequency_vector_NFFT; %%% for NFFT-point FFT
database_after1Year.header.L_NFFT=L_NFFT;


window_type='tukeywin';
powerOrAmplitude='power';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(control_data_after1Year) %%% for controls after 6 months
    
    %%% load the main image data for control subjects  %%%%%
    root_run_closed = strcat(root_mainImage_control,'\',control_data_after1Year{i});
    root_run_opened = strcat(root_mainImage_control,'\',control_data_after1Year{i});
    
    %%% load V1 mask for control subjects 
    root_ana=strcat(root_mask_controls,'\',control_dataBaseline{i},'\Func\chkbrd');
    %%% load other masks for control subjects (LGN, SPA, LOC)
    root_roi=strcat(root_mask_controls,'\',control_dataBaseline{i},'\Func\TF\regionsfortest');
    
    %%% get the mainImage file for eyesClosed condition
    cd(root_run_closed);
    imageFileNameEC = ls('*_CLOSED*.nii');
    run_closed = load_untouch_nii(imageFileNameEC);   %%% load main image EC condition
    
    %%% get the mainImage file for eyesOpened condition
    cd(root_run_opened);
    imageFileNameEO = ls('*_OPEN*.nii');
    run_opened = load_untouch_nii(imageFileNameEO);  %%% load main image EO condition
    
    %%% get the masks
    cd(root_ana);
    nii_V1=load_untouch_nii('ANA_MASK.nii');   %%% load mask for V1
    
    cd(root_roi); 
    nii_CLGN1=load_untouch_nii('CLGN1_Func_mask.nii'); %%% load mask for CLGN1
    nii_CLGN2=load_untouch_nii('CLGN2_Func_mask.nii'); %%% load mask for CLGN2
    nii_CLOC1=load_untouch_nii('CLOC1_func_mask.nii'); %%% load mask for CLOC1
    nii_CLOC2=load_untouch_nii('CLOC2_func_mask.nii'); %%% load mask for CLOC2
    nii_CSPA1=load_untouch_nii('CSPA1_func_mask.nii'); %%% load mask for CSPA1
    nii_CSPA2=load_untouch_nii('CSPA2_func_mask.nii'); %%% load mask for CSPA2
    
    nii_OLGN1=load_untouch_nii('OLGN1_Func_mask.nii'); %%% load mask for OLGN1
    nii_OLGN2=load_untouch_nii('OLGN2_Func_mask.nii'); %%% load mask for OLGN2
    nii_OLOC1=load_untouch_nii('OLOC1_func_mask.nii'); %%% load mask for OLOC1
    nii_OLOC2=load_untouch_nii('OLOC2_func_mask.nii'); %%% load mask for OLOC2
    nii_OSPA1=load_untouch_nii('OSPA1_func_mask.nii'); %%% load mask for OSPA1
    nii_OSPA2=load_untouch_nii('OSPA2_func_mask.nii'); %%% load mask for OSPA2
    
    cd(w);
    
    %%% Control subject data for eyes closed condition %%%%
    CV1=nii_to_signal(run_closed,nii_V1);
    CLGN1=nii_to_signal(run_closed,nii_CLGN1);
    CLGN2=nii_to_signal(run_closed,nii_CLGN2);
    CLOC1=nii_to_signal(run_closed,nii_CLOC1);
    CLOC2=nii_to_signal(run_closed,nii_CLOC2);
    CSPA1=nii_to_signal(run_closed,nii_CSPA1);
    CSPA2=nii_to_signal(run_closed,nii_CSPA2);
    
    %%% Control subject data for eyes opened condition %%%%
    OV1=nii_to_signal(run_opened,nii_V1);
    OLGN1=nii_to_signal(run_opened,nii_OLGN1);
    OLGN2=nii_to_signal(run_opened,nii_OLGN2);
    OLOC1=nii_to_signal(run_opened,nii_OLOC1);
    OLOC2=nii_to_signal(run_opened,nii_OLOC2);
    OSPA1=nii_to_signal(run_opened,nii_OSPA1);
    OSPA2=nii_to_signal(run_opened,nii_OSPA2);
    
    %%%% store the data into database %%%%
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.LGN1=downsample(CLGN1,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.LGN2=downsample(CLGN2,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.LOC1=downsample(CLOC1,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.LOC2=downsample(CLOC2,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.SPA1=downsample(CSPA1,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.SPA2=downsample(CSPA2,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesClosed.Original.V1=downsample(CV1,sampleNumber);
    
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.LGN1=downsample(OLGN1,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.LGN2=downsample(OLGN2,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.LOC1=downsample(OLOC1,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.LOC2=downsample(OLOC2,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.SPA1=downsample(OSPA1,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.SPA2=downsample(OSPA2,sampleNumber);
    database_after1Year.(control_dataBaseline{i}).eyesOpened.Original.V1=downsample(OV1,sampleNumber);
    
    %%% preprocessing of data (EC condition): dc removal and temporal filtering (windowing) %%%%
    ECnoDC=remove_DC(database_after1Year.(control_dataBaseline{i}).eyesClosed.Original);
    ECnoDCwin=do_window(ECnoDC,window_type);
    
    %%%% fft calculation %%%%%
    database_after1Year.(control_dataBaseline{i}).eyesClosed.FFT=do_fft(ECnoDCwin,NFFT);
    
%     %%%%%  calculate transfer function %%%%%
%     database_after6Months.(control_dataBaseline{i}).eyesClosed.TF=do_TransferFunction(database_after6Months.(sprintf('control%d',i)).eyesClosed.FFT,'all',powerOrAmplitude,NFFT);
       
    %%% preprocessing of data (EO condition): dc removal and temporal filtering (windowing) %%%%
    EOnoDC=remove_DC(database_after1Year.(control_dataBaseline{i}).eyesOpened.Original);
    EOnoDCwin=do_window(EOnoDC,window_type);
    %%%% fft calculation %%%%%%
    database_after1Year.(control_dataBaseline{i}).eyesOpened.FFT = do_fft(EOnoDCwin,NFFT);
%     %%%%%  calculate transfer function %%%%%
%     database_after6Months.(control_data_after6Months{i}).eyesOpened.TF=do_TransferFunction(database_after6Months.(sprintf('control%d',i)).eyesOpened.FFT,'all',powerOrAmplitude,NFFT); 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(patient_data_after1Year) %%% for patients after 6 months
    
    %%% load the main image data for patients  %%%%%
    root_run_closed=strcat(root_mainImage_patient,'\',patient_data_after1Year{i},'\1year');
    root_run_opened=strcat(root_mainImage_patient,'\',patient_data_after1Year{i},'\1year');
    %%% load V1 mask 
    root_ana=strcat(root_mask_patients,'\',patient_dataBaseline{i},'\Func\chkbrd');
    %%% load masks for other regions 
    root_roi=strcat(root_mask_patients,'\',patient_dataBaseline{i},'\Func\TF\regionsfortest');
    
    cd(root_run_closed);
    
    imageFileNameEC = ls('*_CLOSED*.nii');
    run_closed=load_untouch_nii(imageFileNameEC); %%% load main image EC condition
    
    cd(root_run_opened);
    imageFileNameEO = ls('*_OPEN*.nii');
    run_opened=load_untouch_nii(imageFileNameEO);  %%% load main image EO condition
    
    cd(root_ana);
    if i == 1
        nii_V1=load_untouch_nii('ANA_MASK.img');   %%% load mask of V1 for patient p1 (only .img file is available for p1)  
    else
        nii_V1=load_untouch_nii('ANA_MASK.nii');   %%% load mask for V1 for other patients
    end
    
    cd(root_roi);
    nii_CLGN1=load_untouch_nii('CLGN1_Func_mask.nii');  %%% load mask for CLGN1
    nii_CLGN2=load_untouch_nii('CLGN2_Func_mask.nii');  %%% load mask for CLGN2
    nii_CLOC1=load_untouch_nii('CLOC1_func_mask.nii');  %%% load mask for CLOC1
    nii_CLOC2=load_untouch_nii('CLOC2_func_mask.nii');  %%% load mask for CLOC2
    nii_CSPA1=load_untouch_nii('CSPA1_func_mask.nii');  %%% load mask for CSPA1
    nii_CSPA2=load_untouch_nii('CSPA2_func_mask.nii');  %%% load mask for CSPA2
    
    nii_OLGN1=load_untouch_nii('OLGN1_Func_mask.nii');  %%% load mask for OLGN1
    nii_OLGN2=load_untouch_nii('OLGN2_Func_mask.nii');  %%% load mask for OLGN2
    nii_OLOC1=load_untouch_nii('OLOC1_func_mask.nii');  %%% load mask for OLOC1
    nii_OLOC2=load_untouch_nii('OLOC2_func_mask.nii');  %%% load mask for OLOC2
    nii_OSPA1=load_untouch_nii('OSPA1_func_mask.nii');  %%% load mask for OSPA1
    nii_OSPA2=load_untouch_nii('OSPA2_func_mask.nii');  %%% load mask for OSPA2
    
    cd(w);
    
    %%% Patient data for eyes closed condition %%%%
    CV1=nii_to_signal(run_closed,nii_V1);
    CLGN1=nii_to_signal(run_closed,nii_CLGN1);
    CLGN2=nii_to_signal(run_closed,nii_CLGN2);
    CLOC1=nii_to_signal(run_closed,nii_CLOC1);
    CLOC2=nii_to_signal(run_closed,nii_CLOC2);
    CSPA1=nii_to_signal(run_closed,nii_CSPA1);
    CSPA2=nii_to_signal(run_closed,nii_CSPA2);
    
    %%% Patient data for eyes opened condition %%%%
    OV1=nii_to_signal(run_opened,nii_V1);
    OLGN1=nii_to_signal(run_opened,nii_OLGN1);
    OLGN2=nii_to_signal(run_opened,nii_OLGN2);
    OLOC1=nii_to_signal(run_opened,nii_OLOC1);
    OLOC2=nii_to_signal(run_opened,nii_OLOC2);
    OSPA1=nii_to_signal(run_opened,nii_OSPA1);
    OSPA2=nii_to_signal(run_opened,nii_OSPA2);
    
    %%%% store the data into database %%%%
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.LGN1=downsample(CLGN1,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.LGN2=downsample(CLGN2,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.LOC1=downsample(CLOC1,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.LOC2=downsample(CLOC2,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.SPA1=downsample(CSPA1,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.SPA2=downsample(CSPA2,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original.V1=downsample(CV1,sampleNumber);
    
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.LGN1=downsample(OLGN1,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.LGN2=downsample(OLGN2,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.LOC1=downsample(OLOC1,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.LOC2=downsample(OLOC2,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.SPA1=downsample(OSPA1,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.SPA2=downsample(OSPA2,sampleNumber);
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original.V1=downsample(OV1,sampleNumber);
    
    %%% preprocessing of data (EC condition): dc removal and temporal filtering (windowing) %%%%
    ECnoDC=remove_DC(database_after1Year.(patient_dataBaseline{i}).eyesClosed.Original);
    ECnoDCwin=do_window(ECnoDC,window_type);
    
    %%%% fft calculation  %%%%%%%
    database_after1Year.(patient_dataBaseline{i}).eyesClosed.FFT=do_fft(ECnoDCwin,NFFT);
    
%     %%%%%  calculate transfer function %%%%%
%     database_after6Months.(patient_data{i}).eyesClosed.TF=do_TransferFunction(database_after6Months.(sprintf('control%d',i)).eyesClosed.FFT,'all',powerOrAmplitude,NFFT);
       
    %%% preprocessing of data (EO condition): dc removal and temporal filtering (windowing) %%%%
    EOnoDC=remove_DC(database_after1Year.(patient_dataBaseline{i}).eyesOpened.Original);
    EOnoDCwin=do_window(EOnoDC,window_type);
    
    %%%% fft calculation 
    database_after1Year.(patient_dataBaseline{i}).eyesOpened.FFT=do_fft(EOnoDCwin,NFFT);
    
%     %%%%%  calculate transfer function %%%%%
%     database_after6Months.(patient_data{i}).eyesOpened.TF=do_TransferFunction(database_after6Months.(sprintf('control%d',i)).eyesOpened.FFT,'all',powerOrAmplitude,NFFT); 

end

save(strcat('database_after1Year_',date,'.mat'), 'database_after1Year')
    
    
    
