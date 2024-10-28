function [outputArg] = filterSegment_GSR(inputArg, cutoff, Fs, order)
    [b_butter_low, a_butter_low] = butter(order, 2*cutoff/Fs, "low"); 
    outputArg = filtfilt(b_butter_low, a_butter_low, inputArg);
end