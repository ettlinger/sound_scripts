################################################################
###  Read in all .wav files and .TextGrid files in a directory
################################################################

# This is a form that queries the user to specify the  name of 
# the directory that contains the files to be worked on

form Input directory name with final slash
    comment Enter directory where soundfiles are kept:
    sentence soundDir /Users/Administrator/Desktop/Pragphon/files/norm
endform

# lists all .wav files
Create Strings as file list... list 'soundDir$'/*.wav

numberOfFiles = Get number of strings
for ifile to numberOfFiles
   select Strings list
   fileName$ = Get string... ifile
   baseFile$ = fileName$ - ".wav"

   # Read in the Sound files and TextGrid files with that base name

   Read from file... 'soundDir$'/'baseFile$'.wav

endfor
################################################################
#END OF SCRIPT
################################################################