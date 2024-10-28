%% OVERVIEW OF RESULTS

% precision_tmp_poly_PPG =
% 
%     0.5625    0.5500
% 
% 
% recall_tmp_poly_PPG =
% 
%     0.5000    0.6111
% 
% 
% f1_measure_tmp_poly_PPG =
% 
%     0.5294    0.5789

% At the end of the code, a more detailed comment is present.

%% IMPORTING DATA

session1 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Cognitive Load tasks/Session1_Shimmer_5E8A.mat');
session2 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Cognitive Load tasks/Session2_Shimmer_5E8A.mat');
session3 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Cognitive Load tasks/Session3_Shimmer_5E8A.mat');
session4 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Cognitive Load tasks/Session4_Shimmer_5E8A.mat');
session5 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Cognitive Load tasks/Session5_Shimmer_8965.mat');
session6 = load('/Users/pivaz/Desktop/AI4ST/HSI/Lab03/Third Assignment Material/Cognitive Load tasks/Session6_Shimmer_8965.mat');

%% ADJUST MARKERS
% Set as 10 for Baseline, 20 for Calculus and 30 for Audio

% session 1 and 2

session1.Shimmer_5E8A_Event_Marker_CAL(session1.Shimmer_5E8A_Event_Marker_CAL == 1) = 20;
session1.Shimmer_5E8A_Event_Marker_CAL(session1.Shimmer_5E8A_Event_Marker_CAL == 2) = 10;
session1.Shimmer_5E8A_Event_Marker_CAL(session1.Shimmer_5E8A_Event_Marker_CAL == 4) = 30;

session2.Shimmer_5E8A_Event_Marker_CAL(session2.Shimmer_5E8A_Event_Marker_CAL == 1) = 20;
session2.Shimmer_5E8A_Event_Marker_CAL(session2.Shimmer_5E8A_Event_Marker_CAL == 2) = 10;
session2.Shimmer_5E8A_Event_Marker_CAL(session2.Shimmer_5E8A_Event_Marker_CAL == 4) = 30;

% session 3 and 4

session3.Shimmer_5E8A_Event_Marker_CAL(session3.Shimmer_5E8A_Event_Marker_CAL == 4) = 10;
session3.Shimmer_5E8A_Event_Marker_CAL(session3.Shimmer_5E8A_Event_Marker_CAL == 8) = 20;
session3.Shimmer_5E8A_Event_Marker_CAL(session3.Shimmer_5E8A_Event_Marker_CAL == 16) = 30;

session4.Shimmer_5E8A_Event_Marker_CAL(session4.Shimmer_5E8A_Event_Marker_CAL == 4) = 10;
session4.Shimmer_5E8A_Event_Marker_CAL(session4.Shimmer_5E8A_Event_Marker_CAL == 8) = 20;
session4.Shimmer_5E8A_Event_Marker_CAL(session4.Shimmer_5E8A_Event_Marker_CAL == 16) = 30;

% session 5 and 6

session5.Shimmer_8965_Event_Marker_CAL(session5.Shimmer_8965_Event_Marker_CAL == 1) = 30;
session5.Shimmer_8965_Event_Marker_CAL(session5.Shimmer_8965_Event_Marker_CAL == 4) = 10;
session5.Shimmer_8965_Event_Marker_CAL(session5.Shimmer_8965_Event_Marker_CAL == 8) = 20;

session6.Shimmer_8965_Event_Marker_CAL(session6.Shimmer_8965_Event_Marker_CAL == 1) = 30;
session6.Shimmer_8965_Event_Marker_CAL(session6.Shimmer_8965_Event_Marker_CAL == 4) = 10;
session6.Shimmer_8965_Event_Marker_CAL(session6.Shimmer_8965_Event_Marker_CAL == 8) = 20;

% final results verification 

unique(session1.Shimmer_5E8A_Event_Marker_CAL)
unique(session2.Shimmer_5E8A_Event_Marker_CAL)
unique(session3.Shimmer_5E8A_Event_Marker_CAL)
unique(session4.Shimmer_5E8A_Event_Marker_CAL)
unique(session5.Shimmer_8965_Event_Marker_CAL)
unique(session6.Shimmer_8965_Event_Marker_CAL)

