rem ======================================================
rem Running the AudioPacedTrials via the command line
rem allows you to pass parameters. If there are on
rem parameters passed the defaults are:
rem 12 trials, 30000 ms, and (Focus, Rest, Rest, Focus)
rem
rem 1st parameter is # of trials
rem 2nd parameter is trial length
rem 3rd parameter is the trial order - 2 = Focus, 1 = Rest
rem
rem Note: Trial order needs to be in double-quotes with 
rem commas in between (see below)
rem ======================================================
rem
rem
start /w /B AudioPacedTrials.EXE 100 30000 "2,1,1,2,"