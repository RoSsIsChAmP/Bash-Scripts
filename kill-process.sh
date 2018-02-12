#!/bin/bash

#lists running processes 
ps -A | less

read -p "Would you like to terminate a process?(y/n): " answer

if [ "$answer" == "y" ]; then

	read -p "Which process would you like to terminate? (PID): " task

	sudo kill -9 $task

else

	exit 0

fi
