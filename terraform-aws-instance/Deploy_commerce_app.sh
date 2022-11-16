#! /bin/bash
sudo apt update -y
# function showMessage() {
#     colorName=$1
#     message=$2
#     bold="\e[1m"
#     reset="\e[0m"

#     case $colorName in

#     red) color="\e[0;91m" ;;
#     blue) color="\e[0;94m" ;;
#     *) color="\e[0;94m" ;;

#     esac

#     echo -e "${color} ${bold} ${message} ${reset}"

# }

# function checkIfTheServiceIsActive() {
#     serviceName=$1
#     checkServiceStatus=$(systemctl is-active $serviceName)

#     if [ $checkServiceStatus = "active" ]; then
#         showMessage "blue" "service $serviceName Is active mood"

#     elif [ $checkServiceStatus = "inactive" ]; then
#         showMessage "red" "service $serviceName Is inactive mood"
#     else
#         showMessage "red" "Some thing Went Wrong"
#     fi
# }

# function isThePortConf(){
#  iSportOpen=$(sudo firewall-cmd --list-ports)
 
#  if [[ $iSportOpen = *$1* ]]
  
#  then

#     showMessage "blue" "This port is exist"
 
#  else
#      showMessage "red" "This port is not exist"

#  fi

# }

# echo "----------------------Deploy Pre-Requisites --------------------------------- "
# sudo apt update -y
# sudo apt  install -y firewalld > input
#  service firewalld start
#  systemctl enable firewalld
# checkIfTheServiceIsActive "firewalld"

# echo "----------------------Deploy and Configure Database --------------------------
# "
#  sudo apt  install -y mariadb-server >> input
#  service mariadb start
#  systemctl enable mariadb
# checkIfTheServiceIsActive "mariadb"

# echo "-----------------------Configure firewall for Database-------------------------"
#  firewall-cmd --permanent --zone=public --add-port=3306/tcp
#  firewall-cmd --reload
#  isThePortConf 3306




#  echo  "----------------------- Configure Database ------------------------- "
#  mysql -e "CREATE DATABASE ecomdb; CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
#  GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost'; FLUSH PRIVILEGES;"


#  echo  "------------------------------Load Product Inventory Information to database--------------------------- "

# cat > db-load-script.sql <<-EOF
#     USE ecomdb;
#     CREATE TABLE products (id mediumint(8) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Price varchar(255) default NULL, ImageUrl varchar(255) default NULL,PRIMARY KEY (id)) AUTO_INCREMENT=1;
#     INSERT INTO products (Name,Price,ImageUrl) VALUES ("Laptop","100","c-1.png"),("Drone","200","c-2.png"),("VR","300","c-3.png"),("Tablet","50","c-5.png"),("Watch","90","c-6.png"),("Phone Covers","20","c-7.png"),("Phone","80","c-8.png"),("Laptop","150","c-4.png");
# EOF

#     mysql < db-load-script.sql

# echo "----------------------------------------------Deploy and Configure Web -----------------------------------"
#     sudo sudo apt  install -y apache2 php php-mysql >> input
#     sudo service apache2 start
#     sudo systemctl enable apache2
#     sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
#     sudo firewall-cmd --reload
#     checkIfTheServiceIsActive apache2
#     isThePortConf 80

# echo "---------------------------------------------- Configure apache2 -----------------------------------"
# sudo sed -i 's/index.html/index.php/g' /etc/apache2/mods-available/dir.conf


# echo "----------------------------------------------Download the code----------------------------------------"
# sudo rm -rf /var/www/html/*
# sudo sudo apt  install -y git 
# git clone https://github.com/kodekloudhub/learning-app-ecommerce.git /var/www/html/ >> input

# sudo sed -i 's/172.20.1.101/localhost/g' /var/www/html/index.php
#  showMessage "blue" "done"

# echo "----------------------------------------------test the app----------------------------------------"
# Request=$(curl http://localhost)

# if [[ $Request = *VR* ]]
# then
#  showMessage "blue" "succeed deployment"
# fi