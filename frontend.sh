source common.sh

echo -e "\e[36m>>>>>>>>>> Install Nginx <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install nginx -y &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> Copy roboshop configuration <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> Remove old content <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
rm -rf /usr/share/nginx/html/* &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> Download application content <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> extract application content <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
cd /usr/share/nginx/html &>>${log}
unzip /tmp/frontend.zip &>>${log}
func_exit_status

echo -e "\e[36m>>>>>>>>>> Restart nginx <<<<<<<<<<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl enable nginx &>>${log}
systemctl restart nginx &>>${log}
func_exit_status

