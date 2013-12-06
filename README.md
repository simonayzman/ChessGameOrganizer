ChessGameOrganizer

You can use this program to create a database of your games that (1) automatically sorts your games into folders based on specific chess game criteria, and (2) allows custom sorting of your games. 

In order to begin, simply compile the file and run it with an 'init' argument following the program name. This will create directories in your Documents folder automatically. Put all the .pgn files that you have into the folder called 'Unsorted'. There are two subdirectories, 'Favorites' and 'Remaining'. If you find some games to be particularly interesting, place them into the former directory. Otherwise, put them into 'Remaining'. 

Make sure to make a 'Player.txt' file in the 'Other' directory which has your chess name. For example, mine is sayzman.

If you run the program again--this time with no arguments--it will automatically sort the games.

If you run the program yet again, it will accept the following as command line arguments. Assume, for instance, that you wanted to see all the games in which you played white, your opponent's ELO rating was greater than 1500, and you won. You would write the following:

	./program_name self=white opponent>1500 self=won

Here, self will be the player included in the 'Player.txt' file. It isn't even necessary to include the 'self=' portion. The following is equivalent:

	./program_name white opponent>1500 won

	* Note that the 'opponent' must be kept. *

There will be a custom folder created with this specific sort in the 'Sorts' folder. The name will also be altered in the form:

	<WhitePlayerName> (<WhitePlayerELORating>) vs. <BlackPlayerName> (<BlackPlayerELORating>) [<MonthName> <Day>, <Year>].pgn       

Sorts are permitted by: self color, opponent color, self ELO rating, opponent ELO rating, self result, opponent result, and opponent name. Note that the result of 'draw' can arbitrarily given a side. The following are legitimate commands:

	self=black (or just 'black')
	opponent=white
	self>=1600 (or just '>=1600')
	opponent<1200
	self=won (or just 'won')
	opponent=lost
	opponent=Ilovechessxoxoxo




