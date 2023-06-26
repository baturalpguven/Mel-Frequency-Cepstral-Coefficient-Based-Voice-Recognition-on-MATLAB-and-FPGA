
  
# Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA


The main objective of this  project is to create a system that can recognize spoken numbers by using mel cepstral coefficients along with the L2 norm of each spoken number. In order to achieve this objective, voice recordings with a duration of 1-2 seconds were divided into 63 frames, where each frame corresponds to approximately 20 milliseconds. To address the issue of leakage during the computation of the Fast Fourier Transform (FFT), a 50% overlap was applied to each frame, along with windowing techniques. Additionally, Mel filter banks were utilized to transform these signals into a domain that is more perceptually relevant to humans, especially in terms of their ability to detect changes in lower frequencies. These transformed features were then compared using the Euclidean distance metric to determine the most likely outcome. 

## What is MFCC ?
<div align="center">
  
  ![filter_bank](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/6e968103-2bc8-4399-afd6-e8bc2a13a77c)

</div>

Mel Cepstral Coefficients (MCC) are a set of acoustic features commonly used in speech processing and recognition tasks. They are derived from the Mel Frequency Cepstral Coefficients (MFCC) which capture the spectral characteristics of speech signals. They have the fallowing equation:
$$M(f) = 2595 \log\left(1+ \frac{f}{700}\right)$$ .

MCC represents the logarithmic magnitude spectrum of speech signals transformed into the Mel frequency scale. The Mel scale is a perceptual scale that relates the frequency of a signal to how it is perceived by humans. It divides the frequency range into mel bins, which are non-linearly spaced to better align with human auditory perception.

To compute MCC, the following steps are typically followed:

Pre-emphasis: Apply a high-pass filter to emphasize higher frequencies in the speech signal.
Frame Blocking: Divide the pre-emphasized signal into frames of equal duration.
Windowing: Apply a window function (e.g., Hanning window) to each frame to reduce spectral leakage.
Fast Fourier Transform (FFT): Compute the spectrum of each frame using FFT.
Mel Filterbank: Apply a series of triangular filters on the magnitude spectrum to obtain the energy distribution in each mel frequency bin.
Logarithm: Take the logarithm of the filterbank energies to compress the dynamic range.
Discrete Cosine Transform (DCT): Apply DCT to the log filterbank energies to decorrelate the coefficients.
Select Coefficients: Keep a subset of the DCT coefficients, typically discarding the higher-order coefficients.
Normalization: Optionally, perform normalization on the selected coefficients to make them more robust to variations in speech intensity.
The resulting MCCs capture the spectral characteristics of the speech signal in a compact representation. They are often used as input features for tasks such as speech recognition, speaker identification, and emotion recognition.


## Control of The Overall System on FPGA

The control submodule was the first module that was developed. Its purpose was to serve as a control module responsible for managing all sub-elements of the system, as depicted in the figure below. Conceptually, this submodule can be viewed as the top-level module of the entire assignment. In addition to assuming this controlling role, we also implemented a framing technique with a 50% overlap within this lab. The ultimate goal of this lab was to bring together all the components and establish the operational flow of the entire system. This "flow" was achieved through a set of incoming and outgoing signals that were connected to and from this lab.

<div align="center">
  
  ![control_lab](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/d80ae4f9-8816-4871-8507-af9dab9926a3)

</div>

## Windowing of Each Frame on PFGA

<div align="center">

  ![hanning](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/ff84a5fe-6212-4044-b626-137144473faf)

</div>

The second submodule we implemented was the windowing module. This submodule receives its signals from the ADC submodule and uses the above window function. The main objective of this submodule  was to apply windowing to each frame that would be processed and transformed in FFT, thereby enhancing the accuracy of the transformation. This step can be considered as a preprocessing step that effectively prepares the data to achieve the most accurate transformation possible in subsequent stages. Some terms that could be relevant in describing this submodule include:

