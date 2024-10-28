%% OVERVIEW OF RESULTS

% Marker 1: 70 bpm
% Average Steps Per Minute (EMG1): 64.14
% Average Steps Per Minute (EMG2): 78.94
% 
% Marker 4: 85 bpm
% Average Steps Per Minute (EMG1): 60.82
% Average Steps Per Minute (EMG2): 85.74
% 
% Marker 8: 100 bpm
% Average Steps Per Minute (EMG1): 56.97
% Average Steps Per Minute (EMG2): 100.71

% Very good results for the EMG2 data.
% For what concerns EMG1 part, there is an absolute mismatch with the
% expected results, which can be caused by bad positioning of the sensor or
% scarse attention during the acquisition of data.

%% IMPORTING DATA

session1 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Walking tasks/Session1_Shimmer_F0AD.mat');
session2 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Walking tasks/Session2_Shimmer_F0AD.mat');
session3 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Walking tasks/Session3_EMG_1.mat');

%% ADJUST MARKERS
% 1 First Walk, 2 Resting, 4 Second Walk, 8 Third Walk

session3.EMG_1_Event_Marker_CAL(session3.EMG_1_Event_Marker_CAL == 8) = 1;
session3.EMG_1_Event_Marker_CAL(session3.EMG_1_Event_Marker_CAL == 4) = 2;
session3.EMG_1_Event_Marker_CAL(session3.EMG_1_Event_Marker_CAL == 16) = 4;
session3.EMG_1_Event_Marker_CAL(session3.EMG_1_Event_Marker_CAL == 32) = 8;

%% NEW DATA STRUCTURE 

% Initialize struct

data = struct('Markers', {}, 'EMG1', {}, 'EMG2', {});

% Put in markers

data(1).Markers = session1.Shimmer_F0AD_Event_Marker_CAL;
data(2).Markers = session2.Shimmer_F0AD_Event_Marker_CAL;
data(3).Markers = session3.EMG_1_Event_Marker_CAL;

% Put in EMG1 data

data(1).EMG1 = session1.Shimmer_F0AD_EMG_CH1_BandPass_Filter_CAL;
data(2).EMG1 = session2.Shimmer_F0AD_EMG_CH1_BandPass_Filter_CAL;
data(3).EMG1 = session3.EMG_1_EMG_CH1_BandPass_Filter_CAL;

% Put in EMG2 data

data(1).EMG2 = session1.Shimmer_F0AD_EMG_CH2_BandPass_Filter_CAL;
data(2).EMG2 = session2.Shimmer_F0AD_EMG_CH2_BandPass_Filter_CAL;
data(3).EMG2 = session3.EMG_1_EMG_CH2_BandPass_Filter_CAL;

%% DELETING OUTLIERS 
% From plotting, we can see a section of outliers in the 
% final part of data from the third subject

index_range_to_keep = 1:278281;

data(3).Markers = data(3).Markers(index_range_to_keep);
data(3).EMG1 = data(3).EMG1(index_range_to_keep);
data(3).EMG2 = data(3).EMG2(index_range_to_keep);

%% FILTERING 
% Butter bandpass filter

Fs = 512;

for sbj = 1 : length(data)
    data(sbj).EMG1filt = data(sbj).EMG1; % already filtered
    data(sbj).EMG2filt = filterEMG(data(sbj).EMG2, [10, 50], Fs, 3);
end

% Show comparison 

figure(1); 
subplot(2,1,1); plot(data(1).EMG2);
title("EMG2 not filtered");
subplot(2,1,2); plot(data(1).EMG2filt);
title("EMG2 filtered");

figure(2); 
subplot(2,1,1); plot(data(2).EMG2);
title("EMG2 not filtered");
subplot(2,1,2); plot(data(2).EMG2filt);
title("EMG2 filtered");

figure(3); 
subplot(2,1,1); plot(data(3).EMG2);
title("EMG2 not filtered");
subplot(2,1,2); plot(data(3).EMG2filt);
title("EMG2 filtered");

%% ENVELOPE 

% Calculate envelope for both EMG1 and EMG2 outside the marker loop

for sbj = 1 : length(data)
    
    % Hilbert method: based on Hilbert Transform it provides a mathematical
    % form of envelope, in general with a "smoother" result, while
    % classical envelope would stop at the simple peaks.

    data(sbj).EMG1env = abs(hilbert(data(sbj).EMG1filt));
    data(sbj).EMG2env = abs(hilbert(data(sbj).EMG2filt));

end

%% PACE FOR EACH TASK

marker_results = struct('Marker', {}, 'StepsPerMinute1', [], 'StepsPerMinute2', []);

for sbj = 1:length(data) % for each subject

    % Initialize variables to store steps per minute for each marker

    markers = unique(data(sbj).Markers);

    steps_per_minute1 = zeros(1, length(markers));
    steps_per_minute2 = zeros(1, length(markers));

    for m = 1:length(markers) % for each marker
        if markers(m) == -1 || markers(m) == 0 || markers(m) == 2
            continue;
        end
        
        % Set range of work 

        marker_indices = find((data(sbj).Markers) == markers(m));
        start_idx = marker_indices(1);
        end_idx = marker_indices(length(marker_indices));

        % Find peaks within the current marker range

        [peaks1, ~] = findpeaks(data(sbj).EMG1env(start_idx:end_idx), 'MinPeakHeight', mean(data(sbj).EMG1env(start_idx:end_idx)), 'MinPeakDistance', Fs * 0.5);
        [peaks2, ~] = findpeaks(data(sbj).EMG2env(start_idx:end_idx), 'MinPeakHeight', mean(data(sbj).EMG2env(start_idx:end_idx)), 'MinPeakDistance', Fs * 0.5);

        % Calculate steps per minute

        duration = (end_idx - start_idx) / Fs / 60; % duration in minutes
        
        marker_results(m).Marker = markers(m);
        marker_results(m).StepsPerMinute1 = length(peaks1) / duration;
        marker_results(m).StepsPerMinute2 = length(peaks2) / duration;

    end
end

bpm = [0,0,70,0,85,100];
for m = 1:length(marker_results)
    if markers(m) == -1 || markers(m) == 0 || markers(m) == 2
        continue;
    end
    fprintf('Marker %d: %d bpm\n', marker_results(m).Marker, bpm(m));
    fprintf('Average Steps Per Minute (EMG1): %.2f\n', marker_results(m).StepsPerMinute1);
    fprintf('Average Steps Per Minute (EMG2): %.2f\n', marker_results(m).StepsPerMinute2);
    fprintf('\n');
end
