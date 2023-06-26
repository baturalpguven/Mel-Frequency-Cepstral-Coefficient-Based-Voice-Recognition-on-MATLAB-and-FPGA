
  
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




## Control of The Overall System on FPGA

Lab control was the first lab that we implemented. As it was also suggested in the lab assignment
specifications section, it was designed to act as a controlling module to keep track of every sub-element of
the system as can be seen in Figure 1. One could think of this lab as a top module of the entire assignment.
While achieving this operator status, we also implemented framing overlapped by 50% in this lab. This lab
would ultimately tie all ends together and enable the operation flow of the entire system. This mentioned
“flow” is attained by a set of signals incoming to and outgoing from this lab.
<div align="center">
  
  ![control_lab](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/d80ae4f9-8816-4871-8507-af9dab9926a3)

</div>

## Windowing of Each Frame on PFGA
The second lab that we implemented was Lab Window. This part of the lab takes its signals from the Lab
ADC module. As though when we were implementing this part of our project we did not have a readily set
ADC module at hand, we connected our Lab Window with Lab ADC along the way. These transitions
between different lab modules are managed with lab control.
The primary operative duty of this particular lab assignment was to implement windowing to each frame
that will be processed and transformed in Lab FFT, to increase the accuracy of the transformation. This
step could be seen as a preprocessing step that essentially prepares the data to attain the cleanest
transformation possible in further steps of the assignment. Some terms that could be useful in the
description of this lab include:
### Leakage
Leakage is the phenomenon that stems from the non-periodicity and the finite duration of the signals. It is
essentially the occurrence where the signal at hand “leaks” energy outside its analyzed frequency
boundaries. This ultimately results in the distortion of the magnitude and the phase components as the
energy from the primary frequency component of the signal spreads to neighboring frequencies. To minimize
this phenomenon’s effects we have included windowing in our assignment[6].

### Windowing
The process of windowing a signal refers to the application of an additional function to preprocess the data
for further steps and increase the accuracy of the transformations of a time-limited, non-periodic signal.
With the inclusion of a windowing function, the unwanted disturbances and high-frequency signals that
are at the transition boundaries of the signal are smoothened, allowing a considerable amount of leakage to
be eliminated. This function essentially makes the signal at hand converge to zero at these transition
boundaries and ultimately reduces the effects and implications of discontinuities between each part of the
signal. Although many different windowing techniques could be implemented for the same purpose, in
our project we were instructed to utilize Hanning windowing

<div align="center">
  <img src="https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/43553742-763b-415a-809f-693c2989e0fb" style="width: 50%;" alt="windowed sinosoid">
</div>


<div align="center">
  
Windowed Sinosuid

</div>

<div align="center">

  ![hanning](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/ff84a5fe-6212-4044-b626-137144473faf)

</div>

Hanning windowing is the process of multiplying a signal by the Hanning window function, which
gradually decreases the signal's amplitude towards zero at the edges as can be seen in Figure 2. The
Hanning coefficients correspond to the precalculated values of the Hanning window function.
With a brief understanding of the terminology, the main operating principle of Lab Window is that it takes
the 16384 bits of the sample that was generated from Lab ADC, a signal that represents a sound recording
of approximately one and a half seconds, and applies window functions to the frames that are generated
via CONTROL lab. In total the information is divided into 63 frames of 512 bits. After the partition of the
signal, these 63 frames are then overlapped by 50%. This implies that once a first frame reaches half of its
length, the later frame begins. Lab control is also involved with this process as it manages the beginnings
and the ends of each frame accordingly. This could be summarized as Lab Control instructs to take the
first frame from 0 to 512, it then instructs the second frame to be from 256 to 256+512 = 768, until it
reaches the end of the information. The resulting frames are then sent to Lab FFT to transform the signals
according to their frequency domain representations [7].
The input from the ADC lab is 12-bit and Hanning coefficients have been generated via MATLAB and
stored inside 512 8-bit RAM. The resultant output of this lab then becomes 20-bit.

## UART Connection with FPGA and PC
<div align="center">
  
  ![debug](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/4b2b9eea-5eec-41cd-bfbd-aec86b9bf39b)

</div>

Lab Debug, as its name also suggests, was the main verification module of the system. In this lab work,
we have created and deployed a debugger on the FPGA. This debugger was integrated with a sub-system
and we have verified its functionality by transferring data from the FPGA to MATLAB. This data transfer
is achieved using a UART interface and a USB connection.
While implementing this assignment, as it was suggested, we made use of a UART that was triggered four
times to transmit the 32-bit data at hand. To define the start and end of the transmission, as was suggested
in the lab instructions, we have included one star and one end data that were both 32-bits each as can be
seen in Figure 3. To achieve proper transmission, we have included a basic FSM to control the states and
the steps of the process and divided 32-bit data transmission into 8-bit blocks, and sent them with initial
start and stop bits which made each transmission 10-bit. The baud rate is 115200 which means dividing
the BASYS3 clock into the required baud rate which roughly gives 867. According to these requirements,
the UART protocol was followed[6].
At the end of this lab work, we have achieved a debug module that was accurately operating. The
debugger that we created managed to transmit the incoming information from the FPGA to the virtual
system, our computers and we were able to successfully write and observe the incoming data from
MATLAB.

## ADC and FPGA Connection
<div align="center">
  
  ![adc](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/284a1d6c-7b93-4edd-9e91-3a8b2c040b7a)

</div>