### Leakage
Leakage is a phenomenon that arises due to the non-periodicity and finite duration of signals. It refers to the situation where the analyzed signal "leaks" energy beyond its intended frequency boundaries. Consequently, this leads to distortions in both the magnitude and phase components, as the energy from the main frequency component spreads to adjacent frequencies. To mitigate the impact of this phenomenon, windowing techniques have been incorporated into our submodule implementation.

### Windowing

The process of windowing a signal involves applying an additional function to preprocess the data and enhance the accuracy of transformations on a time-limited, non-periodic signal. By incorporating a windowing function, unwanted disturbances and high-frequency signals present at the transition boundaries of the signal are smoothed out, effectively reducing leakage. This function facilitates the convergence of the signal to zero at these transition boundaries, thereby mitigating the effects and implications of signal discontinuities. While various windowing techniques exist for achieving this objective, our submodule implementation adhered to the instructed use of the Hanning windowing technique.

As a test signal Sinusoidal signal transform into following:

<div align="center">
  <img src="https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/43553742-763b-415a-809f-693c2989e0fb" style="width: 50%;" alt="windowed sinosoid">
</div>



<div align="center">
  
Windowed Sinosuid

</div>



Hanning windowing involves multiplying a signal by the Hanning window function, which gradually reduces the signal's amplitude toward zero at the edges. The Hanning coefficients correspond to precalculated values of the Hanning window function, facilitating the application of the windowing process.

The main functionality of the submodule called Lab Window is to process the 16384-bit sample obtained from  ADC, which represents a sound recording lasting approximately one and a half seconds. This submodule applies window functions to the frames generated by the CONTROL submodule. The total information is divided into 63 frames, each consisting of 512 bits. These frames are overlapped by 50%, meaning that once the first frame reaches half of its length, the subsequent frame begins. Submodule Control manages the timing of frame transitions, ensuring that each frame starts and ends appropriately.

In more detail, Submodule Control instructs the submodule to take the first frame from 0 to 512 bits, the second frame from 256 to 256+512 = 768 bits, and so on until it reaches the end of the information. The resulting frames are then sent to Lab FFT for signal transformation into the frequency domain representations.

The input received from the ADC submodule is 12-bit, while the Hanning coefficients have been generated using MATLAB and stored in a 512 8-bit RAM. Consequently, the output of this submodule becomes 20-bit.

## UART Connection with FPGA and PC
<div align="center">
  
  ![debug](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/4b2b9eea-5eec-41cd-bfbd-aec86b9bf39b)

</div>

This submodule serves as the primary verification module within the system. In this submodule, we have developed and implemented a UART connection between the FPGA platform and PC. It is integrated with a sub-system, and we have conducted functional verification by transferring data from the FPGA to MATLAB. This data transfer is facilitated through a UART interface and a USB connection.

During the implementation, UART triggered four times to transmit the 32-bit data has been utilized. To define the start and end of the transmission, we included 32-bit start data and 32-bit end data, both marked with asterisks (as shown in the above figure). To ensure proper transmission, we incorporated a basic finite state machine (FSM) to control the states and steps of the process. The 32-bit data transmission was divided into 8-bit blocks, each sent with start and stop bits, resulting in a 10-bit transmission for each block. The baud rate was set to 115200, which required dividing the BASYS3 clock to achieve the desired rate of roughly 867. We followed the UART protocol according to these specifications.


## ADC and FPGA Connection
<div align="center">
  
  ![adc](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/284a1d6c-7b93-4edd-9e91-3a8b2c040b7a)

</div>


The submodule called  ADC is responsible for receiving the recorded and filtered signal from Microphone. This module operates in correlation and parallel with the ADC card. As the name implies, ADC stands for analog-to-digital converter, and its primary function is to accurately quantize the incoming signal.

