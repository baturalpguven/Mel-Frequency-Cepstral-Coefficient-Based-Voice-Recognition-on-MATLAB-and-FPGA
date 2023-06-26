# Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA


The primary objective of this senior project is to develop a system for the recognition of spoken
numbers utilizing mel cepstral coefficients in conjunction with the L2 norm of each spoken number. To
achieve this goal, voice recordings lasting 1-2 seconds in duration were partitioned into 63 frames, each
approximately corresponding to a duration of 20 ms [1]. Furthermore, to minimize the leakage problem
encountered during the computation of the Fast Fourier Transform (FFT), a 50% overlap was applied to
each frame, along with windowing techniques. Subsequently, mel filter banks were employed to transform
these signals into a domain that is more perceptually relevant to humans, particularly in terms of their
capacity to detect changes in lower frequencies[1]. These transformed features were then compared using
the Euclidean distance metric to determine the most likely outcome


<div align="center">

## Control of The Overall System on FPGA
![control_lab](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/d80ae4f9-8816-4871-8507-af9dab9926a3)

## Windowing of Each Frame on PFGA
![hanning](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/ff84a5fe-6212-4044-b626-137144473faf)

## UART Connection with FPGA and PC
![debug](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/4b2b9eea-5eec-41cd-bfbd-aec86b9bf39b)

## ADC and FPGA Connection
![adc](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/284a1d6c-7b93-4edd-9e91-3a8b2c040b7a)

## MATLAB Simulation
![matlab](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/14fd0014-3aa4-427c-bba0-b7dca3ac8613)

</div>

Lab MATLAB is a simulation for the whole project that aims to generate the whole system in a MATLAB
environment and helps us to develop strategies to improve the accuracy of the voice recognition system.
As in the CONTROL lab, 63 framing with %50 overlaps approximately 20 ms frames generated as can be
seen in the figure. Then hanning coefficients were applied to each frame to prevent leakage problems and
the FFT of each frame was calculated. After this process power spectral density is multiplied with MEL
filter banks which approximately makes signals more sensitive to changes in the low frequency. MEL
filter banks have the following equation and figure inside 100Hz and 4KHz
$$M(f) = 2595log(1+f/700)$$
%80 percent accuracy.

## MFCC
![filter_bank](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/6e968103-2bc8-4399-afd6-e8bc2a13a77c)

## FPGA and PC Implemantation
![VHDL_diagram](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/2e7c36fc-5774-4c69-94e3-e8f0ccc715b9)

%75 percent accuracy.




