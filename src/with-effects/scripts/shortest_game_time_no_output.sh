#!/bin/bash

if [ $1 ] && [ $1 -gt 0 ]
then
	REPETITIONS=$1
else
	REPETITIONS=1
fi

./shortest_game_time.sh $REPETITIONS &> /dev/null
