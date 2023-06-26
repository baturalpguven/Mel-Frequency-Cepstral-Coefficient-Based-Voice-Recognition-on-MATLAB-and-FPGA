clear all;
close all;
clc;

% Define the duration of the recording and the frame size
duration = 2; % in seconds

name = {'zero_audio_data.wav', 'one_audio_data.wav', 'two_audio_data.wav', 'three_audio_data.wav', 'four_audio_data.wav', 'five_audio_data.wav', 'six_audio_data.wav', 'seven_audio_data.wav', 'eight_audio_data.wav', 'nine_audio_data.wav'};

for i = 1:10


    filename = name{i};
    % Record audio for the specified duration
    recObj = audiorecorder;
    fprintf('________________Start speaking for %s ________________ \n',filename)
    recordblocking(recObj, duration);
    disp('End of recording.');
    
    % Get the audio data and the sampling frequency
    audioIn = getaudiodata(recObj);
    fs = recObj.SampleRate;
    
    
        % Apply smoothing using a moving average filter
    windowSize = 32; % Adjust the window size as desired
    audioInSmooth = movmean(audioIn, windowSize);

    % Eliminate values lower than the threshold
threshold = 0.1; % Adjust the threshold as desired
audioIn(abs(audioIn) <= threshold) = 0;

            % Eliminate values lower than the threshold
    % audioIn(aaudioIn >= -threashold & audioIn <=threashold) = 0;

        firstNonZeroIndex = find(audioIn, 1);
    audioIn = audioIn(firstNonZeroIndex:end);
    
    % audioIn = audioIn-mean(audioIn);



    % Perform manual padding if necessary
    desiredLength = 16384;
    audioLength = length(audioIn);
    if audioLength < desiredLength
        padding = desiredLength - audioLength;
        audioIn = [audioIn; zeros(padding, 1)];
    elseif audioLength > desiredLength
        audioIn = audioIn(1:desiredLength);
    end
    % Save the audio data to a WAV file
    
    audiowrite(filename, audioIn, fs);
    
    figure;
    plot(audioIn)
    title(filename)
    fprintf('%s saved\n', filename)
end

%% starts with my voice Builtin Classifier

clc;
close all;
clear all;

% Define the duration of the recording
duration = 2; % in seconds
melcoeff = 32;
% Record the voice
recObj = audiorecorder;
disp("Start speaking...");
recordblocking(recObj, duration);
disp("Recording completed!");

% Get the recorded audio
audioIn = getaudiodata(recObj);
fs = recObj.SampleRate;

% Apply smoothing using a moving average filter
windowSize = 32; % Adjust the window size as desired
audioInSmooth = movmean(audioIn, windowSize);
    
% Eliminate values lower than the threshold
threshold = 0.1; % Adjust the threshold as desired
audioIn(abs(audioIn) <= threshold) = 0;

% Remove leading zeros
firstNonZeroIndex = find(audioIn, 1);
audioIn = audioIn(firstNonZeroIndex:end);

% Perform manual padding if necessary
desiredLength = 16384;
audioLength = length(audioIn);
if audioLength < desiredLength
    padding = desiredLength - audioLength;
    audioIn = [audioIn; zeros(padding, 1)];
elseif audioLength > desiredLength
    audioIn = audioIn(1:desiredLength);
end


audioIn = floor((audioIn .* (2^11)) + (2^11));


figure;
plot(audioIn);
title("New Record");
xlim([0,16384])

% Apply windowing to the known audio data
win = hann(512, "periodic");

win = floor((win .* (2^7)) + (2^7));
S = stft(audioIn, "Window", win, "OverlapLength", 256, "Centered", false);
S = floor((S .* (2^31)) + (2^31));
coeffs = mfcc(S, fs, "LogEnergy", "replace", "NumCoeffs", melcoeff);
coeffs = floor((coeffs .* (2^15)) + (2^15));

% Take the logarithm of MFCC coefficients
logCoeffs = log(coeffs);

% Load the MFCC coefficients of the known numbers
knownNumbers = ["zero_audio_data.wav", "one_audio_data.wav", "two_audio_data.wav", "three_audio_data.wav", "four_audio_data.wav", "five_audio_data.wav", "six_audio_data.wav", "seven_audio_data.wav", "eight_audio_data.wav", "nine_audio_data.wav"];
numKnownNumbers = numel(knownNumbers);
knownCoeffs = cell(numKnownNumbers, 1);

for i = 1:numKnownNumbers
    % Read audio data from the WAV file
    [knownAudio, knownFs] = audioread(knownNumbers(i));

    knownAudio = floor((knownAudio .* (2^11)) + (2^11));
    
    % Apply windowing to the known audio data
    win = hann(512, "periodic");

    win = floor((win .* (2^7)) + (2^7));
    S = stft(knownAudio, "Window", win, "OverlapLength", 256, "Centered", false);
    S = floor((S .* (2^31)) + (2^31));
    coeffs = mfcc(S, knownFs, "LogEnergy", "replace", "NumCoeffs", melcoeff);
    coeffs = floor((coeffs .* (2^15)) + (2^15));

    
    % Take the logarithm of MFCC coefficients for known audio
    knownCoeffs{i} = log(coeffs);
end

% Compute the L2 distance between the recorded voice and known numbers
distances = zeros(numKnownNumbers, 1);
for i = 1:numKnownNumbers
    knownCoeff = knownCoeffs{i};
    distances(i) = norm(dct(logCoeffs,10) - dct(knownCoeff,10),"fro");
end

% Find the index of the minimum distance
[minDistance, identifiedNumber] = min(distances);

disp(distances)
fprintf("Min distance: %.2f\n", minDistance);
fprintf("The identified number is %d\n", identifiedNumber - 1);

