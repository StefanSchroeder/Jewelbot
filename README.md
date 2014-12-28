Jewelbot
========

A bot to play Gweled on Linux written in Perl

It consist of four parts:

1. A shell script with an infinite loop to call the perl scripts to solve the puzzle.

2. A perl script to retrieve the puzzle from the screen (Using a screen shot and a primitive image diff to identify the pieces.)

3. A perl script to solve the puzzle, i.e. to find the tiles to click.

4. A small perl script to click the tiles.

The script is designed to run with the medium size board (tilesize 48x48). Using it for the other sizes requires soem tweaking of the threshold to distingush the symbols.


