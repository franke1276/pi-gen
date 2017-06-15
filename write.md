 diskutil unmountDisk /dev/disk3
 sudo dd bs=1m if=/Users/franke/Downloads/2017-01-11-raspbian-jessie-lite.img of=/dev/rdisk3
  sudo diskutil eject /dev/rdisk3
