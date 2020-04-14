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
mriSubj='171101CAC01';                                          % name of subject (change from analyzers required)
fbname='D:\025_2017_11_01_1511.txt';                            % name of behavior data file (change from analyzers required)
fb2name='D:\025_2017_11_01_1511.csv';                           % name of behavior data file (change from analyzers required)
mriFldr='D:\171101CAC01_rawEPI';                                % rawEPI file folder (change from analyzers required)
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
%disp( [str_RPJf,' has values: '] );
%disp(RPJf);
%
str_RPOf = 'read_POf';
idx_RPOf = find(~cellfun('isempty',strfind(text,str_RPOf))) +1;
RPOf = str2double(text(idx_RPOf));
%disp( [str_RPOf,' has values: '] );
%disp(RPOf);
%
str_RPGf = 'read_PGf';
idx_RPGf = find(~cellfun('isempty',strfind(text,str_RPGf))) +1;
RPGf = str2double(text(idx_RPGf));
%disp( [str_RPGf,' has values: '] );
%disp(RPGf);
%
str_RPSf = 'read_PSf';
idx_RPSf = find(~cellfun('isempty',strfind(text,str_RPSf))) +1;
RPSf = str2double(text(idx_RPSf));
%disp( [str_RPSf,' has values: '] );
%disp(RPSf);
%
str_RPSm = 'read_PSm';
idx_RPSm = find(~cellfun('isempty',strfind(text,str_RPSm))) +1;
RPSm = str2double(text(idx_RPSm));
%disp( [str_RPSm,' has values: '] );
%disp(RPSm);
%
str_RCon = 'read_Con';
idx_RCon = find(~cellfun('isempty',strfind(text,str_RCon))) +1;
RCon = str2double(text(idx_RCon));
%disp( [str_RCon,' has values: '] );
%disp(RCon);
%
str_RPGm = 'read_PGm';
idx_RPGm = find(~cellfun('isempty',strfind(text,str_RPGm))) +1;
RPGm = str2double(text(idx_RPGm));
%disp( [str_RPGm,' has values: '] );
%disp(RPGm);
%
str_RPOm = 'read_POm';
idx_RPOm = find(~cellfun('isempty',strfind(text,str_RPOm))) +1;
RPOm = str2double(text(idx_RPOm));
%disp( [str_RPOm,' has values: '] );
%disp(RPOm);
%
str_RPJm = 'read_PJm';
idx_RPJm = find(~cellfun('isempty',strfind(text,str_RPJm))) +1;
RPJm = str2double(text(idx_RPJm));
%disp( [str_RPJm,' has values: '] );
%disp(RPJm);
%
str_PostF = 'post_fix';
idx_PostF = find(~cellfun('isempty',strfind(text,str_PostF))) +1;
RPoF = str2double(text(idx_PostF));
%disp( [str_PostF,' has values: '] );
%disp(RPoF);
%
combo_RStr1 = cat(1,RPJf(1),RPOf(1),RPGf(1),RPSf(1),RPJm(1),RPOm(1),RPGm(1),RPSm(1),RCon(1:2));
rcombo_RStr1 = sort(combo_RStr1);
disp('Session 1 - Reading onset values: ');
disp(rcombo_RStr1);
%
delta_RStr1 = minus(RPoF(1:10),rcombo_RStr1);
disp('Session 1 - Reading duration values: ');
disp(delta_RStr1);
%
disp('Session 1 - Reading emotion values: ');
disp(M2R1(1:10));
%
combo_RStr2 = cat(1,RPJf(2),RPOf(2),RPGf(2),RPSf(2),RPJm(2),RPOm(2),RPGm(2),RPSm(2),RCon(3:4));
rcombo_RStr2 = sort(combo_RStr2);
disp('Session 2 - Reading onset values: ');
disp(rcombo_RStr2);
%
delta_RStr2 = minus(RPoF(11:20),rcombo_RStr2);
disp('Session 2 - Reading duration values: ');
disp(delta_RStr2);
%
disp('Session 2 - Reading emotion values: ');
disp(M2R1(11:20));
%
combo_RStr3 = cat(1,RPJf(3),RPOf(3),RPGf(3),RPSf(3),RPJm(3),RPOm(3),RPGm(3),RPSm(3),RCon(5:6));
rcombo_RStr3 = sort(combo_RStr3);
disp('Session 3 - Reading onset values: ');
disp(rcombo_RStr3);
%
delta_RStr3 = minus(RPoF(21:30),rcombo_RStr3);
disp('Session 3 - Reading duration values: ');
disp(delta_RStr3);
%
disp('Session 3 - Reading emotion values: ');
disp(M2R1(21:30));
%
combo_RStr4 = cat(1,RPJf(4),RPOf(4),RPGf(4),RPSf(4),RPJm(4),RPOm(4),RPGm(4),RPSm(4),RCon(7:8));
rcombo_RStr4 = sort(combo_RStr4);
disp('Session 4 - Reading onset values: ');
disp(rcombo_RStr4);
%
delta_RStr4 = minus(RPoF(31:40),rcombo_RStr4);
disp('Session 4 - Reading duration values: ');
disp(delta_RStr4);
%
disp('Session 4 - Reading emotion values: ');
disp(M2R1(31:40));
%
disp(' ------------------- Finalize Story Reading ----------------------- ');
%
fprintf('\n');
disp(' ------------------- Initialize Story Answering ------------------- ');
%
str_APJf = 'ans_PJf';
idx_APJf = find(~cellfun('isempty',strfind(text,str_APJf))) +1;
APJf = str2double(text(idx_APJf));
%disp( [str_APJf,' has values: '] );
%disp(APJf);
%
str_APOf = 'ans_POf';
idx_APOf = find(~cellfun('isempty',strfind(text,str_APOf))) +1;
APOf = str2double(text(idx_APOf));
%disp( [str_APOf,' has values: '] );
%disp(APOf);
%
str_APGf = 'ans_PGf';
idx_APGf = find(~cellfun('isempty',strfind(text,str_APGf))) +1;
APGf = str2double(text(idx_APGf));
%disp( [str_APGf,' has values: '] );
%disp(APGf);
%
str_APSf = 'ans_PSf';
idx_APSf = find(~cellfun('isempty',strfind(text,str_APSf))) +1;
APSf = str2double(text(idx_APSf));
%disp( [str_APSf,' has values: '] );
%disp(APSf);
%
str_APSm = 'ans_PSm';
idx_APSm = find(~cellfun('isempty',strfind(text,str_APSm))) +1;
APSm = str2double(text(idx_APSm));
%disp( [str_APSm,' has values: '] );
%disp(APSm);
%
str_ACon = 'ans_Con';
idx_ACon = find(~cellfun('isempty',strfind(text,str_ACon))) +1;
ACon = str2double(text(idx_ACon));
%disp( [str_ACon,' has values: '] );
%disp(ACon);
%
str_APGm = 'ans_PGm';
idx_APGm = find(~cellfun('isempty',strfind(text,str_APGm))) +1;
APGm = str2double(text(idx_APGm));
%disp( [str_APGm,' has values: '] );
%disp(APGm);
%
str_APOm = 'ans_POm';
idx_APOm = find(~cellfun('isempty',strfind(text,str_APOm))) +1;
APOm = str2double(text(idx_APOm));
%disp( [str_APOm,' has values: '] );
%disp(APOm);
%
str_APJm = 'ans_PJm';
idx_APJm = find(~cellfun('isempty',strfind(text,str_APJm))) +1;
APJm = str2double(text(idx_APJm));
%disp( [str_APJm,' has values: '] );
%disp(APJm);
%
str_PreF = 'pre_fix';
idx_PreF = find(~cellfun('isempty',strfind(text,str_PreF))) +1;
X = str2double(text(idx_PreF));
APrF = X(X>1.);
%disp( [str_PreF,' has values: '] );
%disp(APrF);
%
str_EndF = '_end';
idx_EndF = find(~cellfun('isempty',strfind(text,str_EndF))) +1;
AEdF = str2double(text(idx_EndF));
%disp( [str_EndF,' has values: '] );
%disp(AEdF);
%
combo_AFinT1 = APrF(1:9);
combo_AFinT1(end+1) = AEdF(1);
combo_AFinT2 = APrF(10:18);
combo_AFinT2(end+1) = AEdF(2);
combo_AFinT3 = APrF(19:27);
combo_AFinT3(end+1) = AEdF(3);
combo_AFinT4 = APrF(28:36);
combo_AFinT4(end+1) = AEdF(4);
%combo_AFin = cat(1,combo_AFinT1,combo_AFinT2,combo_AFinT3,combo_AFinT4);
%disp(' End time has values: ');
%disp(combo_AFin);
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
