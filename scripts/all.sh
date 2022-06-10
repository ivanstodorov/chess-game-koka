#!/bin/bash

if [ $1 ] && [ $1 -gt 0 ]
then
	COMPILATION_TIME_REPETITIONS=$1
else
	COMPILATION_TIME_REPETITIONS=1
fi

echo "Repetitions: $COMPILATION_TIME_REPETITIONS"
echo "Compilation time:"

/usr/bin/time -f '\tReal: %E\n\tUser: %U\n\tSystem: %S' ./compilation_time_no_output.sh $COMPILATION_TIME_REPETITIONS

echo ""

if [ $2 ] && [ $2 -gt 0 ]
then
	START_TIME_REPETITIONS=$2
else
	START_TIME_REPETITIONS=1
fi

echo "Repetitions: $START_TIME_REPETITIONS"
echo "Start time"

/usr/bin/time -f '\tReal: %E\n\tUser: %U\n\tSystem: %S' ./start_time_no_output.sh $START_TIME_REPETITIONS

echo ""

if [ $3 ] && [ $3 -gt 0 ]
then
        SHORTEST_GAME_TIME_REPETITIONS=$3
else
        SHORTEST_GAME_TIME_REPETITIONS=1
fi

echo "Repetitions: $SHORTEST_GAME_TIME_REPETITIONS"
echo "Shortest game time:"

/usr/bin/time -f '\tReal: %E\n\tUser: %U\n\tSystem: %S\n\tMaximum resident set size (kbytes): %M' ./shortest_game_time_no_output.sh $SHORTEST_GAME_TIME_REPETITIONS

echo ""

if [ $4 ] && [ $4 -gt 0 ]
then
        LONGEST_GAME_TIME_REPETITIONS=$4
else
        LONGEST_GAME_TIME_REPETITIONS=1
fi

echo "Repetitions: $LONGEST_GAME_TIME_REPETITIONS"
echo "Longest game time:"

/usr/bin/time -f '\tReal: %E\n\tUser: %U\n\tSystem: %S\n\tMaximum resident set size (kbytes): %M' ./longest_game_time_no_output.sh $LONGEST_GAME_TIME_REPETITIONS
