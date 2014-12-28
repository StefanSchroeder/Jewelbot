Jewelbot
========

A bot to play Gweled on Linux written in Perl

It consists of four parts:

1. A shell script with an infinite loop to call the perl scripts to solve the puzzle.

2. A perl script to retrieve the puzzle from the screen (Using a screen shot and a primitive image diff to identify the pieces.)

3. A perl script to solve the puzzle, i.e. to find the tiles to click.

4. A small perl script to click the tiles.

The script is designed to run with the medium size board (tilesize 48x48). Using it for the other sizes requires soem tweaking of the threshold to distingush the symbols.

Design
======

This bot was written as a proof-of-concept to learn more about the intricacies of automating GUIs. The algorithm and design went through several
iterations to find a stable solution. The concepts are laid out here for
your entertainment and information.

For each turn do the following.

Grab a screenshot of the window of the game. (Imager::Screenshot)

Extract the tiles (crop()).

Compare each tile to a dictionary of know tiles. If not in dict, add
it. If already in dict, we know it. 

Print the puzzle as ASCII to STDOUT (with index in dict as symbol).

Read the ASCII puzzle. 

Find all candidates that have two in a row and a neighbor that can be
swapped into place to form three in a row.

If no solution was found transpose the puzzle and try again.

Print the coords of the tiles to be swapped to STDOUT.

Find the windows of the game again and click the two tiles.

Repeat.

Interesting details
===================

Every other symbol has a different background color. To avoid having to deal with that, a border of width $frame is removed from each tile.

After clicking, you have to wait a bit until the click was executed.

After clicking the second tile you have to wait a bit until all the tiles have fallen into place.

The threshold for image comparison (when are two symbols identical) is
not computed but found empirically using the imagediff.pl script.