%% NEW DATA STRUCTURE 

% Initialize structure

data = struct('Markers', {}, 'GSR', {}, 'PPG', {});

% Put in markers 

data(1).Markers = session1.Shimmer_5E8A_Event_Marker_CAL;
data(2).Markers = session2.Shimmer_5E8A_Event_Marker_CAL;
data(3).Markers = session3.Shimmer_5E8A_Event_Marker_CAL;
data(4).Markers = session4.Shimmer_5E8A_Event_Marker_CAL;
data(5).Markers = session5.Shimmer_8965_Event_Marker_CAL;
data(6).Markers = session6.Shimmer_8965_Event_Marker_CAL;

% Put in GSR data

data(1).GSR = session1.Shimmer_5E8A_GSR_Skin_Conductance_CAL;
data(2).GSR = session2.Shimmer_5E8A_GSR_Skin_Conductance_CAL;
data(3).GSR = session3.Shimmer_5E8A_GSR_Skin_Conductance_CAL;
data(4).GSR = session4.Shimmer_5E8A_GSR_Skin_Conductance_CAL;
data(5).GSR = session5.Shimmer_8965_GSR_Skin_Conductance_CAL;
data(6).GSR = session6.Shimmer_8965_GSR_Skin_Conductance_CAL;

% Put in PPG

data(1).PPG = session1.Shimmer_5E8A_PPG_A13_CAL;
data(2).PPG = session2.Shimmer_5E8A_PPG_A13_CAL;
data(3).PPG = session3.Shimmer_5E8A_PPG_A13_CAL;
data(4).PPG = session4.Shimmer_5E8A_PPG_A13_CAL;
data(5).PPG = session5.Shimmer_8965_PPG_A13_CAL;
data(6).PPG = session6.Shimmer_8965_PPG_A13_CAL;

%% GSR FILTERING  

Fs = 128;

for sbj = 1 : length(data)
    data(sbj).GSRfilt = filterSegment_GSR(data(sbj).GSR, 0.05, Fs, 3);
end

% Show comparison

figure(1); 
subplot(2,1,1); plot(data(1).GSR);
subplot(2,1,2); plot(data(1).GSRfilt);

%% PPG FILTERING 

for sbj = 1 : length(data)
    data(sbj).PPGfilt = filterSegment_PPG(data(sbj).PPG, [1, 6.5], Fs, 6);
end

% Show comparison

figure(2); 
subplot(2,1,1); plot(data(1).PPG(1:1000));
subplot(2,1,2); plot(data(1).PPGfilt(1:1000));

%% NORMALIZING DATA 

for sbj = 1 : length(data)
    data(sbj).GSRfilt_norm = normalize(data(sbj).GSRfilt);
    data(sbj).PPGfilt_norm = normalize(data(sbj).PPGfilt);
end

% Show comparison 

figure(3);
subplot(2,2,1); plot(data(1).GSRfilt);
title("GSR Filtered")
subplot(2,2,3); plot(data(1).GSRfilt_norm);
title("GSR Filtered Normalized")
subplot(2,2,2); plot(data(1).PPGfilt(1:1000));
title("PPG Filtered")
subplot(2,2,4); plot(data(1).PPGfilt_norm(1:1000));
title("PPG Filtered Normalized")

%% SEGMENTING DATA IN TASKS 

