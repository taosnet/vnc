#!/bin/sh

if [ -z "$1" ]; then
	echo Usage: $0 [-s] startup_program
	exit 1
fi

if [ "$1" = "-s" ] && [ -z "$2" ]; then
	echo Usage: $0 [-s] startup_program
	exit 1
fi

if [ "$1" = "-s" ]; then
	if ! [ -e "/etc/ssh/ssh_host_rsa_key" ]; then
		ssh-keygen -A
	fi
	/usr/sbin/sshd -f /etc/ssh/sshd_config
	shift 1
fi

if ! [ -d $HOME/.vnc ]; then
	mkdir $HOME/.vnc
fi

if ! [ -e $HOME/.vnc/passwd ]; then
	if [ -z "$VNC_PASSWORD" ]; then
		choose() { echo -n ${1:$((RANDOM%${#1})):1}; }
		password=$({
			for i in $(seq 1 8); do
				choose '!@#$%^0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
			done
		})
		echo Random Password Generated: $password
		echo "$password" | vncpasswd -f >$HOME/.vnc/passwd
	else
		echo "$VNC_PASSWORD" | vncpasswd -f >$HOME/.vnc/passwd
	fi
	chmod 600 $HOME/.vnc/passwd
	sleep 1
fi

# Create the xstartup file
echo "#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec $@" >$HOME/.vnc/xstartup
chmod 755 $HOME/.vnc/xstartup

# Run the vncserver
cd
exec /usr/bin/vncserver -fg
