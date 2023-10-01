nodejs() {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>>>> copying ${component} service file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
  echo -e "\e[36m>>>>>>>>>> copying mongodb repo file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  echo -e "\e[36m>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  echo -e "\e[36m>>>>>>>>>> install nodejs <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  yum install nodejs -y &>>${log}
  echo -e "\e[36m>>>>>>>>>> creating application user <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  useradd roboshop &>>${log}
  echo -e "\e[36m>>>>>>>>>> remove application dir <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  rm -rf /app &>>${log}
  echo -e "\e[36m>>>>>>>>>> create application dir <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mkdir /app &>>${log}
  echo -e "\e[36m>>>>>>>>>> download application code <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
  echo -e "\e[36m>>>>>>>>>> extract application code <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cd /app
  unzip /tmp/${component}.zip &>>${log}
  cd /app
   echo -e "\e[36m>>>>>>>>>> install nodejs dependencies <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
   echo -e "\e[36m>>>>>>>>>> install mongodb client <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  yum install mongodb-org-shell -y &>>${log}
   echo -e "\e[36m>>>>>>>>>> Load ${component} schema <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  mongo --host mongodb.pradevops.online </app/schema/${component}.js &>>${log}
   echo -e "\e[36m>>>>>>>>>> start ${component} service <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  systemctl daemon-reload &>>${log}
  systemctl enable ${component} &>>${log}
  systemctl restart ${component} &>>${log}
}