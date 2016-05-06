#This script has been written by Holger Mitterer, MPI Nijmegen, in order
# to apply the widely used technique of interpolation between two
# natural speech sounds to voiced samples. Usually, mixing two voiced
# sounds gives rise to the (essentially correct) experience of two
# speech sounds, not one ambiguous speech sound. (A possible
# explanation for this phenomenon is grouping by phase.)

#The script uses PSOLA to equate duration and pitch contour,
# and then interpolates between the manipulated sounds

#NOTE: use some zero-padding at the beginning and end
# of the sound to facilitate pitch estimation

# A different method using zero-padding of individual pitch
# periods has been proposed by Stevenson, Hogan, and Rozsypal (1985)
# in Behavior Research Methods, Instruments & Computers, 17(1), 102-106.


#if numberOfSelected("Sound") <> 2
#exit Select 2 Sounds
#endif
Read from file... /Users/Administrator/Desktop/Pragphon/steps-180/1.wav
Read from file... /Users/Administrator/Desktop/Pragphon/steps-180/2.wav

select Sound 1
plus Sound 2
s1$ = selected$("Sound",1)
s2$ = selected$("Sound",2)


select Sound 's1$'
l1 = Get finishing time
rms1 = Get root-mean-square... 0 0
#get sound length and rms value from Sound 1

select Sound 's2$'
l2 = Get finishing time
rms2 = Get root-mean-square... 0 0
#get sound length and rms value from Sound 2

plus Sound 's1$'
To Manipulation... 0.01 75 300
#cast both sound to Manipulation objects
# with time step of 10 ms and 75 Hz as lower and 300 Hz as upper
#f0 boundary (boundaries determined emprically for the male speaker

for snd from 1 to 2
#for both sounds
s$ = s'snd'$
l = l'snd'
t = ((l1 +l2)*0.5) / l
#variable t is now the mean length of the input sounds in relation to the sound selected
select Manipulation 's$'
Edit
editor Manipulation 's$'
Add duration point at... 0 't'
Close
endeditor
Get resynthesis (PSOLA)
Rename... temp'snd'
endfor
#the sounds temp1 and temp2 now have exaclty the same length


select Sound temp1
plus Sound temp2
To Manipulation... 0.01 75 300
for snd from 1 to 2
select Manipulation temp'snd'
Extract pitch tier
Rename... p'snd'
endfor
# get the pitch contour of both sounds


select PitchTier p1
Formula... 0.5*(self[col] + PitchTier_p1[col])
# calculate the mean pitch contour
Copy... mean

for snd from 1 to 2
#for both sounds
select Manipulation temp'snd'
plus PitchTier p1
Replace pitch tier
#use the mean pitch contour
select Manipulation temp'snd'
Get resynthesis (PSOLA)
Rename... org'snd'
endfor

# The two sounds org1 and org2 now have the same length
# and the same pitch contour.


for s from 0 to 19
select Sound org1
Copy... step's'
f = 's'/20
#factor fof the second sound, going from 0 to 1 in steps of 0.1

inv = 1 - 'f'
#factor of the first sound, going from 1 to 0 in steps of 0.1
Formula... self[col] * 'inv'+ Sound_org2[col] * 'f'
nowrms = Get root-mean-square... 0 0
rmsm= 0.5*rms2+ rms1 * 0.5
Formula... self * 'rmsm'/ 'nowrms'
#give sound the mean root-mean-square (rms) of sample values of bothsounds
# if rms is thought to be a cue in itself, the following alternative for the calculation of
# the following formula may be used, which also interpolates rms
#rmsm= 'f' * rms2+ rms1 * 'inv'
endfor

select Manipulation 's1$'
plus Manipulation 's2$'
plus Manipulation temp1
plus Manipulation temp2
plus Sound temp1
plus Sound temp2
plus PitchTier p1
plus PitchTier p2
Remove
#clean up the Objects window
