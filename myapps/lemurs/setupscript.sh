#! /bin/sh
#echo "Lemurs setup: disabling :display-manager.service"
sudo systemctl disable display-manager.service
echo "Lemurs setup: enabling lemurs.service"
sudo systemctl enable lemurs.service

