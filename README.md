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


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/8c0a521c-fcbc-4a6d-a418-087bdae5c1aa)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/dde41681-6fad-4252-bcb4-92e498ef3369)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/bad16f75-86d9-4e6b-a2b1-09c96d70de88)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/687cad08-7703-4418-82d8-ad68bdb31d5b)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/4505eeb8-3067-4eb6-a622-d57cefc2a416)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/74e8fa85-bc68-4efc-96fd-606b239d91c4)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/a32f84e6-58b4-440d-9a55-c4607cc9fb4e)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/2df55ffb-5ea3-4391-819f-40e1104fb44d)


![image](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/5b5f3744-b6b4-4610-a8aa-fd31fc4670d2)


Lab MATLAB is a simulation for the whole project that aims to generate the whole system in a MATLAB
environment and helps us to develop strategies to improve the accuracy of the voice recognition system.
As in the CONTROL lab, 63 framing with %50 overlaps approximately 20 ms frames generated as can be
seen in the figure. Then hanning coefficients were applied to each frame to prevent leakage problems and
the FFT of each frame was calculated. After this process power spectral density is multiplied with MEL
filter banks which approximately makes signals more sensitive to changes in the low frequency. MEL
filter banks have the following equation and figure inside 100Hz and 4KHz
M(f) = 2595log(1+f/700).




