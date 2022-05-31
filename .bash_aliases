RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;34m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No ColorNC='\033[0m' # No Color

alias ls='exa -lah --icons --color=always --group-directories-first'
alias la='exa -a --icons --color=always --group-directories-first'
alias l='exa -F --icons --color=always --group-directories-first'

alias ext_update='printf "${YELLOW}\nupdating flatpak${NC}\n" && flatpak update \
&& printf "${GREEN}\nupdating cargo${NC}\n" && cargo install-update -a \
&& printf "${MAGENTA}\nupdating snaps${NC}\n" && sudo snap refresh'

alias update='printf "${GREEN}updating main packages${NC}\n" && sudo apt update && sudo apt upgrade && ext_update'
alias dupdate='printf "${GREEN}updating main packages${NC}\n" && sudo apt update && sudo apt dist-upgrade && ext_update'
alias update_p='update;purge'
alias dupdate_p='dupdate;purge'

alias pkglist='apt list --installed'

pkginf(){

	PKGS=$(apt list --installed | grep $1 | cut -f1 -d"/")

	echo $(dpkg --list | grep $1 | wc --lines) 'package(s)'

	i=1

	for element in $PKGS
	do
		printf "$i:${YELLOW}$element${NC}\n$(apt-cache show ^$element$)\n"
		i=$((i+1))
	done
}

alias purge='printf "${RED}\npurging leftowers${NC}\n" && sudo apt autopurge \
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

alias msnake='snap run msnake'

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


update_freefilesync(){
	wget https://freefilesync.org/download/FreeFileSync_$1_Linux.tar.gz
	tar -xf ./FreeFileSync_$1_Linux.tar.gz
	./FreeFileSync_$1_Install.run
	rm ./FreeFileSync_$1*
}

get_power(){
	echo - | awk "{printf \"%.1f\", \
$(( \
  $(cat /sys/class/power_supply/BAT*/current_now) * \
  $(cat /sys/class/power_supply/BAT*/voltage_now) \
)) / 1000000000000 }" ; echo " W "
}
