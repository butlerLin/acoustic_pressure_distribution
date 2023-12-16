# acoustic_pressure_distribution
The code for data analysis and figure generation.

The code utilizes the open-source k-Wave toolbox (http://www.k-wave.org/) for performing time-domain acoustics and ultrasound simulations in complex and tissue-realistic media.

In lines 3-16, the code initially necessitates the definition of the dimensions and precision of the three-dimensional simulation region.

In lines 17-54, the code requires the specification of the medium parameters within the simulation region, such as sound speed, density, and absorption coefficient. Additionally, an appropriate simulation step size is set based on the medium's parameters.

In lines 55-68, the code specifies the transmission waveform of the ultrasound transducer.

In lines 69-82, the code defines the position of the ultrasound transducer.

In lines 83-93, the code specifies the positions of the receivers and designates the storage of the collected sound pressure during the simulation.

In lines 94-106, the simulation is executed with the specified parameters. The changing sound pressure throughout the simulation is observable, and at the conclusion of the simulation, the sound pressure values for each moment and each receiver are saved.

Detailed comments within the code provide specific instructions and explanations for the parameter settings.
