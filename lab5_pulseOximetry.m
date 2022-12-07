%% Peak Detection
fs = 128;

% filter data with lowpass
% infrared data is used here to find heart rate
infrared = lowpass(infrared, 20, fs);
flatSegment = infrared(2300:2852);

% peak detection function, defined at bottom of file
[peakVal, peakPos, peakIndex] = detectPeaks(flatSegment, 286000);

ppgPeaks = peakIndex - 1;


%% Heart Rate Value
index = 1;
for i = 1:ppgPeaks-1
    e(index) = peakPos(i+1)-peakPos(i);
    index = index + 1;
end
heartRate = (60./mean(e))*128;
heartRateValues = (60./e)*128;


%% SpO2
t = 1:1:552;
t2 = 1/128;
% R-value constants
a = -16.666667;
b = 8.333333;
c = 100;
% peak detection of PPG
red = lowpass(red, 20, fs);
redSegment = red(2300:2852);
infraredSegment = flatSegment;

DCred = rms(redSegment);
DCinfrared = rms(flatSegment);


index = 1;
for i = 1:ppgPeaks-1
    e(index) = peakPos(i+1) - peakPos(i);
    index = index + 1;
end

% peak detection of red light
[ACredSignal, ACredPosition] = detectACPeaks(redSegment, DCred);

% peak detection of infrared light
[ACinfraSignal, ACinfraPosition] = detectACPeaks(infraredSegment, DCinfrared);




%% Function Definitions
function [peakVal, peakPos, peakInd] = detectPeaks(array, threshold)
    peakInd = 1;
    n = length(array);
    for i = 2 : n-1
        if array(i) > array(i-1) && array(i) > array(i+1) && array(i) > threshold
            peakVal(peakInd) = array(i);
            peakPos(peakInd) = i;
            peakInd = peakInd + 1;
        end
    end
end


function [ACsignal, peakPos] = detectACPeaks(array, DC)
    index = 1;
    n = length(array);
    for i=2:n-1
        if(array(i)>array(i-1) && array(i)>=array(i+1) && array(i) > DC)
            peakVal(index) = array(i);
            peakPos(index) = i;
            ACsignal(index) = array(peakPos(index));
            index = index + 1;
        end
    end
end

