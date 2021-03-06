# This script goes through sound and TextGrid files in a directory,
# opens each pair of Sound and TextGrid, calculates the pitch f0 in ten subintervals
# of each labeled interval, and saves results to a text file.
# To make some other or additional analyses, you can modify the script
# yourself... it should be reasonably well commented! ;)
#
# This script is distributed under the GNU General Public License.
# Copyright 4.7.2003 Mietta Lennes
#
# Modified by Daniel Kiefer and redistributed under the same license (17 Nov 2009) in 2009 to read sound files and Text Grids as input.
#
#Modified by Chun L Chan (30 Jun 2010) to make use of PitchTier instead of Pitch object


form Analyze pitch f0s from labeled segments in files
	comment Directory of sound files
	text sound_directory ./
	sentence Sound_file_extension .WAV
	comment Directory of TextGrid files
	text textGrid_directory ./
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:
	text resultfile ./pitchresults.txt
	comment Sound file type
	choice SoundFileType: 2
		button Mono
		button Stereo - Left Channel is target
		button Stereo - Right Channel is target
	comment Pitch analysis parameters
	positive Time_step 0.01
	positive Minimum_pitch_(Hz) 25
	positive Maximum_pitch_(Hz) 600
endform

clearinfo

# Here, you make a listing of all the sound files in a directory.
# The example gets file names ending with ".wav" from current directory

Create Strings as file list... filelist 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Check if the result file exists:
if fileReadable (resultfile$)
	pause The result file 'resultfile$' already exists! Do you want to overwrite it?
	filedelete 'resultfile$'
endif

# Write a row with column titles to the result file:
# (remember to edit this if you add or change the analyses!)

titleline$ = "Filename  'tab$' word 'tab$'  vowel 'tab$' time 'tab$''tab$' 'tab$' f0 (Hz)'newline$'"
fileappend "'resultfile$'" 'titleline$'

# Go through all the sound files, one by one:

for ifile to numberOfFiles
	filename$ = Get string... ifile
	# A sound file is opened from the listing:
	if soundFileType = 1
		Read from file... 'sound_directory$''filename$'
	elsif soundFileType = 2
		Read two Sounds from stereo file... 'sound_directory$''filename$'
		select Sound right
		Remove
		select Sound left
	else
		Read two Sounds from stereo file... 'sound_directory$''filename$'	
		select Sound left
		Remove
		select Sound right
	endif
	# Starting from here, you can add everything that should be 
	# repeated for every sound file that was opened:
	soundname$ = selected$ ("Sound", 1)
	
	#using "To Pitch (cc)" instead of "To Pitch" or "To Pitch (ac)"
	#To Pitch... time_step minimum_pitch maximum_pitch
	To Pitch (ac)...  0 75 15 no  0.03 0.45 0.01 0.35 0.14 600
	Down to PitchTier

	
	tier = 2
	# Open a TextGrid by the same name:
	filenameNoExtension$ = filename$ - sound_file_extension$
	#printline 'filenameNoExtension$'
	gridfile$ = "'textGrid_directory$''filenameNoExtension$''textGrid_file_extension$'"
	#printline 'gridfile$'
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'
		# Find the tier number that has the label given in the form:
		#call GetTier 'tier$' tier

		numberOfIntervals = Get number of intervals... tier



		# Pass through all intervals in the selected tier:
		for interv from 1 to numberOfIntervals

			label$ = Get label of interval... tier interv
			
			labelgood$ = "F"
	

			call Isvowel 'label$' 'labelgood$'

			#printline 'label$' 'tab$' 'labelgood$'

			if  labelgood$ = "T" and label$ <> ""
				
				# if the interval has a vowel label
				start = Get starting point... tier interv
				end = Get end point... tier interv
				time_step = (end - start) /9
				#Get word for this sound
				call Getword start word$
				# get the Pitch over each subinterval
				
				
				timenow = start-time_step				

				for i from 1 to 10
					timenow = timenow+ time_step
					#select Pitch 'soundname$'
					#pitchi = Get value at time... timenow Hertz Linear

					select PitchTier 'soundname$'
					pitchi = Get value at time... timenow

					# Save result to text file:
					fileappend "'resultfile$'"  'filenameNoExtension$'  'tab$'  'word$'  'tab$' 'label$' 'tab$' 'timenow' 'tab$' 'pitchi'  'newline$' 
					#print "'resultfile$'"  'soundname$'  'tab$'  'word$'  'tab$' 'label$' 'tab$' 'timenow' 'tab$' 'pitchi'  'newline$' 
					
				endfor
				
				select TextGrid 'filenameNoExtension$'

			endif
		endfor
		# Remove the TextGrid object from the object list
		select TextGrid 'filenameNoExtension$'
		Remove

	endif
	
	# Remove the temporary objects from the object list
	select Sound 'soundname$'
	plus Pitch 'soundname$'
	plus PitchTier 'soundname$'
	Remove
	select Strings filelist
	# and go on with the next sound file!

endfor

Remove



procedure Isvowel label$ labelgood$


labelgood$ = "F"

v$ = "aeiouywAEIOUYWxxxxxxxxxxxx"
numvowels = length(v$)
i = 0


repeat
 
	current_token$ = left$ ( v$, 1 )
	where = startsWith(label$,current_token$)


	if where = 1
		labelgood$ = "T" 
		i = numvowels + 1	
	else
		numvowels = numvowels - 1
		v$ = right$ (v$, numvowels) ;
		i = i + 1
       endif
until i > numvowels
endproc


###
procedure Getword start_time word$

word$ = "na"

#select TextGrid 'soundname$'
select TextGrid 'filenameNoExtension$'

j = 1
numberofintervals = Get number of intervals... j

i = 1

repeat 

	starti = Get starting point... j i
	endi = Get end point... j i
	
	starti = starti + 0.0001
	endi = endi - 0.0001


	if starti <= start_time and start_time <= endi

		word$ = Get label of interval... j i

		i = numberofintervals + 1

	else
		i = i + 1
	endif

until i > numberofintervals

endproc