for sbj = 1 : length(data)   

    % Position where pulses occur

    MK = data(sbj).Markers;
    iCalc = find(MK == 20);
    iAudio = find(MK == 30);
    
    iCalc_change = find(diff(iCalc) ~= 1);
    iAudio_change = find(diff(iAudio) ~= 1);
  
    % For each pulse, divide the two tasks according to what described
    % before

    for it = 1:(length(iAudio_change)+1)
        if it == 1
            CognLoad(sbj).GSR.AUDIO{it} = data(sbj).GSRfilt_norm(iAudio(1):iAudio(iAudio_change(1)));
            CognLoad(sbj).PPG.AUDIO{it} = data(sbj).PPGfilt_norm(iAudio(1):iAudio(iAudio_change(1)));

            CognLoad(sbj).GSR.AUCL{it} = data(sbj).GSRfilt_norm(iCalc(1):iCalc(iCalc_change(1)));
            CognLoad(sbj).PPG.AUCL{it} = data(sbj).PPGfilt_norm(iCalc(1):iCalc(iCalc_change(1)));
        
        elseif it == length(iAudio_change) + 1
            CognLoad(sbj).GSR.AUDIO{it} = data(sbj).GSRfilt_norm(iAudio(iAudio_change(it - 1) + 1):iAudio(end));
            CognLoad(sbj).PPG.AUDIO{it} = data(sbj).PPGfilt_norm(iAudio(iAudio_change(it - 1) + 1):iAudio(end));

            CognLoad(sbj).GSR.AUCL{it} = data(sbj).GSRfilt_norm(iCalc(iCalc_change(it - 1) + 1):iCalc(end));
            CognLoad(sbj).PPG.AUCL{it} = data(sbj).PPGfilt_norm(iCalc(iCalc_change(it - 1) + 1):iCalc(end));

        else 
            CognLoad(sbj).GSR.AUDIO{it} = data(sbj).GSRfilt_norm(iAudio(iAudio_change(it - 1) + 1):iAudio(iAudio_change(it)));
            CognLoad(sbj).PPG.AUDIO{it} = data(sbj).PPGfilt_norm(iAudio(iAudio_change(it - 1) + 1):iAudio(iAudio_change(it)));

            CognLoad(sbj).GSR.AUCL{it} = data(sbj).GSRfilt_norm(iCalc(iCalc_change(it - 1) + 1):iCalc(iCalc_change(it)));
            CognLoad(sbj).PPG.AUCL{it} = data(sbj).PPGfilt_norm(iCalc(iCalc_change(it - 1) + 1):iCalc(iCalc_change(it)));
        end 
    end
end

%% GSR FEATURES EXTRACTION 

auCl_feat_GSR = [];
audio_feat_GSR = [];
auCl_sbjFeatIndex_GSR = [];
audio_sbjFeatIndex_GSR = [];

for sbj = 1 : length(CognLoad)

    % Extract GSR features from the signals collected from the subject  
    % during the High Cognitive Load task 

    aucl = CognLoad(sbj).GSR.AUCL;
    tabTmp = struct2table(computeFeaturesGSR(aucl, Fs)); 

    auCl_feat_GSR = vertcat(auCl_feat_GSR, tabTmp); 
    auCl_sbjFeatIndex_GSR = [auCl_sbjFeatIndex_GSR, ones(1, size(tabTmp, 1))*sbj];

    % Extract GSR features from the signals collected from the subject  
    % during the Low Cognitive Load task

    relax = CognLoad(sbj).GSR.AUDIO; 
    tabTmp = struct2table(computeFeaturesGSR(relax, Fs)); 

    audio_feat_GSR = vertcat(audio_feat_GSR, tabTmp);
    audio_sbjFeatIndex_GSR = [audio_sbjFeatIndex_GSR, ones(1, size(tabTmp, 1))*sbj];
end

%% PPG FEATURE EXTRACTION 

auCl_feat_PPG = [];
audio_feat_PPG = [];
auCl_sbjFeatIndex_PPG = [];
audio_sbjFeatIndex_PPG = [];

for sbj = 1 : length(CognLoad)

    % Extract PPG features from the signals collected from the subject  
    % during the High Cognitive Load task 

    aucl = CognLoad(sbj).PPG.AUCL;
    tabTmp = struct2table(computeFeaturesPPG(aucl, Fs)); 
    
    auCl_feat_PPG = vertcat(auCl_feat_PPG, tabTmp); 
    auCl_sbjFeatIndex_PPG = [auCl_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];
    
    
    % extract PPG features from the signals collected from the subject 
    % during the Low Cognitive Load task

    relax = CognLoad(sbj).PPG.AUDIO; 
    tabTmp = struct2table(computeFeaturesPPG(relax, Fs)); %[TO DO]: compute PPG features
    
    audio_feat_PPG = vertcat(audio_feat_PPG, tabTmp);
    audio_sbjFeatIndex_PPG = [audio_sbjFeatIndex_PPG, ones(1, size(tabTmp, 1))*sbj];
    
