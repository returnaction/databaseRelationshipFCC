#!/bin/bash
# Bingo Number Generator
echo -e "\n" ~~ Bingo Number Generator ~~
NUMBER=$(( RANDOM % 75 + 1 ))
TEXT="The next number is, "

if (( NUMBER <= 15 ))
then
    echo $TEXT B:$NUMBER
elif (( NUMBER <= 30 ))
then
    echo $TEXT I:$NUMBER
elif (( NUMBER <= 45 ))
then
    echo $TEXT N:$NUMBER
elif (( NUMBER <= 60 ))
then 
    echo $TEXT G:$NUMBER
else 
    echo $TEXT O:$NUMBER
fi