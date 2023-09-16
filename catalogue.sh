echo -e "\e[36m>>>>>>>>>> copying service file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> copying repo file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> install nodejs <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> creating application user <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> remove application dir <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> create application dir <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> download application code <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
echo -e "\e[36m>>>>>>>>>> extract application code <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /app
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app
 echo -e "\e[36m>>>>>>>>>> install nodejs dependencies <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
npm install &>>/tmp/roboshop.log
 echo -e "\e[36m>>>>>>>>>> install mongodb client <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y &>>/tmp/roboshop.log
 echo -e "\e[36m>>>>>>>>>> Load catalogue schema <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.pradevops.online </app/schema/catalogue.js &>>/tmp/roboshop.log
 echo -e "\e[36m>>>>>>>>>> start catalogue service <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log