Lab ADC receives the recorded and filtered signal from Lab PCB. This module operates in correlation and
parallel with our ADC card. As its name suggests, stands for analog to digital converter, and its primary
purpose is to properly quantize the incoming signal.
While operating the ADC card initially gives out three zeros and then continues by providing the 12-bit
data. After observing the three zeros, the ADC module takes 12 bits of data and properly stores it, and then
continues the process with the following 12 bits. This process goes on until the saved data reaches 16384
bits. The reason behind this specific number is that it results in a recording of approximately one and a
half seconds. In other words, after implementing this process, we will have 16384 bits, therefore one and a
half seconds long, sound recordings that are digitized and stored in a ROM that is 12-bit width and 16384
depth.
This lab required us to apply a serial peripheral interface with the FPGA and ADC module that was given
to us. To make proper communication the exact timing of Figure 4 must be accomplished and collect data
after 3 leading zeros and wait for the 5 clock cycle Tri-State. This allows nearly 500k samples in a second
but with 32-factor decimation, samples become 16384, and finally, DC offset value is subtracted to ensure
preserving signal characteristics and represent via 2’s complement.
As a result of this lab Collecting analog signals which are spoken numbers and writing into dual port
RAM was accomplished.

## PCB
The operative duties of lab pcb include the amplification of noise coming from the microphone to
approximately 3 Volts and the filtering of the incoming sound with a low pass filter, eliminating
high-frequency signals that would then be unnecessary in the further steps of the assignment. The resulting
signal is then a signal in the bandwidth of 100 Hz to 4.5 KHz. The filter in this lab has The filter shall
have 80dB/decade attenuation and its gain from 100 Hz to 3 KHz shall be in the -1 to 1 dB range. The 3
dB corner frequency of the LPF shall be in the 4 to 4.5 KHz range. Our implementation of this lab did not
include a PCB as our design experienced several complications in the implementation process, these will
be further dove into in the discussion and conclusion section. Because of these setbacks, we decided to
implement the circuit on a breadboard, which was operating fully and accurately. The recorded and filtered
signal then goes to the Lab ADC part of this project, to be processed furtherly before its comparison.
## MATLAB Simulation
<div align="center">
  
  ![matlab](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/14fd0014-3aa4-427c-bba0-b7dca3ac8613)

</div>


Lab MATLAB is a simulation for the whole project that aims to generate the whole system in a MATLAB
environment and helps us to develop strategies to improve the accuracy of the voice recognition system.
As in the CONTROL lab, 63 framing with %50 overlaps approximately 20 ms frames generated as can be
seen in the figure. Then hanning coefficients were applied to each frame to prevent leakage problems and
the FFT of each frame was calculated. After this process power spectral density is multiplied with MEL
filter banks which approximately makes signals more sensitive to changes in the low frequency. MEL
filter banks have the following equation and figure inside 100Hz and 4KHz
$$M(f) = 2595 \log\left(1+ \frac{f}{700}\right)$$

%80 percent accuracy.

## MFCC
<div align="center">
  
  ![filter_bank](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/6e968103-2bc8-4399-afd6-e8bc2a13a77c)

</div>

Mel Cepstral Coefficients (MCC) are a set of acoustic features commonly used in speech processing and recognition tasks. They are derived from the Mel Frequency Cepstral Coefficients (MFCC) which capture the spectral characteristics of speech signals.

MCC represents the logarithmic magnitude spectrum of speech signals transformed into the Mel frequency scale. The Mel scale is a perceptual scale that relates the frequency of a signal to how it is perceived by humans. It divides the frequency range into mel bins, which are non-linearly spaced to better align with human auditory perception.

To compute MCC, the following steps are typically followed:

Pre-emphasis: Apply a high-pass filter to emphasize higher frequencies in the speech signal.
Frame Blocking: Divide the pre-emphasized signal into frames of equal duration.
Windowing: Apply a window function (e.g., Hamming window) to each frame to reduce spectral leakage.
Fast Fourier Transform (FFT): Compute the spectrum of each frame using FFT.
Mel Filterbank: Apply a series of triangular filters on the magnitude spectrum to obtain the energy distribution in each mel frequency bin.
Logarithm: Take the logarithm of the filterbank energies to compress the dynamic range.
Discrete Cosine Transform (DCT): Apply DCT to the log filterbank energies to decorrelate the coefficients.
Select Coefficients: Keep a subset of the DCT coefficients, typically discarding the higher-order coefficients.
Normalization: Optionally, perform normalization on the selected coefficients to make them more robust to variations in speech intensity.
The resulting MCCs capture the spectral characteristics of the speech signal in a compact representation. They are often used as input features for tasks such as speech recognition, speaker identification, and emotion recognition.

## FPGA and PC Implementation
<div align="center">
  
  ![VHDL_diagram](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/2e7c36fc-5774-4c69-94e3-e8f0ccc715b9)

</div>

The overall system on FPGA accomplishes framing, windowing, and sending the processed frames to MATLAB for further analysis. The FPGA implementation achieves around 70% accuracy in voice recognition. The system flow is illustrated in the provided diagrams.

<div align="center">

  ![overall_system](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/867016b3-82c3-4833-8339-5a9bb21e2008)

</div>

<div align="center">
  
Overall System

</div>

## Running the Code

To simulate the FPGA in MATLAB, use the `matlab_sim.m` file. For the entire system, use the VHDL files and the <a href="https://www.mathworks.com/help/instrument/serialexplorer-app.html"> MATLAB Serial Explorer tool </a>  to read data from MATLAB, extract signals, and classify them using the `final_system.m` file.






