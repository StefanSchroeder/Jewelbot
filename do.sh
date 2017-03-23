#!/bin/bash
JEWELS=8

while [ 1 ] 
do 
	perl imager.pl $JEWELS > problem.txt 2> w.err
    grep "Median" w.err
	perl click_at_tile.pl --fixy=24 `perl solve.pl problem.txt`
	sleep 1
done

