form Equalize RMS levels
   real New_RMS_level_(Pa) 0.1
   comment Do it for all the WAV files in the source directory:
   text sourceDir C:\Documents and Settings\Eric\Desktop\LAUREN\BRADLO_LAB\sentences\Speaker_6\Plain
   comment Put the equalized WAV files in the target directory:
   text targetDir C:\Documents and Settings\Eric\Desktop\LAUREN\BRADLOW_LAB\sentences\Speaker_6\RMS_Plain

endform
Create Strings as file list... list 'sourceDir$'\*.wav
numberOfFiles = Get number of strings
for ifile to numberOfFiles
   select Strings list
   filename$ = Get string... ifile
   Read from file... 'sourceDir$'\'filename$'
   oldRmsLevel = Get root-mean-square... 0 0
   Formula... 'new_RMS_level'*self/'oldRmsLevel'
   extremum = Get absolute extremum... 0 0 None
   if extremum > 0.99
      exit We refuse to clip the samples in file "'sourceDir$'\'filename$'"!!!
   endif
   Write to WAV file... 'targetDir$'\'filename$'
	      
endfor
echo Successfully equalized 'numberOfFiles' WAV files.