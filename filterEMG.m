function [outputArg] = filterEMG(inputArg, cutoff, Fs, order)
    [b_butter_low, a_butter_low] = butter(order, 2*cutoff/Fs, "bandpass"); 
    outputArg = filtfilt(b_butter_low, a_butter_low, inputArg);
end