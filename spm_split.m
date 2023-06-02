%%
%Access directory with 4D files
cd 4D_files\
original_img = dir('C:\Users\carol\Desktop\nifti_files\test\4D_files');
original_img_totalsize = size(original_img);
original_img_actualsize = original_img_totalsize(1,1)-2;
img_size = (1:original_img_actualsize)+2;

%%
%Split 4D files into 3D files
load("file_4Dnames.mat");
for i = img_size
    temp = strsplit(file_4Dnames(i-2),'_');
    folder_name = temp(1);
    folder_name = strcat('C:\Users\carol\Desktop\nifti_files\test\3D_files\',folder_name);
    mkdir (folder_name)
    spm_file_split(original_img(i).name,char(folder_name));
end
%%
folder3D_dir = dir('C:\Users\carol\Desktop\nifti_files\test\3D_files');
folder3D_totalsize = size(folder3D_dir);
folder3D_actualsize = folder3D_totalsize(1,1)-2;
folder3D_size = (1:folder3D_actualsize)+2;
subfolders = [];
for f = folder3D_size
    subfolder = convertCharsToStrings(folder3D_dir(f).name);
    subfolders = [subfolders, subfolder];
end
subfolders_dir = [];
for s = 1:length(subfolders)
    subfolder_dir = strcat('C:\Users\carol\Desktop\nifti_files\test\3D_files\',subfolders(s));
    subfolders_dir = [subfolders_dir, subfolder_dir];

end
for d =1:length(subfolders_dir)
    files3Dnames_dir = dir(subfolders_dir(d));
    files3Dnames_totalsize = size(files3Dnames_dir);
    files3Dnames_actualsize = files3Dnames_totalsize(1,1)-2;
    files3Dnames_size = (1:files3Dnames_actualsize)+2;
    split_totalnames = [];
    for i = files3Dnames_size
        split_name_char = files3Dnames_dir(i).name;
        split_name_str = convertCharsToStrings(split_name_char);
        split_totalnames =[split_totalnames, split_name_str];
        file_3Dnames = cellstr(reshape(split_totalnames,(length(split_totalnames)),[]));
    end
    save(fullfile('C:\Users\carol\Desktop\nifti_files\test\3D_files_names\',['file_3Dnames',sprintf('%04d', d),'.mat']),"file_3Dnames");
end
save(fullfile('C:\Users\carol\Desktop\nifti_files\test','subfolders.mat'),"subfolders");