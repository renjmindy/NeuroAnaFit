%--------------------------------------------------------------------------
% Job saved on 04-Nov-2017 19:22:39 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6906)
% this batch script is valid to analyze data from "single" subject only
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Settings
%--------------------------------------------------------------------------
runs=[1:4];                                                     % no. of runs per subject
epis=[5:8];                                                     % EPI runs in sequence
nFiles=[253 239 220 217];                                       % no. of rawEPI files per run (change from analyzers required)
noFs=nFiles(1)+nFiles(2)+nFiles(3)+nFiles(4);                   % sum
TR=2;                                                           % seconds
nSlices=39;                                                     %
TA=TR-(TR/nSlices);                                             %
refSlice=39;                                                    % 
% slice order -----------------------
sliceOrder=[1:2:nSlices 2:2:nSlices];                           % ascending interleaved
tpmFile='C:\Users\Owner\Documents\MATLAB\spm12\tpm\TPM.nii';    % TPM file (change from analyzers required)
label='af171101CAC02';
mriSubj='171101CAC02';                                          % name of subject (change from analyzers required)
fbname='D:\1101_2\2_025_2017_11_01_1511.txt';                   % name of behavior data file (change from analyzers required)
fb2name='D:\1101_2\2_025_2017_11_01_1511.csv';                  % name of behavior data file (change from analyzers required)
reg1name='D:\1101_2\EPI1\rp_af171101CAC02-0005-00001-000001-01.txt'; % name of multi-regressor file (change from analyzers required)      
reg2name='D:\1101_2\EPI2\rp_af171101CAC02-0006-00001-000001-01.txt'; % name of multi-regressor file (change from analyzers required)
reg3name='D:\1101_2\EPI3\rp_af171101CAC02-0007-00001-000001-01.txt'; % name of multi-regressor file (change from analyzers required)
reg4name='D:\1101_2\EPI4\rp_af171101CAC02-0008-00001-000001-01.txt'; % name of multi-regressor file (change from analyzers required)
mriFldr='D:\1101_2';                                            % rawEPI file folder (change from analyzers required)
script_fldr='C:\Users\Owner\Documents\MATLAB\spm12';            % SPM12 installation folder (change from analyzers required)
preproc_fldr=[ script_fldr '\neuroFitPreproc' ];                % SPM12 batch script location (change from analyzers required)
addpath(preproc_fldr);