end

%% CLASSIFICATION LEARNER PREPARATION 

X_CL_GSR = [auCl_feat_GSR; audio_feat_GSR];
Y_CL_GSR = [repmat({'CognLoad'}, 1, 18), repmat({'relax'}, 1, 18)]';

X_CL_PPG = [auCl_feat_PPG; audio_feat_PPG];
Y_CL_PPG = [repmat({'CognLoad'}, 1, 18), repmat({'relax'}, 1, 18)]';

%% LOSO CLASSIFICATION - GSR

nsbj = size(CognLoad, 2);

% Features and subjects for math

feat_total_CL = auCl_feat_GSR;
CL_sbjFeatindex = auCl_sbjFeatIndex_GSR';

% Features and subjects for music

feat_total_relax = audio_feat_GSR;
relax_sbjFeatindex = audio_sbjFeatIndex_GSR';

% Single table with all the features (both high and low CL)

feat_total_session = [feat_total_CL; feat_total_relax];

% Single table with all the subjects (both high and low CL)

index_Sbj_features = [CL_sbjFeatindex; relax_sbjFeatindex];

% Single table with all the subjects and the features

X_GSR = feat_total_session;
X_GSR.Subject = index_Sbj_features;

% Single table with all the labels (both high and low CL)

labels_GSR = repmat({'CognLoad'}, size(feat_total_CL, 1), 1);
labels_GSR = vertcat(labels_GSR, repmat({'relax'}, size(feat_total_relax, 1),1));  

Y_Pred_total_GSR = [];
Y_Real_total_GSR = [];

for i = 1 : nsbj

    % Define Training and test

    trainIdx = X_GSR.Subject ~= i;
    testIdx = X_GSR.Subject == i;
    
    X_Train = X_GSR(trainIdx, 1 : (end - 1));
    X_Test = X_GSR(testIdx, 1 : (end - 1));
    
    Y_Train = labels_GSR(trainIdx);
    Y_Test = labels_GSR(testIdx);
    
    % Define Cubic Polynomial SVM 

    template = templateSVM(...
        'KernelFunction', 'polynomial', ...
        'PolynomialOrder', 3, ...
        'KernelScale', 'auto', ...
        'Standardize', true);

    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels_GSR));
    
    Y_Pred_test = predict(mdl, X_Test);

    Y_Real_total_GSR = [Y_Real_total_GSR; Y_Test];
    Y_Pred_total_GSR = [Y_Pred_total_GSR; categorical(Y_Pred_test)];
end

% Evaluate performances

Y_Real_cat_GSR = categorical(Y_Real_total_GSR);
Y_Pred_cat_GSR = categorical(Y_Pred_total_GSR);

[C_t_total_GSR, order_t_GSR] = confusionmat(Y_Real_cat_GSR, Y_Pred_cat_GSR, 'order', unique(Y_Real_total_GSR));

accuracy_SVM_poly_GSR = sum(diag(C_t_total_GSR))/sum(sum(C_t_total_GSR));

precision_tmp_poly_GSR = diag(C_t_total_GSR)'./(sum(C_t_total_GSR,1));
recall_tmp_poly_GSR = (diag(C_t_total_GSR)./(sum(C_t_total_GSR,2)))';

f1_measure_tmp_poly_GSR = 2 *(precision_tmp_poly_GSR.*recall_tmp_poly_GSR)./(precision_tmp_poly_GSR+recall_tmp_poly_GSR);

%% LOSO CLASSIFICATION - PPG

nsbj = size(CognLoad, 2);
 
% Features and subjects for high cognitive load

feat_total_CL = auCl_feat_PPG;
CL_sbjFeatindex = auCl_sbjFeatIndex_PPG';
    
% Features and subjects for low cognitive load

feat_total_relax = audio_feat_PPG;
relax_sbjFeatindex = audio_sbjFeatIndex_PPG';
    
% Single table with all the features (both high and low cognitive load)

feat_total_session = [feat_total_CL; feat_total_relax];

% Single table with all the subjects (both high and low cognitive load)

index_Sbj_features = [CL_sbjFeatindex; relax_sbjFeatindex];

