#!/bin/bash
JEWELS=8
INC=/home/horst/perl5/lib/perl5/ 
while [ 1 ] 
do 
        echo "##################### Starting Retrieval."
	perl -I$INC imager.pl $JEWELS > problem.txt 2> w.err
	cat problem.txt
        echo "##################### Solving Problem"
	perl -I$INC click_at_tile.pl --jewels $JEWELS `perl solve.pl problem.txt`
	sleep 1
        echo "##################### DONE "
done

