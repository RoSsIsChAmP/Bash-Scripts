#!/bin/bash

#lists current system users
cat /etc/passwd | grep /bin/bash

#asks the user the name of the user they want to change the password for
echo "Which user would you like to change the password for?"

#creates variable user
read user

#checks if the user exists
getent passwd $user > /dev/null

if [ $? -eq 0 ]; then

	echo "user $user exists"

else

	echo "user $user does not exist"

	exit 0	

fi

#asks the user what they want the new password to be
echo "What would you like the new password to be?"

#creates variable password
read password

#changes selected users password
echo "$user:$password" | chpasswd

#tells user the password updated successfully
echo "password changed successfully for user $user"
