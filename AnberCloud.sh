#!/bin/bash

version=0.0.1

# Copyright (c) 2021
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the
# Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA
#
# Authored by: Kris Henriksen <krishenriksen.work@gmail.com>
#
# AnberCloud
#
DIR=~/AnberCloud
BINDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/AnberPorts/bin"
GITSRC=https://github.com/krishenriksen/AnberCloud.git
DEVICE=`cat /etc/machine-id`
SYNC=`cat $DIR/sync-id`
LOG=/tmp/AnberCloud.txt

export TERM=linux

if id "ark" &>/dev/null || id "odroid" &>/dev/null; then
  sudo chmod 666 /dev/tty1
fi

printf "\033c" > /dev/tty1

# clear log
rm -rf $LOG

ExitMenu() {
  if id "ark" &>/dev/null || id "odroid" &>/dev/null; then
    pgrep -f oga_controls | sudo xargs kill -9
    pgrep -f AnberCloud | sudo xargs kill -9
  else
    pgrep -f oga_controls | xargs kill -9
    pgrep -f AnberCloud | xargs kill -9
  fi	
}

gitit() {
  git -c core.sshCommand="ssh -i $DIR/.github/save" "$@"
}

Sync() {
  gitit pull git@github.com:krishenriksen/AnberCloud $1 2>&1 | tee -a $LOG

  # save
  rsync --progress -r -u ~/.config/retroarch/saves/* ./saves/ 2>&1 | tee -a $LOG
  rsync -r -u ~/.config/retroarch/states/* ./states/ 2>&1 | tee -a $LOG

  if id "ark" &>/dev/null || id "odroid" &>/dev/null; then
    rsync -r -u /opt/amiberry/savestates/* ./savestates/ 2>&1 | tee -a $LOG
  fi

  # load
  rsync --progress -r -u ./saves/* ~/.config/retroarch/saves/ 2>&1 | tee -a $LOG
  rsync -r -u ./states/* ~/.config/retroarch/states/ 2>&1 | tee -a $LOG

  if id "ark" &>/dev/null || id "odroid" &>/dev/null; then
    rsync -r -u ./savestates/* /opt/amiberry/savestates/ 2>&1 | tee -a $LOG
  fi

  gitit add saves savestates states 2>&1 | tee -a $LOG

  # stamp it
  gitit commit -m `date +%s` 2>&1 | tee -a $LOG

  gitit push --set-upstream origin $1 2>&1 | tee -a $LOG
}

SelectSync() {
  dialog --backtitle "System" --infobox "\nNow syncing with main device:\n\n$1" 7 56 > /dev/tty1

  gitit checkout -b $1 2>&1 | tee -a $LOG

  echo $1 > sync-id
  gitit add sync-id 2>&1 | tee -a $LOG

  # fix it
  git remote set-url origin git@github.com:krishenriksen/AnberCloud.git

  # stamp it
  gitit commit -m `date +%s` 2>&1 | tee -a $LOG

  gitit push --set-upstream origin $1 2>&1 | tee -a $LOG

  SYNC=$1

  Sync $SYNC
}

Setup() {
  dialog --backtitle "System" --infobox "\nPlease wait ..." 5 25 > /dev/tty1

  mkdir ~/.ssh
  ssh-keyscan -H github.com >> ~/.ssh/known_hosts 2>&1 | tee -a $LOG

  gitit config --global user.email "device@anbernic" 2>&1 | tee -a $LOG
  gitit config --global user.name $DEVICE 2>&1 | tee -a $LOG

  gitit clone $GITSRC $DIR 2>&1 | tee -a $LOG

  cd $DIR

  unzip .github/cloud.zip -d .github/
  chmod 600 .github/save
  gitit rm -f .github/cloud.zip

  gitit checkout -b $DEVICE 2>&1 | tee -a $LOG

  # clean up
  gitit rm -r AnberCloud.sh README.md

  # save states
  SelectSync $DEVICE
}

if [[ $1 == "sync" ]]; then
  if [ -d "$DIR/.git" ]; then
    cd $DIR
    Sync $SYNC
  fi
else
  if id "ark" &>/dev/null || id "odroid" &>/dev/null; then
    sudo $BINDIR/oga_controls AnberCloud &
  else
    $BINDIR/oga_controls AnberCloud &
  fi

  if [ ! -d "$DIR/.git" ]; then
    Setup
  fi

  if [ -d "$DIR/.git" ]; then
    cd $DIR

    # update list
    gitit pull

    options=(Exit "Exit")

    for BRANCH in `gitit branch --remotes --format='%(refname:short)' | cut -c 8-`; do
  	  if [[ $BRANCH != "HEAD" ]] && [[ $BRANCH != "master" ]]; then
        options+=($BRANCH "Device")
      fi
    done
    
    while true; do
      cmd=(dialog --clear --backtitle "AnberCloud - DEVICE ID: $DEVICE" --title " [ Syncing to $SYNC ] " --menu "You can use UP/DOWN on the D-pad and A to select:" "15" "56" "15")

      choices=$("${cmd[@]}" "${options[@]}" 2>&1 > /dev/tty1)

      for choice in $choices; do
        case $choice in
          Exit) ExitMenu ;;
          *) SelectSync $choice ;;
        esac
      done
    done  
  fi
fi