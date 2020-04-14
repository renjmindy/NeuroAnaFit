% Extract values from an image data file based on regions / clusters of 
% voxels in mask marsbar or image file(s) or voxel.

% [Ym R info] = extract_voxel_values(mask,raw data)

% Ym - (mean, region) across voxels 
% I (image) within mask
% R (region) within mask 
% R.I.Ya       - voxel read-out value per R per I
% R.I.xyz      - voxel matrix indices per R per I
% R.I.mni      - voxel coordinate per R per I
% info         - string arrays of mask and raw data files
% info.regions - string array of mask files in use
% info.images  - string array of raw data files in use

% mask - string array of mask files
% data - string array of raw data files

function[Ym R info] = extract_voxel_values(mask,data)

%mask = 'MiddleTemporalGyrus.img';
%data = 'beta_0001.nii';

info.regions = mask;
info.images = data;

for i = 1:size(data,1)
    
    V = spm_vol(deblank(data(i,:)));
    
    for r = 1:size(mask,1)
        
        [~,~,e] = fileparts(deblank(mask(r,:)));
        switch e
            case {'.mat'}
                roi = maroi(deblank(mask(r,:)));
                xyz = voxpts(roi,deblank(data(i,:)));
            case {'.nii','.img'}
                maskdata = spm_read_vols(spm_vol(deblank(mask(r,:))));
                indx = find(maskdata>0);
                [x,y,z] = ind2sub(size(maskdata),indx);
                xyz = [x y z]';
        end
        
        Ya = spm_sample_vol(V,xyz(1,:),xyz(2,:),xyz(3,:),0);
        R(r).I(i).Ya = Ya;
        Ym(i,r) = mean(Ya(~isnan(Ya)));
        R(r).I(i).mni = vox2mni(V.mat,xyz);
        R(r).I(i).xyz = xyz;
        
    end
end

disp(' ***** mean value: ***** ')
disp(Ym)
disp(' ***** voxel read-out value per region per image: ***** ')
disp(R.I.Ya)
disp(' ***** voxel coordinate per region per image: ***** ')
disp(R.I.mni)
disp(' ***** voxel matrix indices per region per image: ***** ')
disp(R.I.xyz)
