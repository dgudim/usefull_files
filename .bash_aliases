alias ls='exa -lah'

alias ext_update='flatpak update && cargo install-update -a && sudo snap refresh'

alias update='sudo apt update && sudo apt upgrade && ext_update'
alias dupdate='sudo apt update && sudo apt dist-upgrade && ext_update'
alias update_p='update;purge'
alias dupdate_p='dupdate;purge'

alias pkglist='apt list --installed'
alias pkginf='/home/kloud/view_pkgs.sh'

alias purge='sudo apt autopurge \
&& sudo dpkg --purge $(COLUMNS=200 dpkg -l | grep "^rc" | tr -s " " | cut -d " " -f 2) 2> /dev/null'

alias labi_cpp='cd /home/kloud/Documents/mnt/shared/_163001/math-parser/compiled_binaries_linux && ./menu.sh'

uninstall_with_purge() {
    sudo apt remove "$@" && purge
}
alias uninst='uninstall_with_purge'
install_with_purge() {
    sudo apt install "$@" && purge
}
alias inst='install_with_purge'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias pls='sudo "$BASH" -c "$(history -p !!)"'

alias mkdir='mkdir -pv'

alias grep='grep --color=auto'

alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias ln='ln -i'

alias systemctl='sudo systemctl'

alias reboot='sudo reboot now'
alias shut='sudo shutdown now'

alias reload='source ~/.bashrc'
alias grub-reload='sudo grub-mkconfig -o /boot/grub/grub.cfg' 

alias start_mysql='systemctl start mysql && sudo systemctl status mysql'
alias mysql_workbench='start_mysql; snap run mysql-workbench-community'

alias bottles='flatpak run com.usebottles.bottles'
alias flatseal='flatpak run com.github.tchx84.Flatseal'
alias teamv='systemctl start teamviewerd.service && sudo systemctl status teamviewerd.service && teamviewer'

mount_shares(){
	echo -n "password for kloud: "
	read -s password
	echo
	
	FOLDERS=$(smbclient -L SAURON -U=kloud%$password | grep Disk | grep -v [$] | cut -d" " -f1)
	
	for folder in $FOLDERS
	do
		mkdir /home/kloud/Documents/MOUNT_SAURON/$folder
		echo $password | sudo -S mount -t cifs -o username=kloud,password=$password //SAURON/$folder /home/kloud/Documents/MOUNT_SAURON/$folder
		printf "mounted $folder\n"
	done
}

unmount_shares(){
	sudo umount ~/Documents/MOUNT_SAURON/*
	printf "unmounted all shares\n"
}

b_kill(){
	echo -n "password for kloud: "
	read -s password
	echo
	
	for run in {1..30}; do
		echo $password | sudo -S l2ping -i hci1 -s 668 -f $1 &
	done
}

spectrogram(){
	SAVEIFS=$IFS
	IFS=$(echo -en "\n\b")
	for elem in $(/usr/bin/ls)
	do
	    printf "processing $elem"
		ffmpeg -i "$elem" -lavfi showspectrumpic "/home/kloud/Documents/spectrograms/$elem.png" > /dev/null 2>&1 < /dev/null &
		sleep 1
	done
	IFS=$SAVEIFS
}

download_yt_playlist(){
	youtube-dl -f 'bestaudio[ext=m4a]' --output '%(uploader)s - %(title)s.%(ext)s' $1
}
