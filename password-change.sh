#!/bin/bash

echo "Which user would you like to change the password for?"

read user

echo "What would you like the new password to be?"

read password

echo "$user:$password" | chpasswd

echo "password changed successfully for user $user"
