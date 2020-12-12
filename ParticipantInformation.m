%% getting participant information
function [subNo,group,gender,name,version,hand,age,IP2,IP3,IP4,IP5,fp] = ParticipantInformation()
subID = '0';
Group = '0';
Gender = '1';
Name = '';
Version = '2';  %2��ʾ���Ļ�
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


Notes = 'Please enter guest IPs';  %%%%����client��IP��ַ
IP2 = '192.168.88.101';   %����1��IP
IP3 = '192.168.88.2';  %����2��IP
IP4 = '192.168.88.4';  %����4��IP
IP5 = '192.168.88.6';  %����6��IP
IPs={'Notes','IP2','IP3','IP4','IP5'}; %
defaultParameters = {Notes,IP2,IP3,IP4,IP5};  %
IPs=inputdlg(IPs,'IPs',1,defaultParameters);
IP2 = IPs{2};
IP3 = IPs{3};
IP4 = IPs{4};
IP5 = IPs{5};


%���������������ļ����
folder_path = cd; %���ļ���
savename = 'data_individual_decision';
%��������ڸ��ļ��� ������һ��
if ~isdir(fullfile(folder_path,'data_individual_decision'))
    mkdir(fullfile(folder_path,'data_individual_decision'));
end
outputfile = fullfile(folder_path,'data_individual_decision',[savename '_s' subID '.txt']);

%����Ƿ������Ѿ����ڵı��Ա�ţ���ֹ���ݸ�д
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

fprintf(fp,'%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n',...
    'subNo','gender','name','TrialNum','position_chose','chose_RT','confidence_rating','confidence_rating_RT');
