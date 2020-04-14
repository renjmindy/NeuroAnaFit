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
mriSubj='171101CAC02';                                          % name of subject (change from analyzers required)
fbname='C:\Users\Owner\Downloads\026_2017_11_01_1415.txt';      % name of behavior data file (change from analyzers required)
mriFldr='D:\171101CAC02_rawEPI';                                % rawEPI file folder (change from analyzers required)
script_fldr='C:\Users\Owner\Documents\MATLAB\spm12';            % SPM12 installation folder (change from analyzers required)
preproc_fldr=[ script_fldr '\neuroFitPreproc' ];                % SPM12 batch script location (change from analyzers required)
addpath(preproc_fldr);

%--------------------------------------------------------------------------
% Loading Behavior Data
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
disp( [str_RPJf,' has values: '] );
disp(RPJf);
%
str_RPOf = 'read_POf';
idx_RPOf = find(~cellfun('isempty',strfind(text,str_RPOf))) +1;
RPOf = str2double(text(idx_RPOf));
disp( [str_RPOf,' has values: '] );
disp(RPOf);
%
str_RPGf = 'read_PGf';
idx_RPGf = find(~cellfun('isempty',strfind(text,str_RPGf))) +1;
RPGf = str2double(text(idx_RPGf));
disp( [str_RPGf,' has values: '] );
disp(RPGf);
%
str_RPSf = 'read_PSf';
idx_RPSf = find(~cellfun('isempty',strfind(text,str_RPSf))) +1;
RPSf = str2double(text(idx_RPSf));
disp( [str_RPSf,' has values: '] );
disp(RPSf);
%
str_RPSm = 'read_PSm';
idx_RPSm = find(~cellfun('isempty',strfind(text,str_RPSm))) +1;
RPSm = str2double(text(idx_RPSm));
disp( [str_RPSm,' has values: '] );
disp(RPSm);
%
str_RCon = 'read_Con';
idx_RCon = find(~cellfun('isempty',strfind(text,str_RCon))) +1;
RCon = str2double(text(idx_RCon));
disp( [str_RCon,' has values: '] );
disp(RCon);
%
str_RPGm = 'read_PGm';
idx_RPGm = find(~cellfun('isempty',strfind(text,str_RPGm))) +1;
RPGm = str2double(text(idx_RPGm));
disp( [str_RPGm,' has values: '] );
disp(RPGm);
%
str_RPOm = 'read_POm';
idx_RPOm = find(~cellfun('isempty',strfind(text,str_RPOm))) +1;
RPOm = str2double(text(idx_RPOm));
disp( [str_RPOm,' has values: '] );
disp(RPOm);
%
str_RPJm = 'read_PJm';
idx_RPJm = find(~cellfun('isempty',strfind(text,str_RPJm))) +1;
RPJm = str2double(text(idx_RPJm));
disp( [str_RPJm,' has values: '] );
disp(RPJm);
%
str_PostF = 'post_fix';
idx_PostF = find(~cellfun('isempty',strfind(text,str_PostF))) +1;
RPoF = str2double(text(idx_PostF));
disp( [str_PostF,' has values: '] );
disp(RPoF);
%
combo_RStr1 = cat(1,RPJf(1),RPOf(1),RPGf(1),RPSf(1),RPSm(1),RCon(1:2),RPGm(1),RPOm(1),RPJm(1));
rcombo_RStr1 = sort(combo_RStr1);
disp('Session 1 - Reading onset values: ');
disp(rcombo_RStr1);
%
combo_RStr2 = cat(1,RPJf(2),RPOf(2),RPGf(2),RPSf(2),RPSm(2),RCon(3:4),RPGm(2),RPOm(2),RPJm(2));
rcombo_RStr2 = sort(combo_RStr2);
disp('Session 2 - Reading onset values: ');
disp(rcombo_RStr2);
%
combo_RStr3 = cat(1,RPJf(3),RPOf(3),RPGf(3),RPSf(3),RPSm(3),RCon(5:6),RPGm(3),RPOm(3),RPJm(3));
rcombo_RStr3 = sort(combo_RStr3);
disp('Session 3 - Reading onset values: ');
disp(rcombo_RStr3);
%
combo_RStr4 = cat(1,RPJf(4),RPOf(4),RPGf(4),RPSf(4),RPSm(4),RCon(7:8),RPGm(4),RPOm(4),RPJm(4));
rcombo_RStr4 = sort(combo_RStr4);
disp('Session 4 - Reading onset values: ');
disp(rcombo_RStr4);
%
combo_RStrT = cat(1,rcombo_RStr1,rcombo_RStr2,rcombo_RStr3,rcombo_RStr4);
delta_RStrT = minus(RPoF,combo_RStrT);
disp('All sessions - Reading duration values: ');
disp(delta_RStrT);
%
delta_RStrT1 = minus(RPoF(1:10),rcombo_RStr1);
disp('Session 1 - Reading duration values: ');
disp(delta_RStrT1);
%
delta_RStrT2 = minus(RPoF(11:20),rcombo_RStr2);
disp('Session 2 - Reading duration values: ');
disp(delta_RStrT2);
%
delta_RStrT3 = minus(RPoF(21:30),rcombo_RStr3);
disp('Session 3 - Reading duration values: ');
disp(delta_RStrT3);
%
delta_RStrT4 = minus(RPoF(31:40),rcombo_RStr4);
disp('Session 4 - Reading duration values: ');
disp(delta_RStrT4);
%
disp(' ------------------- Finalize Story Reading ----------------------- ');
%
fprintf('\n');
disp(' ------------------- Initialize Story Answering ------------------- ');
%
str_APJf = 'ans_PJf';
idx_APJf = find(~cellfun('isempty',strfind(text,str_APJf))) +1;
APJf = str2double(text(idx_APJf));
disp( [str_APJf,' has values: '] );
disp(APJf);
%
str_APOf = 'ans_POf';
idx_APOf = find(~cellfun('isempty',strfind(text,str_APOf))) +1;
APOf = str2double(text(idx_APOf));
disp( [str_APOf,' has values: '] );
disp(APOf);
%
str_APGf = 'ans_PGf';
idx_APGf = find(~cellfun('isempty',strfind(text,str_APGf))) +1;
APGf = str2double(text(idx_APGf));
disp( [str_APGf,' has values: '] );
disp(APGf);
%
str_APSf = 'ans_PSf';
idx_APSf = find(~cellfun('isempty',strfind(text,str_APSf))) +1;
APSf = str2double(text(idx_APSf));
disp( [str_APSf,' has values: '] );
disp(APSf);
%
str_APSm = 'ans_PSm';
idx_APSm = find(~cellfun('isempty',strfind(text,str_APSm))) +1;
APSm = str2double(text(idx_APSm));
disp( [str_APSm,' has values: '] );
disp(APSm);
%
str_ACon = 'ans_Con';
idx_ACon = find(~cellfun('isempty',strfind(text,str_ACon))) +1;
ACon = str2double(text(idx_ACon));
disp( [str_ACon,' has values: '] );
disp(ACon);
%
str_APGm = 'ans_PGm';
idx_APGm = find(~cellfun('isempty',strfind(text,str_APGm))) +1;
APGm = str2double(text(idx_APGm));
disp( [str_APGm,' has values: '] );
disp(APGm);
%
str_APOm = 'ans_POm';
idx_APOm = find(~cellfun('isempty',strfind(text,str_APOm))) +1;
APOm = str2double(text(idx_APOm));
disp( [str_APOm,' has values: '] );
disp(APOm);
%
str_APJm = 'ans_PJm';
idx_APJm = find(~cellfun('isempty',strfind(text,str_APJm))) +1;
APJm = str2double(text(idx_APJm));
disp( [str_APJm,' has values: '] );
disp(APJm);
%
str_PreF = 'pre_fix';
idx_PreF = find(~cellfun('isempty',strfind(text,str_PreF))) +1;
X = str2double(text(idx_PreF));
APrF = X(X>1.);
disp( [str_PreF,' has values: '] );
disp(APrF);
%
str_EndF = '_end';
idx_EndF = find(~cellfun('isempty',strfind(text,str_EndF))) +1;
AEdF = str2double(text(idx_EndF));
disp( [str_EndF,' has values: '] );
disp(AEdF);
%
combo_AStr1 = cat(1,APJf(1),APOf(1),APGf(1),APSf(1),APSm(1),ACon([1 4]),APGm(1),APOm(1),APJm(1));
rcombo_AStr1 = sort(combo_AStr1);
disp('Session 1 - Answering onset values: ');
disp(rcombo_AStr1);
%
combo_AStr2 = cat(1,APJf(4),APOf(4),APGf(4),APSf(4),APSm(4),ACon([7 10]),APGm(4),APOm(4),APJm(4));
rcombo_AStr2 = sort(combo_AStr2);
disp('Session 2 - Answering onset values: ');
disp(rcombo_AStr2);
%
combo_AStr3 = cat(1,APJf(7),APOf(7),APGf(7),APSf(7),APSm(7),ACon([13 16]),APGm(7),APOm(7),APJm(7));
rcombo_AStr3 = sort(combo_AStr3);
disp('Session 3 - Answering onset values: ');
disp(rcombo_AStr3);
%
combo_AStr4 = cat(1,APJf(10),APOf(10),APGf(10),APSf(10),APSm(10),ACon([19 22]),APGm(10),APOm(10),APJm(10));
rcombo_AStr4 = sort(combo_AStr4);
disp('Session 4 - Answering onset values: ');
disp(rcombo_AStr4);
%
combo_AFinT1 = APrF(1:9);
combo_AFinT1(end+1) = AEdF(1);
combo_AFinT2 = APrF(10:18);
combo_AFinT2(end+1) = AEdF(2);
combo_AFinT3 = APrF(19:27);
combo_AFinT3(end+1) = AEdF(3);
combo_AFinT4 = APrF(28:36);
combo_AFinT4(end+1) = AEdF(4);
combo_AFinTt = cat(1,combo_AFinT1,combo_AFinT2,combo_AFinT3,combo_AFinT4);
disp(' End time has values: ');
disp(combo_AFinTt);
%
combo_AStrT = cat(1,rcombo_AStr1,rcombo_AStr2,rcombo_AStr3,rcombo_AStr4);
delta_AStrT = minus(combo_AFinTt,combo_AStrT);
disp('All sessions - Answering duration values: ');
disp(delta_AStrT);
%
delta_AStrT1 = minus(combo_AFinT1,rcombo_AStr1);
disp('Session 1 - Answering duration values: ');
disp(delta_AStrT1);
%
delta_AStrT2 = minus(combo_AFinT2,rcombo_AStr2);
disp('Session 2 - Answering duration values: ');
disp(delta_AStrT2);
%
delta_AStrT3 = minus(combo_AFinT3,rcombo_AStr3);
disp('Session 3 - Answering duration values: ');
disp(delta_AStrT3);
%
delta_AStrT4 = minus(combo_AFinT4,rcombo_AStr4);
disp('Session 4 - Answering duration values: ');
disp(delta_AStrT4);
%
disp(' -------------------- Finalize Story Answering -------------------- ');
disp(' ------------------------------------------------------------------ ');
fprintf('\n');

