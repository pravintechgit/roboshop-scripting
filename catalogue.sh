echo ">>>>>>>>>> copying service file <<<<<<<<<<<<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service
echo ">>>>>>>>>> copying repo file <<<<<<<<<<<<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo
echo ">>>>>>>>>> Install nodejs repo <<<<<<<<<<<<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo ">>>>>>>>>> install nodejs <<<<<<<<<<<<<<<<<<<"
yum install nodejs -y
echo ">>>>>>>>>> creating application user <<<<<<<<<<<<<<<<<<<"
useradd roboshop
 echo ">>>>>>>>>> create application dir <<<<<<<<<<<<<<<<<<<"
mkdir /app
echo ">>>>>>>>>> download application code <<<<<<<<<<<<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
echo ">>>>>>>>>> extract application code <<<<<<<<<<<<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app
 echo ">>>>>>>>>> install nodejs dependencies <<<<<<<<<<<<<<<<<<<"
npm install
 echo ">>>>>>>>>> install mongodb client <<<<<<<<<<<<<<<<<<<"
yum install mongodb-org-shell -y
 echo ">>>>>>>>>> Load catalogue schema <<<<<<<<<<<<<<<<<<<"
mongo --host mongodb.pradevops.online </app/schema/catalogue.js
 echo ">>>>>>>>>> start catalogue service <<<<<<<<<<<<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
