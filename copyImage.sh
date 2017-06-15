#!/bin/bash

disk=$1
img=$2
diskutil unmountDisk /dev/$disk
dd bs=1m if=$img of=/dev/r$disk
diskutil eject /dev/r$disk
