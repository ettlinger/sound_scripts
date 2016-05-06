# Originally written by Marc Ettlinger

form Extract pitch data from labelled points
   sentence Directory_name: /Users/Administrator/Desktop/Speaker2/
   sentence Norm_name: norm
   positive Time_step 0.01
   positive Minimum_pitch 75
   positive Maximum_pitch 600
endform

Create Strings as file list... list 'directory_name$'*.wav
number_of_files = Get number of strings

Read from file... 'directory_name$'norm.wav
proto_duration = Get total duration

for a from 1 to number_of_files
	select Strings list
	file_name$ = Get string... 'a'
	object_name$ = left$(file_name$, length(file_name$)-4)

	Read from file... 'directory_name$''object_name$'.wav
	soundID = selected("Sound")

	token_duration = Get duration
	ratio = proto_duration/token_duration
	To Manipulation... 'time_step' 'minimum_pitch' 'maximum_pitch'

	select Sound 'object_name$'
	Create DurationTier... 'object_name$' 0 'token_duration'
	Add point... 0 'ratio'
	plus Manipulation 'object_name$'
	Replace duration tier
	select DurationTier 'object_name$'
	Remove

	select Sound norm
	To Manipulation... time_step minimum_pitch maximum_pitch
	Extract pitch tier
	plus Manipulation 'object_name$'
	Replace pitch tier

	select PitchTier untitled
	Remove

	select Manipulation 'object_name$'
	Get resynthesis (PSOLA)
	soundID = selected("Sound")
	
	select Sound norm
	To Intensity... 100 0.0
	Down to IntensityTier
	plus soundID
	Multiply... yes
	Play

	Write to WAV file... 'directory_name$'/normed/'object_name$'_new.wav

	Remove
	select Manipulation 'object_name$'
	plus Manipulation norm
	plus Sound 'object_name$'
	plus IntensityTier norm
	plus Intensity norm
	Remove
	select Sound 'object_name$'
	Remove
	
endfor
	
