#!/bin/bash

#======BIEN SU DUNG======
USER="root"
IP="10.5.51.20"
#========================
   echo "Co the thay doi User va IP trong file"

gen_key()
{
	if [[ -f $HOME/.ssh/${USER}_rsa ]]
	 then
	  echo "Ssh key exist. Ssh to host now!"
	  create_config_file
	  connect_by_ssh
	  exit 0;
	fi
   ssh-keygen -b 4096 -f "$HOME/.ssh/${USER}_rsa" -P "" 1>/dev/null
}

push_key_to_host()
{
   ssh-copy-id -i $HOME/.ssh/${USER}_rsa ${USER}@${IP} 1>/dev/null
}

create_config_file()
{
	if [[ ! -f $HOME/.ssh/config ]];
	 then 
	    touch $HOME/.ssh/config;
	else 
	     grep ${IP} $HOME/.ssh/config 1>/dev/null && grep ${USER} $HOME/.ssh/config 1>/dev/null
		if [[ $# -eq 0 ]];
		  then 
		      connect_by_ssh
		      exit 0;
		fi
	fi
	echo "Host ${IP}" >> $HOME/.ssh/config
	echo "	User ${USER}" >> $HOME/.ssh/config
	echo "	HostName ${IP}" >> $HOME/.ssh/config
	echo "	Port 22" >> $HOME/.ssh/config
	echo "	PasswordAuthentication no" >> $HOME/.ssh/config
	echo "	BatchMode yes" >> $HOME/.ssh/config
	echo "IdentityFile $HOME/.ssh/${USER}_rsa" >> $HOME/.ssh/config
}
connect_by_ssh()
{
  ssh ${IP}
}

gen_key
push_key_to_host
create_config_file
connect_by_ssh
