# Originally written by Marc Ettlinger

form Extract pitch data from labelled points
   sentence Directory_name: /Users/marc/Desktop/CogHealth/speechdat/
endform

Create Strings as file list... list 'directory_name$'*.wav
number_of_files = Get number of strings
writeFileLine("output.txt", "id, rms, mas, psd, meanh, sdh")
for a from 1 to number_of_files
	select Strings list
	file_name$ = Get string... 'a'
	object_name$ = left$(file_name$, length(file_name$)-4)

	Read from file... 'directory_name$''object_name$'.wav
	soundID = selected("Sound")
	
	rms = Get root-mean-square... 0.0 0.0
	
	To Pitch... 0.0 75.0 600.0
	select Pitch 'object_name$'
	mas = Get mean absolute slope... Hertz
	psd = Get standard deviation... 0.0 0.0 Hertz
	
	select Sound 'object_name$'
	To Harmonicity (cc)... 0.01 75 0.1 1.0
	select Harmonicity 'object_name$'
	meanh = Get mean... 0.0 0.0
	sdh = Get standard deviation... 0.0 0.0
	
	Remove
	select Sound 'object_name$'
	Remove
	select Pitch 'object_name$'
	Remove

	appendFileLine ("output.txt", object_name$, ",", rms, ",", mas, ",", psd, ",", meanh, ",", sdh)
endfor
	select Strings list
	Remove
