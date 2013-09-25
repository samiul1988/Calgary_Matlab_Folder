function data=get_input()

%%%%% Open necessary files %%%%%%%
%%%%%% C1 == Control subject 1, P1 = Patient 1....etc
%%%%%% C = Eyes Closed, O = Eyes Open %%%%
data=struct;
% root_dir='C:\Users\Samiul\Downloads\My Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset';
root_dir='C:\Users\Samiul\Downloads\My Dropbox\samiul_home_lab\Calgary Matlab Folder\Thesis\Nourhan Reanalysis_Mathews Files\All Patient Data\Dataset\before_windowing';

check_type=input('Control Subject or patient data?(Type "c" for Control and "p" for Patient):','s');
if check_type=='c'
    check_number=input('Enter control subject number (1 to 12): ');
    check_eye=input('Eyes Closed or Open? (Type "c" for closed and "o" for open): ','s');
    if check_eye=='c'
        file_dir=strcat('\controls','\C',num2str(check_number),'\RegionsTC','\C');
    elseif check_eye=='o' 
        file_dir=strcat('\controls','\C',num2str(check_number),'\RegionsTC','\O');
    else error('myApp:eyeChk', 'Wrong Eye condition!!!')
    end 
elseif check_type=='p'
    check_number=input('Enter patient number (1 to 12): ');
    check_eye=input('Eyes Closed or Open? (Type "c" for closed and "o" for open): ','s');
    check_return_patient = input('Enter Patient Nature: "Null" for current patient, "a" for return patient\n or "b" for double retrun patient: ','s');
    if check_eye=='c'
        file_dir=strcat('\patients','\p',num2str(check_number),check_return_patient,'\RegionsTC','\C');
    elseif check_eye=='o' 
        file_dir=strcat('\patients','\p',num2str(check_number),check_return_patient,'\RegionsTC','\O');
    else error('myApp:eyeChk', 'Wrong Eye condition!!!')
    end
else error('myApp:eyeChk2', 'Wrong Command!!!')
end
root_dir=strcat(root_dir,file_dir);
w=cd;
cd(root_dir);
if check_eye=='c'
    load(strcat('C','LGN1.dat'));
    load(strcat('C','LGN2.dat'));
    load(strcat('C','LOC1.dat'));
    load(strcat('C','LOC2.dat'));
    load(strcat('C','SPA1.dat'));
    load(strcat('C','SPA2.dat'));
    load(strcat('C','V1.dat'));
else 
    load(strcat('O','LGN1.dat'));
    load(strcat('O','LGN2.dat'));
    load(strcat('O','LOC1.dat'));
    load(strcat('O','LOC2.dat'));
    load(strcat('O','SPA1.dat'));
    load(strcat('O','SPA2.dat'));
    load(strcat('O','V1.dat'));
end
cd(w);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if check_eye=='c'
    data.LGN = CLGN1;
    data.V1 = CV1;
    data.LOC1 = CLOC1;
    data.LOC2 = CLOC2;
    data.SPA1 = CSPA1;
    data.SPA2 = CSPA2;
else 
    data.LGN = OLGN1;
    data.V1 = OV1;
    data.LOC1 = OLOC1;
    data.LOC2 = OLOC2;
    data.SPA1 = OSPA1;
    data.SPA2 = OSPA2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 