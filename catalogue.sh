echo -e "\e[36m>>>>>>>>>> copying service file <<<<<<<<<<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> copying repo file <<<<<<<<<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> install nodejs <<<<<<<<<<<<<<<<<<\e[0m"
yum install nodejs -y &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> creating application user <<<<<<<<<<<<<<<<<<\e[0m"
useradd roboshop &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> remove application dir <<<<<<<<<<<<<<<<<<\e[0m"
rm -rf /app &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> create application dir <<<<<<<<<<<<<<<<<<\e[0m"
mkdir /app &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> download application code <<<<<<<<<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> extract application code <<<<<<<<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip &>/tmp/roboshop.log
cd /app
 echo -e "\e[36m>>>>>>>>>> install nodejs dependencies <<<<<<<<<<<<<<<<<<\e[0m"
npm install &>/tmp/roboshop.log
 echo -e "\e[36m>>>>>>>>>> install mongodb client <<<<<<<<<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y &>/tmp/roboshop.log
 echo -e "\e[36m>>>>>>>>>> Load catalogue schema <<<<<<<<<<<<<<<<<<\e[0m"
mongo --host mongodb.pradevops.online </app/schema/catalogue.js &>/tmp/roboshop.log
 echo -e "\e[36m>>>>>>>>>> start catalogue service <<<<<<<<<<<<<<<<<<\e[0m"
systemctl daemon-reload &>/tmp/roboshop.log
systemctl enable catalogue &>/tmp/roboshop.log
systemctl restart catalogue &>/tmp/roboshop.log
