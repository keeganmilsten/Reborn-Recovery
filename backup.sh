#!/bin/bash
#
# Simple package list generation utility with a (Yad based) GUI, allowing users to recover lost programs.
#
#
# Requirements:
#    - yad
#    - exterm
#    - pacman
#
#
# Created by: Keegan at Reborn OS
# Inspired by: Palanthis at Reborn OS
function Save()
{
SAVING=$(sed '1q;d' /tmp/saving.txt)
echo "Saving Files To $SAVING"
sudo pacman -Qqen > $SAVING/packages-repository.txt
sudo pacman -Qqem > $SAVING/packages-AUR.txt
echo "Done"
}

function Recover()
{
SAVING=$(sed '1q;d' /tmp/saving.txt)
echo "Recovering Files From $SAVING..."
sudo pacman --needed -S - < $SAVING/packages-repository.txt --noconfirm
cat $SAVING/packages-AUR.txt | xargs yaourt -S --needed --noconfirm
echo "Done"
}

export -f Save Recover # for yad!

StartHere()
{

echo "Setting Directory..."
yad --center --width=350 --height=100 --form --separator='' --title="Reborn Recovery" --save --field="Save To:":CDIR >> /tmp/saving.txt
SAVING=$(sed '1q;d' /tmp/saving.txt)
echo "Using $SAVING Directory"
Next
}

Next()
{

SAVING=$(sed '1q;d' /tmp/saving.txt)

yad --form --center --title "Samba File Share" --width=400 \
--field="Folder to Save Package Lists To::RO" "$SAVING" \
--field='Create Packge List:FBTN' '@bash -c "Save"' \
--field='Recover Packages From List:FBTN' 'xterm -e "Recover"' \
--button='gtk-quit:1'
rm /tmp/saving.txt

}

StartHere "$@"
