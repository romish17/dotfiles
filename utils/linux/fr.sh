#!/bin/bash
setxkbmap fr # This should set your keyboard to azerty in a terminal emulator:
loadkeys fr # If on a console, that would be (as root):

sudo dkpg-reconfigure locales
sudo localectl set-x11-keymap fr
