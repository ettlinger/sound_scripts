form RMSNormalize
       comment Enter source directory (if other than local directory)
       sentence sourceDir /Users/Administrator/Desktop/_Iterative/raw2/
       comment Enter target directory (if other than local directory)
       sentence targetDir /Users/Administrator/Desktop/_Iterative/raw2/
       comment Enter the target RMS amplitude (in dB)
       real target_intensity 72.0
endform

Create Strings as file list... list 'sourceDir$'*.wav
numberOfFiles = Get number of strings
number = 1
for ifile from 1 to numberOfFiles
       select Strings list
       fileName$ = Get string... ifile
       Read from file... 'sourceDir$''fileName$'
       Scale intensity... target_intensity
       Write to WAV file... 'targetDir$''fileName$'
       number = number + 1
endfor
select Strings list
Remove