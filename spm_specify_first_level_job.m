load("subfolders.mat");
names_files = dir('C:\Users\carol\Desktop\nifti_files\test\3D_files_names');
ts_files = dir('C:\Users\carol\Desktop\nifti_files\test\time_series\');
names_files_totalsize  = size(names_files);
names_files_actualsize = names_files_totalsize(1,1)-2;
names_files_size = (1:names_files_actualsize)+2;
for j = names_files_size
    load(names_files(j).name);
    names_files(j).name     
    spm('Defaults','fMRI'); %Initialise SPM fmri
    load(ts_files(j).name)
    ts_files(j).name
    %Specify 1st Level
    matlabbatch{1}.spm.stats.fmri_spec.dir = {'C:\Users\carol\Desktop\nifti_files\test\3D_files\'};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    subfolder_dir = strcat('C:\Users\carol\Desktop\nifti_files\test\3D_files\',subfolders(j-2));
    subfolder_dir
    cd (subfolder_dir)   
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = file_3Dnames;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress.name = 'time series';
    for k = 1:size(time_series,2)
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress.val = time_series(:,k);
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {'C:\Users\carol\Desktop\Toolboxes\spm12\EEGtemplates\iskull.nii,1'};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
        spm_jobman('run',matlabbatch);
        movefile('C:\Users\carol\Desktop\nifti_files\test\3D_files\SPM.mat',['C:\Users\carol\Desktop\nifti_files\test\SPM_1st_Level\SPMsub', sprintf('%04d', j-2),'ts', sprintf('%04d', k),'.mat']);
     end
end 
