#! /bin/bash
if [[ $(docker ps  -q) ]]
then    
  docker stop $(sudo docker ps   | cut -f 1 -d " " | tr -d " CONTAINER" | tr -d [:blank:] )
  docker system prune --volumes -a -f
else
  echo 'notthing'
  docker system prune --volumes -a -f

fi