%--------------------------------------------------------------------------
% Loading Behavior Data (.csv)
%--------------------------------------------------------------------------
M1 = csvread(fb2name,0,4,[0,4,39,6]);
M2 = csvread(fb2name,0,7,[0,7,39,9]);
M2R1 = M2(:,1);
M2R2 = M2(:,2);
M2R3 = M2(:,3);
v1 = M1(:,1);
v2 = M1(:,2);
v3 = M1(:,3);
idxA = sub2ind(size(M2),1:40,v1');
idxB = sub2ind(size(M2),1:40,v2');
idxC = sub2ind(size(M2),1:40,v3');
M2A = M2(idxA);
M2B = M2(idxB);
M2C = M2(idxC);
M2S = cat(1,M2A,M2B,M2C);
M2R = reshape(M2S,[],1);

%--------------------------------------------------------------------------
% Loading Behavior Data (.txt)
%--------------------------------------------------------------------------
fid=fopen(fbname, 'r');
text = textscan(fid,'%s');
text = text{1};
fid=fclose(fid);
disp('*****************************************************************************************************************');
Rst_msg = [' !!! Start reading behavior data in ',fbname,' !!! '];
disp(Rst_msg);
disp('*****************************************************************************************************************');
%
disp(' ------------------- Initialize Story Reading ---------------------- ');
fprintf('\n');
%
str_RPJf = 'read_PJf';
idx_RPJf = find(~cellfun('isempty',strfind(text,str_RPJf))) +1;
RPJf = str2double(text(idx_RPJf));
%
str_RPOf = 'read_POf';
idx_RPOf = find(~cellfun('isempty',strfind(text,str_RPOf))) +1;
RPOf = str2double(text(idx_RPOf));
%
str_RPGf = 'read_PGf';
idx_RPGf = find(~cellfun('isempty',strfind(text,str_RPGf))) +1;
RPGf = str2double(text(idx_RPGf));
%
str_RPSf = 'read_PSf';
idx_RPSf = find(~cellfun('isempty',strfind(text,str_RPSf))) +1;
RPSf = str2double(text(idx_RPSf));
%
str_RPSm = 'read_PSm';
idx_RPSm = find(~cellfun('isempty',strfind(text,str_RPSm))) +1;
RPSm = str2double(text(idx_RPSm));
%
str_RCon = 'read_Con';
idx_RCon = find(~cellfun('isempty',strfind(text,str_RCon))) +1;
RCon = str2double(text(idx_RCon));
%
str_RPGm = 'read_PGm';
idx_RPGm = find(~cellfun('isempty',strfind(text,str_RPGm))) +1;
RPGm = str2double(text(idx_RPGm));
%
str_RPOm = 'read_POm';
idx_RPOm = find(~cellfun('isempty',strfind(text,str_RPOm))) +1;
RPOm = str2double(text(idx_RPOm));
%
str_RPJm = 'read_PJm';
idx_RPJm = find(~cellfun('isempty',strfind(text,str_RPJm))) +1;
RPJm = str2double(text(idx_RPJm));
%
str_PostF = 'post_fix';
idx_PostF = find(~cellfun('isempty',strfind(text,str_PostF))) +1;
RPoF = str2double(text(idx_PostF));
%
combo_RStr11 = cat(1,RPJf(1),RPJm(1),RPOf(1),RPOm(1));
disp('Session 1 Rational - Reading onset values: ');
disp(combo_RStr11);
%
delta_RStrT111 = minus(RPoF(1:10),combo_RStr11(1));
delta_RStrT11(1) = min(delta_RStrT111(delta_RStrT111>0.));
delta_RStrT112 = minus(RPoF(1:10),combo_RStr11(2));
delta_RStrT11(2) = min(delta_RStrT112(delta_RStrT112>0.));
delta_RStrT113 = minus(RPoF(1:10),combo_RStr11(3));
delta_RStrT11(3) = min(delta_RStrT113(delta_RStrT113>0.));
delta_RStrT114 = minus(RPoF(1:10),combo_RStr11(4));
delta_RStrT11(4) = min(delta_RStrT114(delta_RStrT114>0.));
disp('Session 1 Rational - duration values: ');
disp((delta_RStrT11)');
%
combo_RStr12 = cat(1,RPGf(1),RPGm(1),RPSf(1),RPSm(1));
disp('Session 1 Relational - Reading onset values: ');
disp(combo_RStr12);
%
delta_RStrT121 = minus(RPoF(1:10),combo_RStr12(1));
delta_RStrT12(1) = min(delta_RStrT121(delta_RStrT121>0.));
delta_RStrT122 = minus(RPoF(1:10),combo_RStr12(2));
delta_RStrT12(2) = min(delta_RStrT122(delta_RStrT122>0.));
delta_RStrT123 = minus(RPoF(1:10),combo_RStr12(3));
delta_RStrT12(3) = min(delta_RStrT123(delta_RStrT123>0.));
delta_RStrT124 = minus(RPoF(1:10),combo_RStr12(4));
delta_RStrT12(4) = min(delta_RStrT124(delta_RStrT124>0.));
disp('Session 1 Relational - Reading duration values: ');
disp((delta_RStrT12)');
%
combo_RStr13 = cat(1,RCon(1:2));
disp('Session 1 Neutral - Reading onset values: ');
disp(combo_RStr13);
%
delta_RStrT131 = minus(RPoF(1:10),combo_RStr13(1));
delta_RStrT13(1) = min(delta_RStrT131(delta_RStrT131>0.));
delta_RStrT132 = minus(RPoF(1:10),combo_RStr13(2));
delta_RStrT13(2) = min(delta_RStrT132(delta_RStrT132>0.));
disp('Session 1 Neutral - Reading duration values: ');
disp((delta_RStrT13)');
%
combo_RStr21 = cat(1,RPJf(2),RPJm(2),RPOf(2),RPOm(2));
disp('Session 2 Rational - Reading onset values: ');
disp(combo_RStr21);
%
delta_RStrT211 = minus(RPoF(11:20),combo_RStr21(1));
delta_RStrT21(1) = min(delta_RStrT211(delta_RStrT211>0.));
delta_RStrT212 = minus(RPoF(11:20),combo_RStr21(2));
delta_RStrT21(2) = min(delta_RStrT212(delta_RStrT212>0.));
delta_RStrT213 = minus(RPoF(11:20),combo_RStr21(3));
delta_RStrT21(3) = min(delta_RStrT213(delta_RStrT213>0.));
delta_RStrT214 = minus(RPoF(11:20),combo_RStr21(4));
delta_RStrT21(4) = min(delta_RStrT214(delta_RStrT214>0.));
disp('Session 2 Rational - Reading duration values: ');
disp((delta_RStrT21)');
%
combo_RStr22 = cat(1,RPGf(2),RPGm(2),RPSf(2),RPSm(2));
disp('Session 2 Relational - Reading onset values: ');
disp(combo_RStr22);
%
delta_RStrT221 = minus(RPoF(11:20),combo_RStr22(1));
delta_RStrT22(1) = min(delta_RStrT221(delta_RStrT221>0.));
delta_RStrT222 = minus(RPoF(11:20),combo_RStr22(2));
delta_RStrT22(2) = min(delta_RStrT222(delta_RStrT222>0.));
delta_RStrT223 = minus(RPoF(11:20),combo_RStr22(3));
delta_RStrT22(3) = min(delta_RStrT223(delta_RStrT223>0.));
delta_RStrT224 = minus(RPoF(11:20),combo_RStr22(4));
delta_RStrT22(4) = min(delta_RStrT224(delta_RStrT224>0.));
disp('Session 2 Relational - Reading duration values: ');
disp((delta_RStrT22)');
%
combo_RStr23 = cat(1,RCon(3:4));
disp('Session 2 Neutral - Reading onset values: ');
disp(combo_RStr23);
%
delta_RStrT231 = minus(RPoF(11:20),combo_RStr23(1));
delta_RStrT23(1) = min(delta_RStrT231(delta_RStrT231>0.));
delta_RStrT232 = minus(RPoF(11:20),combo_RStr23(2));
delta_RStrT23(2) = min(delta_RStrT232(delta_RStrT232>0.));
disp('Session 2 Neutral - Reading duration values: ');
disp((delta_RStrT23)');
%
combo_RStr31 = cat(1,RPJf(3),RPJm(3),RPOf(3),RPOm(3));
disp('Session 3 Rational - Reading onset values: ');
disp(combo_RStr31);
%
delta_RStrT311 = minus(RPoF(21:30),combo_RStr31(1));
delta_RStrT31(1) = min(delta_RStrT311(delta_RStrT311>0.));
delta_RStrT312 = minus(RPoF(21:30),combo_RStr31(2));
delta_RStrT31(2) = min(delta_RStrT312(delta_RStrT312>0.));
delta_RStrT313 = minus(RPoF(21:30),combo_RStr31(3));
delta_RStrT31(3) = min(delta_RStrT313(delta_RStrT313>0.));
delta_RStrT314 = minus(RPoF(21:30),combo_RStr31(4));
delta_RStrT31(4) = min(delta_RStrT314(delta_RStrT314>0.));
disp('Session 3 Rational - Reading duration values: ');
disp((delta_RStrT31)');
%
combo_RStr32 = cat(1,RPGf(3),RPGm(3),RPSf(3),RPSm(3));
disp('Session 3 Relational - Reading onset values: ');
disp(combo_RStr32);
%
delta_RStrT321 = minus(RPoF(21:30),combo_RStr32(1));
delta_RStrT32(1) = min(delta_RStrT321(delta_RStrT321>0.));
delta_RStrT322 = minus(RPoF(21:30),combo_RStr32(2));
delta_RStrT32(2) = min(delta_RStrT322(delta_RStrT322>0.));
delta_RStrT323 = minus(RPoF(21:30),combo_RStr32(3));
delta_RStrT32(3) = min(delta_RStrT323(delta_RStrT323>0.));
delta_RStrT324 = minus(RPoF(21:30),combo_RStr32(4));
delta_RStrT32(4) = min(delta_RStrT324(delta_RStrT324>0.));
disp('Session 3 Relational - Reading duration values: ');
disp((delta_RStrT32)');
%
combo_RStr33 = cat(1,RCon(5:6));
disp('Session 3 Neutral - Reading onset values: ');
disp(combo_RStr33);
%
delta_RStrT331 = minus(RPoF(21:30),combo_RStr33(1));
delta_RStrT33(1) = min(delta_RStrT331(delta_RStrT331>0.));
delta_RStrT332 = minus(RPoF(21:30),combo_RStr33(2));
delta_RStrT33(2) = min(delta_RStrT332(delta_RStrT332>0.));
disp('Session 3 Neutral - Reading duration values: ');
disp((delta_RStrT33)');
%
combo_RStr41 = cat(1,RPJf(4),RPJm(4),RPOf(4),RPOm(4));
disp('Session 4 Rational - Reading onset values: ');
disp(combo_RStr41);
%
delta_RStrT411 = minus(RPoF(31:40),combo_RStr41(1));
delta_RStrT41(1) = min(delta_RStrT411(delta_RStrT411>0.));
delta_RStrT412 = minus(RPoF(31:40),combo_RStr41(2));
delta_RStrT41(2) = min(delta_RStrT412(delta_RStrT412>0.));
delta_RStrT413 = minus(RPoF(31:40),combo_RStr41(3));
delta_RStrT41(3) = min(delta_RStrT413(delta_RStrT413>0.));
delta_RStrT414 = minus(RPoF(31:40),combo_RStr41(4));
delta_RStrT41(4) = min(delta_RStrT414(delta_RStrT414>0.));
disp('Session 4 Rational - Reading duration values: ');
disp((delta_RStrT41)');
%
combo_RStr42 = cat(1,RPGf(4),RPGm(4),RPSf(4),RPSm(4));
disp('Session 4 Relational - Reading onset values: ');
disp(combo_RStr42);
%
delta_RStrT421 = minus(RPoF(31:40),combo_RStr42(1));
delta_RStrT42(1) = min(delta_RStrT421(delta_RStrT421>0.));
delta_RStrT422 = minus(RPoF(31:40),combo_RStr42(2));
delta_RStrT42(2) = min(delta_RStrT422(delta_RStrT422>0.));
delta_RStrT423 = minus(RPoF(31:40),combo_RStr42(3));
delta_RStrT42(3) = min(delta_RStrT423(delta_RStrT423>0.));
delta_RStrT424 = minus(RPoF(31:40),combo_RStr42(4));
delta_RStrT42(4) = min(delta_RStrT424(delta_RStrT424>0.));
disp('Session 4 Relational - Reading duration values: ');
disp((delta_RStrT42)');
%
combo_RStr43 = cat(1,RCon(7:8));
disp('Session 4 Neutral - Reading onset values: ');
disp(combo_RStr43);
%
delta_RStrT431 = minus(RPoF(31:40),combo_RStr43(1));
delta_RStrT43(1) = min(delta_RStrT431(delta_RStrT431>0.));
delta_RStrT432 = minus(RPoF(31:40),combo_RStr43(2));
delta_RStrT43(2) = min(delta_RStrT432(delta_RStrT432>0.));
disp('Session 4 Neutral - Reading duration values: ');
disp((delta_RStrT43)');
%
disp(' ------------------- Finalize Story Reading ----------------------- ');
%
fprintf('\n');
disp(' ------------------- Initialize Story Answering ------------------- ');
%
str_APJf = 'ans_PJf';
idx_APJf = find(~cellfun('isempty',strfind(text,str_APJf))) +1;
APJf = str2double(text(idx_APJf));
%
str_APOf = 'ans_POf';
idx_APOf = find(~cellfun('isempty',strfind(text,str_APOf))) +1;
APOf = str2double(text(idx_APOf));
%
str_APGf = 'ans_PGf';
idx_APGf = find(~cellfun('isempty',strfind(text,str_APGf))) +1;
APGf = str2double(text(idx_APGf));
%
str_APSf = 'ans_PSf';
idx_APSf = find(~cellfun('isempty',strfind(text,str_APSf))) +1;
APSf = str2double(text(idx_APSf));
%
str_APSm = 'ans_PSm';
idx_APSm = find(~cellfun('isempty',strfind(text,str_APSm))) +1;
APSm = str2double(text(idx_APSm));
%
str_ACon = 'ans_Con';
idx_ACon = find(~cellfun('isempty',strfind(text,str_ACon))) +1;
ACon = str2double(text(idx_ACon));
%
str_APGm = 'ans_PGm';
idx_APGm = find(~cellfun('isempty',strfind(text,str_APGm))) +1;
APGm = str2double(text(idx_APGm));
%
str_APOm = 'ans_POm';
idx_APOm = find(~cellfun('isempty',strfind(text,str_APOm))) +1;
APOm = str2double(text(idx_APOm));
%
str_APJm = 'ans_PJm';
idx_APJm = find(~cellfun('isempty',strfind(text,str_APJm))) +1;
APJm = str2double(text(idx_APJm));
%
str_PreF = 'pre_fix';
idx_PreF = find(~cellfun('isempty',strfind(text,str_PreF))) +1;
X = str2double(text(idx_PreF));
APrF = X(X>1.);
%
str_EndF = '_end';
idx_EndF = find(~cellfun('isempty',strfind(text,str_EndF))) +1;
AEdF = str2double(text(idx_EndF));
%
combo_AFinT1 = APrF(1:9);
combo_AFinT1(end+1) = AEdF(1);
combo_AFinT2 = APrF(10:18);
combo_AFinT2(end+1) = AEdF(2);
combo_AFinT3 = APrF(19:27);
combo_AFinT3(end+1) = AEdF(3);
combo_AFinT4 = APrF(28:36);
combo_AFinT4(end+1) = AEdF(4);
%
combo_AStr1 = cat(1,APJf(1:3),APOf(1:3),APGf(1:3),APSf(1:3),APJm(1:3),APOm(1:3),APGm(1:3),APSm(1:3),ACon(1:6));
rcombo_AStr1 = sort(combo_AStr1);
disp('Session 1 - Answering onset values: ');
disp(rcombo_AStr1);
%
combo_AStrT1 = cat(1,rcombo_AStr1,combo_AFinT1);
rcombo_AStrT1 = sort(combo_AStrT1);
delta_AStrT1 = diff(rcombo_AStrT1);
delta_AStrT1(4:4:end) = [];
disp('Session 1 - Answering duration values: ');
disp(delta_AStrT1);
%
disp('Session 1 - Answering response values: ');
disp(M2R(1:30));
%
combo_AStr2 = cat(1,APJf(4:6),APOf(4:6),APGf(4:6),APSf(4:6),APJm(4:6),APOm(4:6),APGm(4:6),APSm(4:6),ACon(7:12));
rcombo_AStr2 = sort(combo_AStr2);
disp('Session 2 - Answering onset values: ');
disp(rcombo_AStr2);
%
combo_AStrT2 = cat(1,rcombo_AStr2,combo_AFinT2);
rcombo_AStrT2 = sort(combo_AStrT2);
delta_AStrT2 = diff(rcombo_AStrT2);
delta_AStrT2(4:4:end) = [];
disp('Session 2 - Answering duration values: ');
disp(delta_AStrT2);
%
disp('Session 2 - Answering response values: ');
disp(M2R(31:60));
%
combo_AStr3 = cat(1,APJf(7:9),APOf(7:9),APGf(7:9),APSf(7:9),APJm(7:9),APOm(7:9),APGm(7:9),APSm(7:9),ACon(13:18));
rcombo_AStr3 = sort(combo_AStr3);
disp('Session 3 - Answering onset values: ');
disp(rcombo_AStr3);
%
combo_AStrT3 = cat(1,rcombo_AStr3,combo_AFinT3);
rcombo_AStrT3 = sort(combo_AStrT3);
delta_AStrT3 = diff(rcombo_AStrT3);
delta_AStrT3(4:4:end) = [];
disp('Session 3 - Answering duration values: ');
disp(delta_AStrT3);
%
disp('Session 3 - Answering response values: ');
disp(M2R(61:90));
%
combo_AStr4 = cat(1,APJf(10:12),APOf(10:12),APGf(10:12),APSf(10:12),APJm(10:12),APOm(10:12),APGm(10:12),APSm(10:12),ACon(19:24));
rcombo_AStr4 = sort(combo_AStr4);
disp('Session 4 - Answering onset values: ');
disp(rcombo_AStr4);
%
combo_AStrT4 = cat(1,rcombo_AStr4,combo_AFinT4);
rcombo_AStrT4 = sort(combo_AStrT4);
delta_AStrT4 = diff(rcombo_AStrT4);
delta_AStrT4(4:4:end) = [];
disp('Session 4 - Answering duration values: ');
disp(delta_AStrT4);
%
disp('Session 4 - Answering response values: ');
disp(M2R(91:120));
%
disp(' -------------------- Finalize Story Answering -------------------- ');
disp(' ------------------------------------------------------------------ ');
fprintf('\n');

%--------------------------------------------------------------------------
% Loading timing information from behavior data in SPM12 to build
% design matrices
%--------------------------------------------------------------------------

names=cell(1,16);
onsets=cell(1,16);
durations=cell(1,16);

names = {'RationalS11', 'RationalS21', 'RationalS31', ...
         'RationalS41', 'RelationalS12', 'RelationalS22', 'RelationalS32', ...
         'RelationalS42', 'NeutralS13', 'NeutralS23', 'NeutralS33', ...
         'NeutralS43', 'AnsweringS1', 'AnsweringS2', 'AnsweringS3', 'AnsweringS4'};

onsets = {combo_RStr11, combo_RStr21, combo_RStr31, combo_RStr41, ...
          combo_RStr12, combo_RStr22, combo_RStr32, combo_RStr42, ...
          combo_RStr13, combo_RStr23, combo_RStr33, combo_RStr43, ...
          rcombo_AStr1, rcombo_AStr2, rcombo_AStr3, rcombo_AStr4};

durations = {delta_RStrT11, delta_RStrT21, delta_RStrT31, delta_RStrT41, ...
             delta_RStrT12, delta_RStrT22, delta_RStrT32, delta_RStrT42, ...
             delta_RStrT13, delta_RStrT23, delta_RStrT33, delta_RStrT43, ...
             delta_AStrT1, delta_AStrT2, delta_AStrT3, delta_AStrT4};

%--------------------------------------------------------------------------
% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
   
cd(mriFldr)

% create folders 
if ~exist('EPI1', 'dir'); mkdir EPI1; end
if ~exist('EPI2', 'dir'); mkdir EPI2; end
if ~exist('EPI3', 'dir'); mkdir EPI3; end
if ~exist('EPI4', 'dir'); mkdir EPI4; end
if ~exist('RationalRelational', 'dir'); mkdir RationalRelational; end
if ~exist('OtherFiles', 'dir'); mkdir OtherFiles; end
m1Fldr = [mriFldr '\EPI1'];
m2Fldr = [mriFldr '\EPI2'];
m3Fldr = [mriFldr '\EPI3'];
m4Fldr = [mriFldr '\EPI4'];
m5Fldr = [mriFldr '\OtherFiles'];
m6Fldr = [mriFldr '\RationalRelational'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASSICAL STATISTICAL ANALYSIS (CATEGORICAL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear matlabbatch

%--------------------------------------------------------------------------
% Output Directory
%--------------------------------------------------------------------------
%matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
%matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'categorical';

%--------------------------------------------------------------------------
% Model Specification
%--------------------------------------------------------------------------

cd(mriFldr)

mList1=dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(1)) '-*-*-01.nii']));
mList1=mList1(1:nFiles(1));
    
mList2=dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(2)) '-*-*-01.nii']));
mList2=mList2(1:nFiles(2));

mList3=dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(3)) '-*-*-01.nii']));
mList3=mList3(1:nFiles(3));
    
mList4=dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(4)) '-*-*-01.nii']));
mList4=mList4(1:nFiles(4));

for i=1:length({mList1.name})
    mList1(i).name=[mriFldr '\' mList1(i).name ',1'];
end

for i=1:length({mList2.name})
    mList2(i).name=[mriFldr '\' mList2(i).name ',1'];
end
    
for i=1:length({mList3.name})
    mList3(i).name=[mriFldr '\' mList3(i).name ',1'];
end
    
for i=1:length({mList4.name})
    mList4(i).name=[mriFldr '\' mList4(i).name ',1'];
end

matlabbatch{1}.spm.stats.fmri_spec.dir = {mriFldr};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).name = names{1};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).onset = onsets{1};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(1).duration = durations{1};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {reg1name};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).name = names{2};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).onset = onsets{2};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(1).duration = durations{2};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {reg2name};

matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).name = names{3};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).onset = onsets{3};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(1).duration = durations{3};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {reg3name};

matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).name = names{4};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).onset = onsets{4};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(1).duration = durations{4};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = {reg4name};

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).name = names{5};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).onset = onsets{5};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(2).duration = durations{5};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = names{6};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = onsets{6};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = durations{6};

matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = names{7};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = onsets{7};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = durations{7};

matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).name = names{8};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = onsets{8};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).duration = durations{8};

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = names{5};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = onsets{5};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = durations{5};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).name = names{6};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).onset = onsets{6};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(2).duration = durations{6};

matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).name = names{7};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).onset = onsets{7};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(2).duration = durations{7};

matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).name = names{8};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).onset = onsets{8};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(2).duration = durations{8};

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).name = names{9};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).onset = onsets{9};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(3).duration = durations{9};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).name = names{10};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).onset = onsets{10};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(3).duration = durations{10};

matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).name = names{11};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).onset = onsets{11};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(3).duration = durations{11};

matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).name = names{12};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).onset = onsets{12};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(3).duration = durations{12};

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).name = names{13};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).onset = onsets{13};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(4).duration = durations{13};

matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).name = names{13};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).onset = onsets{13};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond(4).duration = durations{13};

matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).name = names{14};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).onset = onsets{14};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond(4).duration = durations{14};

matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).name = names{15};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).onset = onsets{15};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond(4).duration = durations{15};

