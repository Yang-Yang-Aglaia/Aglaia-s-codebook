%% getting participant information
function [subNo,group,gender,name,version,hand,age,IP1,fp]=PrepareInformation()
subID = '0';
Group = '0';
Gender = '1';
Name = '';
Version = '2';  %为什么变成4
Hand = '1';
Age = '';
promptParameters = {'Subject ID' 'Group' 'Gender' 'Name' 'Version' 'Hand' 'Age'};
defaultParameters = {subID,Group,Gender,Name,Version,Hand,Age};
Settings = inputdlg(promptParameters, 'Settings', 1,  defaultParameters);
pause(0.5);
subID = Settings{1};
subNo = str2double(subID);
group = str2double(Settings{2});
gender = str2double(Settings{3});
name = Settings{4};
version = str2double(Settings{5});
hand = str2double(Settings{6});
age = str2double(Settings{7});

Notes = 'Please enter host IPs';  %%%%输入client的IP地址
IP1 = '192.168.88.3';
IPs={'Notes','IP1'};
defaultParameters = {Notes,IP1};
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP1 = IPs{2};

%输入两个独立的文件结果
folder_path = cd;
savename = 'data_individual_decision';
if ~isdir(fullfile(folder_path,'data_individual_decision'))
    mkdir(fullfile(folder_path,'data_individual_decision'));
end
outputfile = fullfile(folder_path,'data_individual_decision',[savename '_s' subID '.txt']);

%检查是否输入已经存在的被试编号，防止数据覆写
if fopen(outputfile, 'rt')~=-1
    fclose('all');
    %     error('Result data file already exists! Choose a different subject number.');
    
    replace = str2double(inputdlg({'Do you want to replace the exist file? Yes-1 No-2'},'Replace?')); % replace or not
    if replace(1) == 1
        fp = fopen(outputfile,'wt');
        %fp2 = fopen(outputfile2,'wt');
    end
else
    fp = fopen(outputfile,'wt'); % open ASCII file for writing
    %fp2 = fopen(outputfile2,'wt'); % open ASCII file for writing
end


fprintf(fp,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t\n',...
    'subNo','gender','name','TrialNum','StimNum','ComNum','position_chose','chose_RT','confidence_rating','confidence_rating_RT','position_chose1','position_chose2','raw_chose_leader','Version');
%fprintf(fp,'%s\n',...
%    'subNo');