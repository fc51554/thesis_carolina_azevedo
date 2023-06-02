load("labels.mat");
Beta_files = dir('C:\Users\carol\Desktop\nifti_files\test\SPM_Estimation');
Beta_files_totalsize  = size(Beta_files);
Beta_files_actualsize = Beta_files_totalsize(1,1)-2;
Beta_files_size = (1:Beta_files_actualsize)+2;
    for i = Beta_files_size
        rd = niftiread(Beta_files(i).name);
        rs = rescale(rd);
        rs(isnan(rs))=0;
        niftiwrite(rs,'rs.nii')
        movefile('rs.nii',['C:\Users\carol\Desktop\nifti_files\test\SPM_Estimation_Normalised_Labeld\Network' num2str(labels(i-2)) '\N', Beta_files(i).name]);  
    
    end