spm_jobman('run',matlabbatch);

disp('Model Specification done !')

%--------------------------------------------------------------------------
% Model Expectation
%--------------------------------------------------------------------------

matlabbatch{2}.spm.stats.fmri_est.spmmat = { [ mriFldr '\SPM.mat' ] };
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);

disp('Model Expectation done !')

%--------------------------------------------------------------------------
% Inference
%--------------------------------------------------------------------------

matlabbatch{3}.spm.stats.con.spmmat = { [ mriFldr '\SPM.mat' ] };
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Rational-Neutral';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 -1 0 1 0 -1 0 1 0 -1 0 1 0 -1 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Relational-Neutral';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 -1 0 0 1 -1 0 0 1 -1 0 0 1 -1 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Rational-Relational';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [1 -1 0 0 1 -1 0 0 1 -1 0 0 1 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

spm_jobman('run',matlabbatch);

disp('Model Inference done !')

%--------------------------------------------------------------------------
% After first-level analysis 
%--------------------------------------------------------------------------

cd(mriFldr)

% delete useless files
% move useful files

dfile31Pattern = dir(fullfile(mriFldr, ['wraf*-' sprintf('%04d',epis(1)) '-*-*-01.nii'])); 
dfile32Pattern = dir(fullfile(mriFldr, ['wraf*-' sprintf('%04d',epis(2)) '-*-*-01.nii'])); 
dfile33Pattern = dir(fullfile(mriFldr, ['wraf*-' sprintf('%04d',epis(3)) '-*-*-01.nii'])); 
dfile34Pattern = dir(fullfile(mriFldr, ['wraf*-' sprintf('%04d',epis(4)) '-*-*-01.nii'])); 
dfile41Pattern = dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(1)) '-*-*-01.nii'])); 
dfile42Pattern = dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(2)) '-*-*-01.nii'])); 
dfile43Pattern = dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(3)) '-*-*-01.nii'])); 
dfile44Pattern = dir(fullfile(mriFldr, ['swraf*-' sprintf('%04d',epis(4)) '-*-*-01.nii']));
dfile51Pattern = dir(fullfile(mriFldr, ['f*-' sprintf('%04d',epis(1)) '-*-*-01.nii'])); 
dfile52Pattern = dir(fullfile(mriFldr, ['f*-' sprintf('%04d',epis(2)) '-*-*-01.nii'])); 
dfile53Pattern = dir(fullfile(mriFldr, ['f*-' sprintf('%04d',epis(3)) '-*-*-01.nii'])); 
dfile54Pattern = dir(fullfile(mriFldr, ['f*-' sprintf('%04d',epis(4)) '-*-*-01.nii']));
dtxt1Pattern = dir(fullfile(mriFldr, ['rp_' label '-' sprintf('%04d',epis(1)) '-*-*-01.txt']));
dtxt2Pattern = dir(fullfile(mriFldr, ['rp_' label '-' sprintf('%04d',epis(2)) '-*-*-01.txt']));
dtxt3Pattern = dir(fullfile(mriFldr, ['rp_' label '-' sprintf('%04d',epis(3)) '-*-*-01.txt']));
dtxt4Pattern = dir(fullfile(mriFldr, ['rp_' label '-' sprintf('%04d',epis(4)) '-*-*-01.txt']));
dmatPattern = dir(fullfile(mriFldr, 'SPM.mat'));
dsumPattern = dir(fullfile(mriFldr, 'spm_*.ps'));
dwegtPattern = dir(fullfile(mriFldr, 'beta_00*.nii'));
dspm1Pattern = dir(fullfile(mriFldr, 'spmT_0001.nii'));
dspm2Pattern = dir(fullfile(mriFldr, 'spmT_0002.nii'));
dspm3Pattern = dir(fullfile(mriFldr, 'spmT_0003.nii'));
dspm4Pattern = dir(fullfile(mriFldr, 'spmT_0004.nii'));
dcon1Pattern = dir(fullfile(mriFldr, 'con_0001.nii'));
dcon2Pattern = dir(fullfile(mriFldr, 'con_0002.nii'));
dcon3Pattern = dir(fullfile(mriFldr, 'con_0003.nii'));
dcon4Pattern = dir(fullfile(mriFldr, 'con_0004.nii'));

