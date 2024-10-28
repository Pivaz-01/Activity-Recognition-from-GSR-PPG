function [features] = computeFeaturesPPG(struct, Fs) 
    measures_max_ppg = [];
    measures_min_ppg = [];
    measures_mean_ppg = [];
    measures_var_ppg = [];
    
    measures_rate_pks_ppg = [];
    
    measures_IBI_mean = [];
    measures_SDNN = [];

    for j = 1 : length(struct)    
        % segment analyzing
        temp_ppg = struct{1,j};

        measures_max_ppg = [measures_max_ppg; max(temp_ppg)];
        measures_min_ppg = [measures_min_ppg; min(temp_ppg)];
        measures_mean_ppg = [measures_mean_ppg; mean(temp_ppg)];
        measures_var_ppg = [measures_var_ppg; var(temp_ppg)];

        [peaks, locs] = findpeaks(temp_ppg, MinPeakDistance=38); % 38 is # samples in 300 ms
        n_peaks = length(peaks);
        measures_rate_pks_ppg = [measures_rate_pks_ppg; n_peaks / (length(temp_ppg) / Fs)];

        IBI = diff(locs) / Fs;

        IBI_mean = mean(IBI);
        measures_IBI_mean = [measures_IBI_mean; IBI_mean];
        
        SDNN = std(IBI);
        measures_SDNN = [measures_SDNN; SDNN];
    end

    features.max_ppg = measures_max_ppg;
    features.min_ppg = measures_min_ppg;
    features.mean_ppg = measures_mean_ppg;
    features.var_ppg = measures_var_ppg;
    
    features.rate_peaks_ppg = measures_rate_pks_ppg;
    
    features.IBI_mean = measures_IBI_mean;
    features.SDNN = measures_SDNN;
end