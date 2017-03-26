#!/bin/bash
JEWELS=8

current_gweled_instance=$(pidof gweled)

[[ -z $current_gweled_instance ]] && echo "gweled is not running. Cannot play..." && exit

while [ 1 ] 
do 
	perl fetch_board.pl $JEWELS > problem.txt 2> w.err
	perl click_at_tile.pl --fixy=24 `perl solve.pl problem.txt`
    sleep 1
done

