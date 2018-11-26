#!/bin/bash
##Created and maintained by RootPrivacy.com##
##Current Version is release 1.0##
##If your version is >1.0, your client will probably not work.##

##Admin Check##
##function 1##
if [[ "$EUID" -ne 0 ]]; then
 echo -e "This script interacts with folders that only the administrator has access  to.\n please run as root/with the sudo command."
 echo
 echo -e "We will attempt to do this for you."
 echo
 read -p 'Press enter to continue'
##attempt fix##
 clear
 sudo bash ${0}
fi
clear
##Required packages for install.##
##function 2##
if [ $(dpkg-query -W -f='${Status}' sshpass 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo You are missing required files, we will aquire them now. This may take a while. 
  read -p 'Press enter to continue.'
  apt-get install sshpass;
fi
clear
##MAIN MENU##
##section 0##
echo "$(tput setaf 2)"
echo -e "
Welcome to the Linux SSH Management System\n\n\
1)Add a new Server\n\
2)Connect to an existing Server\n\
3)List existing Server(s) / Remove\n\
4)Exit\n\
"
read -p '' -e MenuProcessor
echo "$(tput sgr0)"
##exit##
if [[ "$MenuProcessor" = '4' ]];then
 exit
fi
##CONNECTION MENU##
##section 1##
if [[ "$MenuProcessor" = '2' ]]; then
##connect##
    echo 'Which server would you like to connect to?'
    ls /usr/bin/ServerConnections | egrep '\.sh$'
    read -p '' -e CONNECT
#my shitty and ugly asf check to see if the user is using .sh or not...#
     if test -f /usr/bin/ServerConnections/$CONNECT
        then
        /bin/bash /usr/bin/ServerConnections/$CONNECT
        else 
      /bin/bash /usr/bin/ServerConnections/$CONNECT.sh
     fi 
fi

##SERVER ADD MENU##
##section 3##
if [[ "$MenuProcessor" = '1' ]]; then
    #Server Information#
    PORT=22
    echo Server Name? 
    echo '(this is the name that you will type in order to connect, So make it memorable.)'
    read -p '' -e NAME
    echo Server IP? 
    read -p '' -e HOST
    echo Server Password?
    read -p '' -e PASS
    echo Would you like to set a custom port?
    read -p 'Y/N ' -e PORTQUESTION
     if [[ "$PORTQUESTION" = 'Y' ]]; then
     read -p 'Enter Port Number ' -e PORT
      fi
    ##Check for existance of folder.##
     if test -d /usr/bin/ServerConnections
     then
     echo
    ##
    else
     sudo mkdir /usr/bin/ServerConnections/
     echo Folder Created
      fi

    #FILE="/home/$USER/Desktop/test/$NAME.sh"

    ## Create File ##
    FILE="/usr/bin/ServerConnections/$NAME.sh"
    sudo /bin/cat <<-EOM >>$FILE
    #!/bin/bash
    sudo sshpass -p $PASS ssh -o StrictHostKeyChecking=no -p $PORT root@$HOST
EOM
   ## Encrypt File ##
# shc -f $FILE
# read -p 'Press to continue' -e 
##restart
 clear
sudo bash ${0}
##
fi
##FILE CHECK##
##section 3##
if [[ "$MenuProcessor" = '3' ]]; then
 ls /usr/bin/ServerConnections
 echo Would you like to remove an existing server? 
 read -p 'Y/N ' -e Rem
  if [[ "$Rem" = 'Y' ]]; then
 read -p 'Which server would you like to remove? ' -e FILE
#my shitty and ugly asf check to see if the user is using .sh or not...#
     if test -f /usr/bin/ServerConnections/$FILE
        then
        rm /usr/bin/ServerConnections/$FILE
        else 
       rm /usr/bin/ServerConnections/$FILE.sh
     fi 
 fi
#restart#
clear
sudo bash ${0}
##
fi