During operation, the ADC card initially outputs three zeros before providing the 12-bit data. Upon detecting the three zeros, the ADC module captures and stores the 12 bits of data, and then proceeds with the next set of 12 bits. This process continues until a total of 16384 bits is saved. The specific number of 16384 bits corresponds to a sound recording of approximately one and a half seconds. In other words, after completing this process, we obtain digitized sound recordings that are 16384 bits long, stored in a ROM with a width of 12 bits and a depth of 16384.

For this, we were required to establish a serial peripheral interface between the FPGA and the provided ADC module. To ensure proper communication, we had to adhere to the precise timing depicted in the above figure. This involved collecting data after the detection of the 3 leading zeros and waiting for the 5-clock cycle Tri-State. This configuration allows for the collection of nearly 500,000 samples per second, but with a decimation factor of 32, the number of samples is reduced to 16384. Additionally, a DC offset value is subtracted from the samples to preserve signal characteristics and represent them using 2's complement.

PS: ADC card type is ADC121S101 IC

## Microphone
The submodule called  Microphone performs two main tasks: amplification of the noise signal captured by the microphone to approximately 3 Volts and filtering of the incoming sound using a low-pass filter. The purpose of the amplification is to ensure that the signal reaches an appropriate level for further processing. The low-pass filter is designed to eliminate high-frequency signals that are not necessary for the subsequent steps of the assignment. As a result of the filtering process, the signal is constrained within the bandwidth of 100 Hz to 4.5 KHz.

The low-pass filter implemented in this lab has specific requirements. It is designed to provide an attenuation rate of 80 dB per decade. The gain of the filter within the frequency range of 100 Hz to 3 KHz should be within the range of -1 dB to 1 dB. The corner frequency of the filter, where the gain drops by 3 dB, is set to be in the range of 4 to 4.5 KHz.

The circuit on the breadboard operated fully and accurately, performing the necessary amplification and filtering of the recorded and filtered signal. The signal output from this submodule is then forwarded to the ADC submodule for further processing and comparison.

## MATLAB Simulation
<div align="center">
  
  ![matlab](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/14fd0014-3aa4-427c-bba0-b7dca3ac8613)

</div>


MATLAB is a simulation for the whole project that aims to generate the whole system in a MATLAB
environment and helps us to develop strategies to improve the accuracy of the voice recognition system.
As in the CONTROL submodule, 63 framing with %50 overlaps approximately 20 ms frames generated as can be
seen in the figure. Then hanning coefficients were applied to each frame to prevent leakage problems, and
the FFT of each frame was calculated. After this process power spectral density is multiplied with MEL
filter banks which approximately makes signals more sensitive to changes in the low frequency. MEL
filter banks have the following equation and figure inside 100Hz and 4KHz:
$$M(f) = 2595 \log\left(1+ \frac{f}{700}\right)$$ .

After multiplication logarithm and Discrete Cosine Transform (DCT) were applied, and resultant features were compared using Euclidian distance to classify incoming voice. Overall accuracy was around %80.





## FPGA and PC Implementation
<div align="center">
  
  ![VHDL_diagram](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/2e7c36fc-5774-4c69-94e3-e8f0ccc715b9)

</div>

The overall system of FPGA accomplishes framing, windowing, and sending the processed frames to MATLAB for further analysis. The FPGA implementation achieves around 70% accuracy in voice recognition. The system flow is illustrated in the provided diagrams.

<div align="center">

  ![overall_system](https://github.com/baturalpguven/Mel-Frequency-Cepstral-Coefficient-Based-Voice-Recognition-on-MATLAB-and-FPGA/assets/77858949/867016b3-82c3-4833-8339-5a9bb21e2008)

</div>

<div align="center">
  
Overall System

</div>

## Running the Code

To simulate the FPGA in MATLAB, use the `matlab_sim.m` file. For the entire system, use the VHDL files and the <a href="https://www.mathworks.com/help/instrument/serialexplorer-app.html"> MATLAB Serial Explorer tool </a>  to read data from FPGA to MATLAB, extract signals, and classify them using the `final_system.m` file.




## Special Thanks
Especially thanks to my esteemed group members for helping in the development process of this project.


