function [features] = computeFeaturesGSR(struct, Fs)
    measures_max_gsr = [];
    measures_min_gsr = [];
    measures_mean_gsr = [];
    measures_var_gsr = [];
    
    measures_max_gsr_phas = [];
    measures_min_gsr_phas = [];
    measures_mean_gsr_phas = [];
    measures_var_gsr_phas = [];
    
    measures_n_pks_gsr = [];
    measures_rate_pks_gsr = [];   
    
    measures_reg_coef_gsr = [];

    for j = 1 : length(struct)
        temp_gsr = struct{1,j};

        f = 0.05; %Hz
        [ba, aa] = butter(1, f/Fs, 'high');
        phasic_temp = filtfilt(ba, aa, temp_gsr);
               
        phas_min = min(phasic_temp);
        phasic_temp = phasic_temp - phas_min;
              
        [ba, aa] = butter(1, f/Fs, 'low');   
        tonic_temp =  filtfilt(ba, aa, temp_gsr);

        measures_max_gsr = [measures_max_gsr; max(tonic_temp)];
        measures_min_gsr = [measures_min_gsr; min(tonic_temp)];
        measures_mean_gsr = [measures_mean_gsr; mean(tonic_temp)];
        measures_var_gsr = [measures_var_gsr; var(tonic_temp)];

        measures_max_gsr_phas = [measures_max_gsr_phas; max(phasic_temp)];
        measures_min_gsr_phas = [measures_min_gsr_phas; min(phasic_temp)];
        measures_mean_gsr_phas = [measures_mean_gsr_phas; mean(phasic_temp)];
        measures_var_gsr_phas = [measures_var_gsr_phas; var(phasic_temp)];

        [peaks, locs] = findpeaks(tonic_temp);
        n_peaks = length(peaks);
        measures_n_pks_gsr = [measures_n_pks_gsr; n_peaks];
        measures_rate_pks_gsr = [measures_rate_pks_gsr; n_peaks / (length(tonic_temp) / Fs)];

        y = tonic_temp;
        x = (1:length(y))';
        p = polyfit(x,y,1);
        
        measures_reg_coef_gsr = [measures_reg_coef_gsr; p(1)];    
    end

    features.max_gsr = measures_max_gsr;
    features.min_gsr = measures_min_gsr;
    features.mean_gsr = measures_mean_gsr;
    features.var_gsr = measures_var_gsr;
    
    features.max_gsr_phas = measures_max_gsr_phas;
    features.min_gsr_phas = measures_min_gsr_phas;
    features.mean_gsr_phas = measures_mean_gsr_phas;
    features.var_gsr_phas = measures_var_gsr_phas;
   
    features.rate_peaks_gsr = measures_rate_pks_gsr;        
    
    features.reg_coef_gsr = measures_reg_coef_gsr;
end