%--------------------------------------------------------------------------
% Loading timing information from behavior data in SPM12 to build
% design matrices
%--------------------------------------------------------------------------

names=cell(1,8);
onsets=cell(1,8);
durations=cell(1,8);

names = {'ReadingS1', 'ReadingS2', 'ReadingS3', 'ReadingS4', ...
         'AnsweringS1', 'AnsweringS2', 'AnsweringS3', 'AnsweringS4'};

onsets = {rcombo_RStr1, rcombo_RStr2, rcombo_RStr3, rcombo_RStr4, ...
          rcombo_AStr1, rcombo_AStr2, rcombo_AStr3, rcombo_AStr4};

durations = {delta_RStrT1, delta_RStrT2, delta_RStrT3, delta_RStrT4, ...
             delta_AStrT1, delta_AStrT2, delta_AStrT3, delta_AStrT4};

%--------------------------------------------------------------------------
% Initialise SPM
%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPATIAL PREPROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear matlabbatch

%--------------------------------------------------------------------------
% Slice Timing Correction
%--------------------------------------------------------------------------

for r=1:numel(runs) 
    run=runs(r);
    epi=epis(r);
    file=nFiles(r); 
    
    cd(mriFldr)    
    list=dir(['f*-' sprintf('%04d',epi) '-*-*-01.nii']);
    list=list(1:file);
    
    if length({list.name})~=file
        error(['wrong number of files for slice-timing in run' ...
               num2str(run,'%d')]);
        return;
    end
    for i=1:length({list.name})
        list(i).name=[mriFldr '\' list(i).name ',1'];
    end
            
    matlabbatch{1}.spm.temporal.st.scans{1,r}={list.name}';
end
                                        
matlabbatch{1}.spm.temporal.st.nslices = nSlices;
matlabbatch{1}.spm.temporal.st.tr = TR;
matlabbatch{1}.spm.temporal.st.ta = TA;
matlabbatch{1}.spm.temporal.st.so = sliceOrder;
matlabbatch{1}.spm.temporal.st.refslice = refSlice;
matlabbatch{1}.spm.temporal.st.prefix = 'a';

spm_jobman('run',matlabbatch);

disp('Slice Timing Correction done !')
%close all

%--------------------------------------------------------------------------
% Realign: Estimate & Re-slice 
%--------------------------------------------------------------------------
    
for r=1:numel(runs)
    run=runs(r);
    epi=epis(r);
    file=nFiles(r);    
        
    cd(mriFldr)    
    listG=dir(['af*-' sprintf('%04d',epi) '-*-*-01.nii']);
    listG=listG(1:file);
    
    if length({listG.name})~=nFiles
        error(['wrong number of files for re-alignment in run' ...
               num2str(run,'%d')]);
        return;
    end
        
    for i=1:length({listG.name})
        listG(i).name=[mriFldr '\' listG(i).name ',1'];
    end
        
    matlabbatch{2}.spm.spatial.realign.estwrite.data{1,r}={listG.name}';
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
end

spm_jobman('run',matlabbatch);

% make a copy of reference and source files and simply rename them
% with shorter alphabetical identity
if ~exist('myFolder', 'dir'); mkdir myFolder; end
mFldr = [mriFldr '\myFolder'];
% reference
rfile = dir([mriFldr '\s' mriSubj '-0002-*.nii']);
f1 = fullfile(mriFldr, ['s' mriSubj '.nii']);
g1 = fullfile(mriFldr, rfile.name);
if ~exist(f1, 'file')
    % save a backup in a new folder before renaming
    copyfile(g1, mFldr);
    movefile(g1, f1);
    disp(['Copying ' f1 'done !'])
end
% source 
sfile = dir([mriFldr '\meanaf' mriSubj '-*.nii']);
f2 = fullfile(mriFldr, ['meanaf' mriSubj '.nii']);
g2 = fullfile(mriFldr, sfile.name);
if ~exist(f2, 'file')
    % save a backup in a new folder before renaming
    copyfile(g2, mFldr);
    movefile(g2, f2);
    disp(['Copying ' f2 'done !'])
end

disp('Re-alignment done !')
%close all

%--------------------------------------------------------------------------
% Co-register: Estimate
%--------------------------------------------------------------------------

cd(mriFldr)
% reference
matlabbatch{3}.spm.spatial.coreg.estimate.ref = {[f1 ',1']};
% source
matlabbatch{3}.spm.spatial.coreg.estimate.source = {[f2, ',1']};

% ====================================
% just all the images in one cell:
% ====================================

fList=dir(fullfile(mriFldr, ['raf*-*-*-01.nii']));

fprintf(1, 'no of files: %d and %d for co-registration !\n', noFs, length(fList));

if length(fList)~=noFs
    error('wrong number of files for co-registration!');
    return;
end

for i=1:length(fList)
    fList(i).name=[mriFldr '\' fList(i).name ',1'];
end

disp({fList.name}');

matlabbatch{3}.spm.spatial.coreg.estimate.other = {fList.name}';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];

spm_jobman('run',matlabbatch);

disp('Co-register done !')
%close all

%--------------------------------------------------------------------------
% Normalise: Estimate & Write
%--------------------------------------------------------------------------

cd(mriFldr)
% reference
matlabbatch{4}.spm.spatial.normalise.estwrite.subj.vol = {[f1 ',1']};

nList=dir(fullfile(mriFldr, ['raf*-*-*-01.nii']));

fprintf(1, 'no of files: %d and %d for normalization !\n', noFs, length(nList));

if length(nList)~=noFs
    error('wrong number of files for normalization!');
    return;
end

for i=1:length(nList)
    nList(i).name=[mriFldr '\' nList(i).name ',1'];
end

disp({nList.name}');

matlabbatch{4}.spm.spatial.normalise.estwrite.subj.resample = {nList.name}';
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.tpm = {tpmFile};
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{4}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.bb = [-78 -112 -70
                                                             78 76 85];
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{4}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';

spm_jobman('run',matlabbatch);

disp('Normalize done !')
%close all

%--------------------------------------------------------------------------
% Smooth
%--------------------------------------------------------------------------

cd(mriFldr)

sList=dir(fullfile(mriFldr, ['wraf*-*-*-01.nii']));

fprintf(1, 'no of files: %d and %d for smoothing !\n', noFs, length(sList));

if length(sList)~=noFs
    error('wrong number of files for smoothing!');
    return;
end

for i=1:length(sList)
    sList(i).name=[mriFldr '\' sList(i).name ',1'];
end

disp({sList.name}');

matlabbatch{5}.spm.spatial.smooth.data = {sList.name}';
matlabbatch{5}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{5}.spm.spatial.smooth.dtype = 0;
matlabbatch{5}.spm.spatial.smooth.im = 0;
matlabbatch{5}.spm.spatial.smooth.prefix = 's';

spm_jobman('run',matlabbatch);

disp('Smooth done !')
%close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CLASSICAL STATISTICAL ANALYSIS (CATEGORICAL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------------------------------------------------------
% Output Directory
%--------------------------------------------------------------------------
%matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.parent = cellstr(data_path);
%matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_mkdir.name = 'categorical';

%--------------------------------------------------------------------------
% Model Specification
%--------------------------------------------------------------------------

cd(mriFldr)

% delete useless files
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
end

mList1=dir(['swraf*-' sprintf('%04d',epis(1)) '-*-*-01.nii']);
mList1=mList1(1:nFiles(1));
    
mList2=dir(['swraf*-' sprintf('%04d',epis(2)) '-*-*-01.nii']);
mList2=mList2(1:nFiles(2));

mList3=dir(['swraf*-' sprintf('%04d',epis(3)) '-*-*-01.nii']);
mList3=mList3(1:nFiles(3));
    
mList4=dir(['swraf*-' sprintf('%04d',epis(4)) '-*-*-01.nii']);
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

matlabbatch{6}.spm.stats.fmri_spec.dir = {mriFldr};
matlabbatch{6}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{6}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{6}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{6}.spm.stats.fmri_spec.timing.fmri_t0 = 8;

matlabbatch{6}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(1).cond(1).name = names{1};
matlabbatch{6}.spm.stats.fmri_spec.sess(1).cond(1).onset = onsets{1};
matlabbatch{6}.spm.stats.fmri_spec.sess(1).cond(1).duration = durations{1};

matlabbatch{6}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(2).cond(1).name = names{2};
matlabbatch{6}.spm.stats.fmri_spec.sess(2).cond(1).onset = onsets{2};
matlabbatch{6}.spm.stats.fmri_spec.sess(2).cond(1).duration = durations{2};

matlabbatch{6}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(3).cond(1).name = names{3};
matlabbatch{6}.spm.stats.fmri_spec.sess(3).cond(1).onset = onsets{3};
matlabbatch{6}.spm.stats.fmri_spec.sess(3).cond(1).duration = durations{3};

matlabbatch{6}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(4).cond(1).name = names{4};
matlabbatch{6}.spm.stats.fmri_spec.sess(4).cond(1).onset = onsets{4};
matlabbatch{6}.spm.stats.fmri_spec.sess(4).cond(1).duration = durations{4};

matlabbatch{6}.spm.stats.fmri_spec.sess(1).scans = {mList1.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(1).cond(2).name = names{5};
matlabbatch{6}.spm.stats.fmri_spec.sess(1).cond(2).onset = onsets{5};
matlabbatch{6}.spm.stats.fmri_spec.sess(1).cond(2).duration = durations{5};

matlabbatch{6}.spm.stats.fmri_spec.sess(2).scans = {mList2.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(2).cond(2).name = names{6};
matlabbatch{6}.spm.stats.fmri_spec.sess(2).cond(2).onset = onsets{6};
matlabbatch{6}.spm.stats.fmri_spec.sess(2).cond(2).duration = durations{6};

matlabbatch{6}.spm.stats.fmri_spec.sess(3).scans = {mList3.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(3).cond(2).name = names{7};
matlabbatch{6}.spm.stats.fmri_spec.sess(3).cond(2).onset = onsets{7};
matlabbatch{6}.spm.stats.fmri_spec.sess(3).cond(2).duration = durations{7};

matlabbatch{6}.spm.stats.fmri_spec.sess(4).scans = {mList4.name}';
matlabbatch{6}.spm.stats.fmri_spec.sess(4).cond(2).name = names{8};
matlabbatch{6}.spm.stats.fmri_spec.sess(4).cond(2).onset = onsets{8};
matlabbatch{6}.spm.stats.fmri_spec.sess(4).cond(2).duration = durations{8};

spm_jobman('run',matlabbatch);

disp('Model Specification done !')

%--------------------------------------------------------------------------
% Model Expectation
%--------------------------------------------------------------------------

matlabbatch{7}.spm.stats.fmri_est.spmmat = { [ mriFldr '\SPM.mat' ] };
matlabbatch{7}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{7}.spm.stats.fmri_est.method.Classical = 1;

spm_jobman('run',matlabbatch);

disp('Model Expectation done !')

%--------------------------------------------------------------------------
% Inference
%--------------------------------------------------------------------------

matlabbatch{8}.spm.stats.con.spmmat = { [ mriFldr '\SPM.mat' ] };
matlabbatch{8}.spm.stats.con.consess{1}.tcon.name = 'reading';
matlabbatch{8}.spm.stats.con.consess{1}.tcon.weights = [1 0 1 0 1 0 1 0];
matlabbatch{8}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{8}.spm.stats.con.consess{2}.tcon.name = 'answering';
matlabbatch{8}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 1 0 1 0 1];
matlabbatch{8}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{8}.spm.stats.con.delete = 0;

spm_jobman('run',matlabbatch);

disp('Model Inference done !')