% Single table with all the subjects and the features

X_PPG = feat_total_session;
X_PPG.Subject = index_Sbj_features;

% Single table with all the labels (both high and low cognitive load)

labels_PPG = [repmat({'CognLoad'}, size(feat_total_CL, 1), 1); repmat({'relax'}, size(feat_total_relax, 1), 1)];  

Y_Pred_total_PPG = [];
Y_Real_total_PPG = [];

for i = 1 : nsbj
    
    % Define training and test sets

    X_Train = X_PPG(X_PPG.Subject ~= i, 1:end-1);    
    X_Test = X_PPG(X_PPG.Subject == i, 1:end-1);
    
    Y_Train = labels_PPG(X_PPG.Subject ~= i);    
    Y_Test = labels_PPG(X_PPG.Subject == i);
    
    % Define Cubic Polynomial SVM 

    template = templateSVM(...
        'KernelFunction', 'polynomial', ...
        'PolynomialOrder', 3, ...
        'KernelScale', 'auto', ...
        'Standardize', true);

    mdl = fitcecoc(...
        X_Train, ...
        Y_Train, ...
        'Learners', template, ...
        'Coding', 'onevsone', ...
        'ClassNames', unique(labels_PPG));
    
    Y_Pred_test = predict(mdl, X_Test);

    Y_Real_total_PPG = [Y_Real_total_PPG; Y_Test];
    Y_Pred_total_PPG = [Y_Pred_total_PPG; categorical(Y_Pred_test)];

end

% evaluate performances

Y_Real_cat_PPG = categorical(Y_Real_total_PPG);
Y_Pred_cat_PPG = categorical(Y_Pred_total_PPG);

[C_t_total_PPG, order_t_PPG] = confusionmat(Y_Real_cat_PPG, Y_Pred_cat_PPG, 'order', unique(Y_Real_total_PPG));

accuracy_SVM_poly_PPG = sum(diag(C_t_total_PPG))/sum(sum(C_t_total_PPG));

precision_tmp_poly_PPG = diag(C_t_total_PPG)'./(sum(C_t_total_PPG,1))
recall_tmp_poly_PPG = (diag(C_t_total_PPG)./(sum(C_t_total_PPG,2)))'

f1_measure_tmp_poly_PPG = 2 *(precision_tmp_poly_PPG.*recall_tmp_poly_PPG)./(precision_tmp_poly_PPG+recall_tmp_poly_PPG)

%% NEW CLASSIFICATION LEARNER 

% Important to notice that in this case, with respect to the Lab02
% activity, the available data are less. This is why the test result is not
% reliable and it's not near to the train resultsl.
% However, also in this case we can see how much GSR data give better results
% with respect to PPG data.
% Below are the results.

% GSR 

% With LOSO and Cubic SVM the accuracy reaches a value of 0.833.
% With Classification Learner, using a Cross-Validation at 5 folds and 10% of data for test, 
% the training reaches an accuracy of 0.848 with Cubic SVM, 
% with a test that stays at 0.667 of accuracy (but the test dataset is too 
% small, so it's not to consider too much).

% PPG

% With LOSO and Cubic SVM the accuracy reaches a value of 0.555.
% With Classification Learner, using a Cross-Validation at 5 folds and 10% of data for test, 
% the training reaches an accuracy of 0.607 with Cubic SVM (not the best), 
% with a test that reaches 1 of accuracy (same reasoning as before,
% too small test dataset).

%% OLD CLASSIFICATION LEARNER

[~, new_accuracy_GSR] = Imported_CL_GSR(X_CL_GSR, Y_CL_GSR);
[~, new_accuracy_PPG] = Imported_CL_PPG(X_CL_PPG, Y_CL_PPG);

% For what concerns the GSR Classification Learner, it was based on Tree
% Fine Tuned model. In this case, it reaches an accuracy of 0.778

% For what concerns the PPG Classification Learner, it was based on Cosine
% KNN model. In this case, it reaches an accuracy of 0.472

% In both cases, it's evident how much the models (Tree and KNN) are not 
% the best ones according to these data. Instead, Cubic SVM reached a very
% better result.




