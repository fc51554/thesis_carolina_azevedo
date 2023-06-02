%%
%(1)selection of nifti files
nii_files = dir('C:\Users\carol\Desktop\nifti_files\test\4D_files\');
nii_files_names = {nii_files(3:end).name}; 
nii_files_totalsize = size(nii_files); %total size with folder and subfolder
nii_files_actualsize = nii_files_totalsize(1,1)-2; %actual size minus folder and subfolder
nii_size = (1:nii_files_actualsize)+2;
%random_nii_index = random_nii_size(randperm(length(random_nii_size)))+2; %random nii file index
%%
%(2)valid ROIs selection
voxelsize = 3; %mm
origin = [31 43 25]; %vx
n_ROIS = 1; %number of ROIs selected from the population of 264
ROIs_mm = round(readmatrix('ROIsPower2011.xlsx')); %[index x y z] mm
ROIs_vx = [ROIs_mm(:,1) round(ROIs_mm(:,[2,3,4])/voxelsize + origin) ROIs_mm(:,5)]; %[index x y z] vx
ROIs_to_exclude = [
    ROIs_vx(1:186,:);
    ROIs_vx(202:264,:)]; %ROIs corresponding to uncertain locations
valid_ROIs_index = setdiff(ROIs_vx(:,1),ROIs_to_exclude(:,1),'sorted'); 
valid_ROIs = ROIs_vx(valid_ROIs_index,:); %ROIs corresponding to known locations
%%
%(3)generic coordinates and respective euclidean distances
max_neighborhood = 2; %maximum of 5
generic_coordinates_eucl = [];
for x = -max_neighborhood:+max_neighborhood %neighborhood of 125
    for y = -max_neighborhood:+max_neighborhood
        for z = -max_neighborhood:+max_neighborhood
                dist = [x y z]; %generic coordinates
                eucl_dist = sqrt(sum(dist .* dist)); %euclidean distance vx
                generic_coordinates_eucl = [generic_coordinates_eucl; dist, eucl_dist.*voxelsize]; %generic coordinates, euclidean distance mm
         end
     end
end
%%
%(4)ROI coodinates and respective euclidean distances which meet the condition established
ROI_coordinates_eucl = [];
for c = 1:size(generic_coordinates_eucl) 
    if generic_coordinates_eucl(c,4) < 5 %condition established
        ROI_coordinates_eucl = [ROI_coordinates_eucl; generic_coordinates_eucl(c,[1,2,3,4])]; %ROI coordinates, euclidean distance less than 5 mm
    end
end
ROI_coordinates = ROI_coordinates_eucl(:,[1,2,3]);
%%
infos = [];
labels = [];
len = [];
for i = nii_size
    time_series_total = [];
    random_ROI = valid_ROIs(transpose(randsample(1:length(valid_ROIs), n_ROIS, true)),:); %sorted random ROIs (with no replacement) vx
    chosen_voxel = ROI_coordinates(randsample(1:length(ROI_coordinates),15,false),:) + random_ROI(:,[2,3,4]); % [x y z] vx

    %(5)subject time series obtention
    chosen_file_name = nii_files(i).name;
    chosen_file = niftiread(chosen_file_name);
    len = [len, length(chosen_file)];
    for j = 1:size(chosen_voxel)
        time_series_subject = squeeze(chosen_file(chosen_voxel(j,1),chosen_voxel(j,2),chosen_voxel(j,3),:));
        time_series_total = [time_series_total; time_series_subject];
        time_series = double(reshape(time_series_total,(length(time_series_subject)),[]));
        save(fullfile('C:\Users\carol\Desktop\nifti_files\test\time_series\',['ts_sub',sprintf('%04d', i-2),'.mat']),"time_series");
    end
    %(6)structure with all the information gathered
    info = struct('name',chosen_file_name,'index',random_ROI(:,1),'ROI',random_ROI(:,[2,3,4]),'label',random_ROI(:,5),'voxel',chosen_voxel);
    infos = [infos; info];
    label = repelem(random_ROI(:,5),15);
    labels = [labels,label];
end

%%
%(7)save infos as a .mat file
save(fullfile('C:\Users\carol\Desktop\nifti_files\test','infos.mat'),"infos");
%(8)save labels as a .mat file
save(fullfile('C:\Users\carol\Desktop\nifti_files\test','labels.mat'),"labels");
%(9)save 4D nii files names as a .mat file
file_4Dnames = convertCharsToStrings(reshape({infos(:).name},[],1));
save(fullfile('C:\Users\carol\Desktop\nifti_files\test','file_4Dnames.mat'),"file_4Dnames");
%(10)save time series lengths according to file as a .mat file
save(fullfile('C:\Users\carol\Desktop\nifti_files\test','len.mat'),"len");
%%