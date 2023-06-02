load("file_4Dnames.mat");
load("len.mat");
SPM_files = dir('C:\Users\carol\Desktop\nifti_files\test\SPM_1st_Level');
SPM_files_totalsize  = size(SPM_files);
SPM_files_actualsize = SPM_files_totalsize(1,1)-2;
SPM_files_size = (1:SPM_files_actualsize)+2;
SPM_files_shaped = reshape(SPM_files_size,15,[]);
    for i = 1:length(file_4Dnames)
        i
        file_4Dnames(i)
        for k = 1:15
            k
            idx = SPM_files_shaped(k,i);
            idx
            load(SPM_files(idx).name)
            SPM.xM.TH=ones(len(i),1)*-Inf;
            spm_spm(SPM);
            if isfile('RPV.nii')
                delete('RPV.nii');
            end
            if isfile('ResMS.nii')
                delete('ResMS.nii');
            end
            if isfile('mask.nii')
                delete('mask.nii');
            end
            if isfile('beta_0002.nii')
                delete('beta_0002.nii')
            end
            if isfile('SPM.mat')
               delete('SPM.mat')
            end
            movefile('beta_0001.nii',['C:\Users\carol\Desktop\nifti_files\test\SPM_Estimation\beta1_sub',sprintf('%04d', i),'ts',sprintf('%04d', k),'.nii']);
        end
    end  