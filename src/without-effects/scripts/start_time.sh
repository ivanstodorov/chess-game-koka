#!/bin/bash

cd ..

if [ $1 ] && [ $1 -gt 0 ]
then
	REPETITIONS=$1
else
	REPETITIONS=1
fi

echo 'Repetitions: '$REPETITIONS

for (( i = 1; i <= $REPETITIONS; i++ ))
do
	rm -rf .koka
	./no-game
done

cd -
