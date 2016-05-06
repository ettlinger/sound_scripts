form gating in and out
    sentence Source_directory /Users/Administrator/Desktop/nac
    sentence File_extension .mp3
    positive Rise_time_(sec.) 2.0
    positive Fall_time_(sec.) 2.0
endform

Create Strings as file list... list 'source_directory$'/*'file_extension$'
number_of_files = Get number of strings
head_words = selected("Strings")
for a from 1 to number_of_files

    select Strings list
    filename$ = Get string... a
    Read from file... 'source_directory$'/'filename$'
    name$ = selected$ ("Sound")

    #compute rates of rise and fall
    duration = Get total duration
    fall_start = duration - fall_time
    rate_of_rise = 1/rise_time
    rate_of_fall = 1/fall_time

    Formula... if x <= rise_time then self*x*rate_of_rise else self fi
    Formula... if x >= fall_start then self*(duration-x)*(rate_of_fall) else self fi

    Write to WAV file... 'source_directory$'/ed/'name$'.wav
    Remove

endfor