if isdir(mriFldr)
    for r=1:numel(runs)
        epi=epis(r);    
        dfile1Pattern = dir(fullfile(mriFldr, ['af*-' sprintf('%04d',epi) '-*-*-01.nii'])); 
        dfile2Pattern = dir(fullfile(mriFldr, ['raf*-' sprintf('%04d',epi) '-*-*-01.nii']));  
        
        for k = 1 : length(dfile1Pattern)
            if exist(fullfile(mriFldr, dfile1Pattern(k).name), 'file')
                % delete files not used 4ever 
                delete(fullfile(mriFldr, dfile1Pattern(k).name));
                fprintf(1, 'Now removing %s done !\n', dfile1Pattern(k).name);
            end     
        end
        for k = 1 : length(dfile2Pattern)
            if exist(fullfile(mriFldr, dfile2Pattern(k).name), 'file')
                % delete files not used 4ever 
                delete(fullfile(mriFldr, dfile2Pattern(k).name));
                fprintf(1, 'Now removing %s done !\n', dfile2Pattern(k).name);
            end
        end
    end
     
    for k = 1 : length(dfile31Pattern)
        if exist(fullfile(mriFldr, dfile31Pattern(k).name), 'file')
            % move files to EPI1 
            copyfile(fullfile(mriFldr, dfile31Pattern(k).name), ...
                     m1Fldr);
            fprintf(1, 'Now copying %s to EPI1 done !\n', dfile31Pattern(k).name);
            delete(fullfile(mriFldr, dfile31Pattern(k).name));
        end
    end
    for k = 1 : length(dfile32Pattern)
        if exist(fullfile(mriFldr, dfile32Pattern(k).name), 'file')
            % move files to EPI2 
            copyfile(fullfile(mriFldr, dfile32Pattern(k).name), ...
                     m2Fldr);
            fprintf(1, 'Now copying %s to EPI2 done !\n', dfile32Pattern(k).name);
            delete(fullfile(mriFldr, dfile32Pattern(k).name));
        end
    end
    for k = 1 : length(dfile33Pattern)
        if exist(fullfile(mriFldr, dfile33Pattern(k).name), 'file')
            % move files to EPI3 
            copyfile(fullfile(mriFldr, dfile33Pattern(k).name), ...
                     m3Fldr);
            fprintf(1, 'Now copying %s to EPI3 done !\n', dfile33Pattern(k).name);
            delete(fullfile(mriFldr, dfile33Pattern(k).name));
        end
    end
    for k = 1 : length(dfile34Pattern)
        if exist(fullfile(mriFldr, dfile34Pattern(k).name), 'file')
            % move files to EPI4 
            copyfile(fullfile(mriFldr, dfile34Pattern(k).name), ...
                     m4Fldr);
            fprintf(1, 'Now copying %s to EPI4 done !\n', dfile34Pattern(k).name);
            delete(fullfile(mriFldr, dfile34Pattern(k).name));
        end
    end
    for k = 1 : length(dfile41Pattern)
        if exist(fullfile(mriFldr, dfile41Pattern(k).name), 'file')
            % move files to EPI1 
            copyfile(fullfile(mriFldr, dfile41Pattern(k).name), ...
                     m1Fldr);
            fprintf(1, 'Now copying %s to EPI1 done !\n', dfile41Pattern(k).name);
            delete(fullfile(mriFldr, dfile41Pattern(k).name));
        end
    end
    for k = 1 : length(dfile42Pattern)
        if exist(fullfile(mriFldr, dfile42Pattern(k).name), 'file')
            % move files to EPI2 
            copyfile(fullfile(mriFldr, dfile42Pattern(k).name), ...
                     m2Fldr);
            fprintf(1, 'Now copying %s to EPI2 done !\n', dfile42Pattern(k).name);
            delete(fullfile(mriFldr, dfile42Pattern(k).name));
        end
    end
    for k = 1 : length(dfile43Pattern)
        if exist(fullfile(mriFldr, dfile43Pattern(k).name), 'file')
            % move files to EPI3 
            copyfile(fullfile(mriFldr, dfile43Pattern(k).name), ...
                     m3Fldr);
            fprintf(1, 'Now copying %s to EPI3 done !\n', dfile43Pattern(k).name);
            delete(fullfile(mriFldr, dfile43Pattern(k).name));
        end
    end
    for k = 1 : length(dfile44Pattern)
        if exist(fullfile(mriFldr, dfile44Pattern(k).name), 'file')
            % move files to EPI4 
            copyfile(fullfile(mriFldr, dfile44Pattern(k).name), ...
                     m4Fldr);
            fprintf(1, 'Now copying %s to EPI4 done !\n', dfile44Pattern(k).name);
            delete(fullfile(mriFldr, dfile44Pattern(k).name));
        end
    end
    
    disp('come here a');
    for k = 1 : length(dfile51Pattern)
        if exist(fullfile(mriFldr, dfile51Pattern(k).name), 'file')
            % move files to EPI1 
            copyfile(fullfile(mriFldr, dfile51Pattern(k).name), ...
                     m1Fldr);
            fprintf(1, 'Now copying %s to EPI1 done !\n', dfile51Pattern(k).name);
            delete(fullfile(mriFldr, dfile51Pattern(k).name));
        end
    end
    disp('come here b');
    for k = 1 : length(dfile52Pattern)
        if exist(fullfile(mriFldr, dfile52Pattern(k).name), 'file')
            % move files to EPI2 
            copyfile(fullfile(mriFldr, dfile52Pattern(k).name), ...
                     m2Fldr);
            fprintf(1, 'Now copying %s to EPI2 done !\n', dfile52Pattern(k).name);
            delete(fullfile(mriFldr, dfile52Pattern(k).name));
        end
    end
    disp('come here c');
    for k = 1 : length(dfile53Pattern)
        if exist(fullfile(mriFldr, dfile53Pattern(k).name), 'file')
            % move files to EPI3 
            copyfile(fullfile(mriFldr, dfile53Pattern(k).name), ...
                     m3Fldr);
            fprintf(1, 'Now copying %s to EPI3 done !\n', dfile53Pattern(k).name);
            delete(fullfile(mriFldr, dfile53Pattern(k).name));
        end
    end
    disp('come here d');
    for k = 1 : length(dfile54Pattern)
        if exist(fullfile(mriFldr, dfile54Pattern(k).name), 'file')
            % move files to EPI4 
            copyfile(fullfile(mriFldr, dfile54Pattern(k).name), ...
                     m4Fldr);
            fprintf(1, 'Now copying %s to EPI4 done !\n', dfile54Pattern(k).name);
            delete(fullfile(mriFldr, dfile54Pattern(k).name));
        end
    end
    dfile55Pattern = dir(fullfile(mriFldr, ['f*-*-*-*-01.nii']));
    disp('come here e');
    for k = 1 : length(dfile55Pattern)
        if exist(fullfile(mriFldr, dfile55Pattern(k).name), 'file')
            % move files to OtherFiles 
            copyfile(fullfile(mriFldr, dfile55Pattern(k).name), ...
                     m5Fldr);
            fprintf(1, 'Now copying %s to OtherFiles done !\n', dfile55Pattern(k).name);
            delete(fullfile(mriFldr, dfile55Pattern(k).name));
        end
    end
    
    disp('come here f1');
    for k = 1 : length(dtxt1Pattern)
        if exist(fullfile(mriFldr, dtxt1Pattern(k).name), 'file')
            % move files to EPI1 
            copyfile(fullfile(mriFldr, dtxt1Pattern(k).name), m1Fldr);
            fprintf(1, 'Now copying %s to EPI1 done !\n', dtxt1Pattern(k).name)
            delete(fullfile(mriFldr, dtxt1Pattern(k).name));
        end
    end
    disp('come here f2');
    for k = 1 : length(dtxt2Pattern)
        if exist(fullfile(mriFldr, dtxt2Pattern(k).name), 'file')
            % move files to EPI2 
            copyfile(fullfile(mriFldr, dtxt2Pattern(k).name), m2Fldr);
            fprintf(1, 'Now copying %s to EPI2 done !\n', dtxt2Pattern(k).name);
            delete(fullfile(mriFldr, dtxt2Pattern(k).name));
        end
    end
    disp('come here f3');
    for k = 1 : length(dtxt3Pattern)
        if exist(fullfile(mriFldr, dtxt3Pattern(k).name), 'file')
            % move files to EPI3 
            copyfile(fullfile(mriFldr, dtxt3Pattern(k).name), m3Fldr);
            fprintf(1, 'Now copying %s to EPI3 done !\n', dtxt3Pattern(k).name);
            delete(fullfile(mriFldr, dtxt3Pattern(k).name));
        end
    end
    disp('come here f4');
    for k = 1 : length(dtxt4Pattern)
        if exist(fullfile(mriFldr, dtxt4Pattern(k).name), 'file')
            % move files to EPI4 
            copyfile(fullfile(mriFldr, dtxt4Pattern(k).name), m4Fldr);
            fprintf(1, 'Now copying %s to EPI4 done !\n', dtxt4Pattern(k).name);
            delete(fullfile(mriFldr, dtxt4Pattern(k).name));
        end
    end
    disp('come here g1');
    for k = 1 : length(dmatPattern)
        if exist(fullfile(mriFldr, dmatPattern(k).name), 'file')
            % move files to RationalRelational 
            copyfile(fullfile(mriFldr, dmatPattern(k).name), m6Fldr);
            fprintf(1, 'Now copying %s to RationalRelational done !\n', dmatPattern(k).name);
            delete(fullfile(mriFldr, dmatPattern(k).name));
        end
    end
    disp('come here g2');
    for k = 1 : length(dsumPattern)
        if exist(fullfile(mriFldr, dsumPattern(k).name), 'file')
            % move files to RationalRelational 
            copyfile(fullfile(mriFldr, dsumPattern(k).name), m6Fldr);
            fprintf(1, 'Now copying %s to RationalRelational done !\n', dsumPattern(k).name);
            delete(fullfile(mriFldr, dsumPattern(k).name));
        end
    end
    disp('come here g3');
    for k = 1 : length(dwegtPattern)
        if exist(fullfile(mriFldr, dwegtPattern(k).name), 'file')
            % move files to RationalRelational 
            copyfile(fullfile(mriFldr, dwegtPattern(k).name), m6Fldr);
            fprintf(1, 'Now copying %s to RationalRelational done !\n', dwegtPattern(k).name);
            delete(fullfile(mriFldr, dwegtPattern(k).name));
        end
    end
    disp('come here g4');
    for k = 1 : length(dspm1Pattern)
        if exist(fullfile(mriFldr, dspm1Pattern(k).name), 'file')
            % move files to EPI1 
            copyfile(fullfile(mriFldr, dspm1Pattern(k).name), m1Fldr);
            fprintf(1, 'Now copying %s to EPI1 done !\n', dspm1Pattern(k).name)
            delete(fullfile(mriFldr, dspm1Pattern(k).name));
        end
    end
    disp('come here h1');
    for k = 1 : length(dspm2Pattern)
        if exist(fullfile(mriFldr, dspm2Pattern(k).name), 'file')
            % move files to EPI2 
            copyfile(fullfile(mriFldr, dspm2Pattern(k).name), m2Fldr);
            fprintf(1, 'Now copying %s to EPI2 done !\n', dspm2Pattern(k).name);
            delete(fullfile(mriFldr, dspm2Pattern(k).name));
        end
    end
    disp('come here h2');
    for k = 1 : length(dspm3Pattern)
        if exist(fullfile(mriFldr, dspm3Pattern(k).name), 'file')
            % move files to EPI3 
            copyfile(fullfile(mriFldr, dspm3Pattern(k).name), m3Fldr);
            fprintf(1, 'Now copying %s to EPI3 done !\n', dspm3Pattern(k).name);
            delete(fullfile(mriFldr, dspm3Pattern(k).name));
        end
    end
    disp('come here h3');
    for k = 1 : length(dspm4Pattern)
        if exist(fullfile(mriFldr, dspm4Pattern(k).name), 'file')
            % move files to EPI4 
            copyfile(fullfile(mriFldr, dspm4Pattern(k).name), m4Fldr);
            fprintf(1, 'Now copying %s to EPI4 done !\n', dspm4Pattern(k).name);
            delete(fullfile(mriFldr, dspm4Pattern(k).name));
        end
    end
    disp('come here h4');
    for k = 1 : length(dcon1Pattern)
        if exist(fullfile(mriFldr, dcon1Pattern(k).name), 'file')
            % move files to EPI1 
            copyfile(fullfile(mriFldr, dcon1Pattern(k).name), m1Fldr);
            fprintf(1, 'Now copying %s to EPI1 done !\n', dcon1Pattern(k).name)
            delete(fullfile(mriFldr, dcon1Pattern(k).name));
        end
    end
    disp('come here m1');
    for k = 1 : length(dcon2Pattern)
        if exist(fullfile(mriFldr, dcon2Pattern(k).name), 'file')
            % move files to EPI2 
            copyfile(fullfile(mriFldr, dcon2Pattern(k).name), m2Fldr);
            fprintf(1, 'Now copying %s to EPI2 done !\n', dcon2Pattern(k).name);
            delete(fullfile(mriFldr, dcon2Pattern(k).name));
        end
    end
    disp('come here m2');
    for k = 1 : length(dcon3Pattern)
        if exist(fullfile(mriFldr, dcon3Pattern(k).name), 'file')
            % move files to EPI3 
            copyfile(fullfile(mriFldr, dcon3Pattern(k).name), m3Fldr);
            fprintf(1, 'Now copying %s to EPI3 done !\n', dcon3Pattern(k).name);
            delete(fullfile(mriFldr, dcon3Pattern(k).name));
        end
    end
    disp('come here m3');
    for k = 1 : length(dcon4Pattern)
        if exist(fullfile(mriFldr, dcon4Pattern(k).name), 'file')
            % move files to EPI4 
            copyfile(fullfile(mriFldr, dcon4Pattern(k).name), m4Fldr);
            fprintf(1, 'Now copying %s to EPI4 done !\n', dcon4Pattern(k).name);
            delete(fullfile(mriFldr, dcon4Pattern(k).name));
        end
    end
    disp('come here m4');
end