%% PCB ADC WINDOW DEBUG
clc;
close all;
% clear all;

% Define the duration of the recording
duration = 2; % in seconds
melcoeff = 32;


% Get the recorded audio
audioIn = serialport_data48(2:end-1); %%%%%%%%%%% vura editle
fs = 8000;

% Apply smoothing using a moving average filter
windowSize = 32; % Adjust the window size as desired
audioInSmooth = movmean(audioIn, windowSize);
    
% Eliminate values lower than the threshold
threshold = 0.1; % Adjust the threshold as desired
audioIn(abs(audioIn) <= threshold) = 0;



% Remove leading zeros
firstNonZeroIndex = find(audioIn>3700, 1);
audioIn = audioIn(firstNonZeroIndex:end-1);

% Perform manual padding if necessary
desiredLength = 16384;
audioLength = length(audioIn);
if audioLength < desiredLength
    padding = desiredLength - audioLength;
    audioIn = [audioIn, ones(1,padding)*3600];
elseif audioLength > desiredLength
    audioIn = audioIn(1:desiredLength);
end


% audioIn = floor((audioIn .* (2^11)) + (2^11));


% figure;
% plot(audioIn);
% title("New Record");
% xlim([0,16384])

% Apply windowing to the known audio data
win = hann(512, "periodic");

win = floor((win .* (2^7)) + (2^7));
S = stft(audioIn, "Window", win, "OverlapLength", 256, "Centered", false);
S = floor((S .* (2^31)) + (2^31));
coeffs = mfcc(S, fs, "LogEnergy", "replace", "NumCoeffs", melcoeff);
coeffs = floor((coeffs .* (2^15)) + (2^15));

% Take the logarithm of MFCC coefficients
logCoeffs = log(coeffs);




knownNumbers = [serialport_data16(2:end-1);serialport_data17(2:end-1);serialport_data18(2:end-1);serialport_data19(2:end-1);serialport_data20(2:end-1);serialport_data21(2:end-1);serialport_data22(2:end-1);serialport_data23(2:end-1);serialport_data24(2:end-1);serialport_data25(2:end-1)];
knownCoeffs = cell(10, 1);
for i = 1:10
    knownAudio_new = knownNumbers(i,:);


        % Apply smoothing using a moving average filter
    windowSize = 32; % Adjust the window size as desired
    audioInSmooth_new = movmean(knownAudio_new, windowSize);
        
    % Eliminate values lower than the threshold
    threshold = 0.1; % Adjust the threshold as desired
    knownAudio_new(abs(audioInSmooth_new) <= threshold) = 0;
    
    
    
    % Remove leading zeros
    firstNonZeroIndex = find(knownAudio_new>3700, 1);
    knownAudio_new = knownAudio_new(firstNonZeroIndex:end-1);
    
    % Perform manual padding if necessary
    desiredLength = 16384;
    audioLength = length(knownAudio_new);
    if audioLength < desiredLength
        padding = desiredLength - audioLength;
        knownAudio_new = [knownAudio_new, ones(1,padding)*3600];
    elseif audioLength > desiredLength
        knownAudio_new = knownAudio_new(1:desiredLength);
    end
    
    % Apply windowing to the known audio data
    win = hann(512, "periodic");

    win = floor((win .* (2^7)) + (2^7));
    S = stft(knownAudio_new, "Window", win, "OverlapLength", 256, "Centered", false);
    S = floor((S .* (2^31)) + (2^31));
    coeffs = mfcc(S, 8000, "LogEnergy", "replace", "NumCoeffs", melcoeff);
    coeffs = floor((coeffs .* (2^15)) + (2^15));

    
    % Take the logarithm of MFCC coefficients for known audio
    knownCoeffs{i} = log(coeffs);

end

% Compute the L2 distance between the recorded voice and known numbers
distances = zeros(10, 1);

for i = 1:10
knownCoeff = knownCoeffs{i};
distances(i) = norm(dct(logCoeffs,10) - dct(knownCoeff,10),"fro");

end


% Find the index of the minimum distance
[minDistance, identifiedNumber] = min(distances);
disp(distances)
fprintf("Min distance: %.2f\n", minDistance);
fprintf("The identified number is %d\n", identifiedNumber - 1);

