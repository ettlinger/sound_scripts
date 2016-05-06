# specify your directory here
directory$ = "/Users/Administrator/Desktop/_Iterative/"

select all
x=numberOfSelected("Sound")

for i from 1 to x
   select all
   name$=selected$("Sound", 1)
   select Sound 'name$'
   Write to WAV file... 'directory$''name$'.wav
   Remove
endfor
