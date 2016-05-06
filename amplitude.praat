# Originally written by Marc Ettlinger

form Extract pitch data from labelled points
   sentence Directory_name: C:\apps\praat\normalize\liz\b\
   sentence Norm_name: norm
   positive Time_step 0.01
endform

Create Strings as file list... list 'directory_name$'*b.wav
number_of_files = Get number of strings

Read from file... 'directory_name$'norm.wav
proto_duration = Get total duration

for a from 1 to number_of_files
	select Strings list
	file_name$ = Get string... 'a'
	object_name$ = left$(file_name$, length(file_name$)-4)

	Read from file... 'directory_name$''object_name$'.wav

	soundID = selected("Sound")

	select Sound Speech
	To Intensity... 100 0.0
	Down to IntensityTier
	plus soundID
	Multiply... yes

	Write to WAV file... 'directory_name$'normed_'object_name$'_new.wav
	Remove
	select Sound 'object_name$'
	plus IntensityTier norm
	plus Intensity norm
	Remove	
endfor
	
