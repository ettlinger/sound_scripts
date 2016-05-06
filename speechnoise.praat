select Sound Speech
durn = Get duration
sr = Get sample rate
To Spectrum

select Spectrum Speech
nbin = Get number of bins
Create Sound... Phases 0 1 nbin randomUniform (0, 2 * pi)

select Spectrum Speech
Copy... Ranphas
Formula... if row = 1
... then Spectrum_Speech [1, col] * cos (Sound_Phases [1, col])
... + Spectrum_Speech [2, col] * sin (Sound_Phases [1, col])
... else Spectrum_Speech [1, col] * sin (Sound_Phases [1, col])
... + Spectrum_Speech [2, col] * cos (Sound_Phases [1, col])
... fi
To Sound
Extract part... 0 durn Rectangular 1.0 no
