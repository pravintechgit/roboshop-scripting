log=/tmp/roboshop.log
func_exit_status() {
  if [ $? -eq 0 ]; then
      echo -e "\e[32m SUCCESS \e[0m"
      else
        echo -e "\e[31m FAILURE \e[0m"
    fi
}
func_apppreq() {
   echo -e "\e[36m>>>>>>>>>> copying ${component} service file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
   cp ${component}.service /etc/systemd/system/${component}.service &>>${log}
   func_exit_status
    echo -e "\e[36m>>>>>>>>>> creating application user <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    id roboshop &>>${log}
    if [ $? -ne 0 ]; then
    useradd roboshop &>>${log}
    fi
    func_exit_status
    echo -e "\e[36m>>>>>>>>>> remove application dir <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    rm -rf /app &>>${log}
    func_exit_status
    echo -e "\e[36m>>>>>>>>>> create application dir <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mkdir /app &>>${log}
    func_exit_status
    echo -e "\e[36m>>>>>>>>>> download application code <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}
   func_exit_status
    echo -e "\e[36m>>>>>>>>>> extract application code <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app
    func_exit_status
}

func_systemd() {
     echo -e "\e[36m>>>>>>>>>> start ${component} service <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}
    func_exit_status
}

func_schema_setup() {
  if [ "${schema_type}" == "mongodb" ]; then
     echo -e "\e[36m>>>>>>>>>> install mongodb client <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    yum install mongodb-org-shell -y &>>${log}
    func_exit_status
     echo -e "\e[36m>>>>>>>>>> Load ${component} schema <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
    mongo --host mongodb.pradevops.online </app/schema/${component}.js &>>${log}
    func_exit_status
  fi

  if [ "${schema_type}" == "mysql" ]; then
      echo -e "\e[36m>>>>>>>>>> install mysql client <<<<<<<<<<<<<<<<<<\e[0m"
      yum install mysql -y &>>${log}
      func_exit_status
      echo -e "\e[36m>>>>>>>>>> Load ${component} schema <<<<<<<<<<<<<<<<<<\e[0m"
      mysql -h mysql.pradevops.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}
      func_exit_status
  fi
}

nodejs() {
  log=/tmp/roboshop.log
  echo -e "\e[36m>>>>>>>>>> copying mongodb repo file <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}
  func_exit_status
  echo -e "\e[36m>>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}
  func_exit_status
  echo -e "\e[36m>>>>>>>>>> install nodejs <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  yum install nodejs -y &>>${log}
  func_exit_status
func_apppreq
   echo -e "\e[36m>>>>>>>>>> install nodejs dependencies <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
  npm install &>>${log}
  func_exit_status
func_schema_setup
func_systemd
}
func_java() {
echo -e "\e[36m>>>>>>>>>> Install Maven <<<<<<<<<<<<<<<<<<\e[0m"
yum install maven -y &>>${log}
func_exit_status
func_apppreq
  echo -e "\e[36m>>>>>>>>>> build ${component} service <<<<<<<<<<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}
  func_exit_status
func_schema_setup
 func_systemd
}

func_python() {
  echo -e "\e[36m>>>>>>>>>> Install python 3 <<<<<<<<<<<<<<<<<<\e[0m"
  yum install python36 gcc python3-devel -y &>>${log}
  func_exit_status
  func_apppreq
  echo -e "\e[36m>>>>>>>>>> build ${component} service <<<<<<<<<<<<<<<<<<\e[0m"
  pip3.6 install -r requirements.txt &>>${log}
  func_exit_status
 func_systemd
}