# askbot installation

###

delete all

	sudo docker ps -a | awk '{print$1}' | xargs --no-run-if-empty sudo docker rm -f



### start mysql

Bring up mysql docker:

	sudo mkdir -p /data/mysql
	sudo docker run --name mysql -p 3306:3306 -v /data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=M0ngodb! -d mysql

Create askbot database:

	sudo docker run --link mysql:mysql -it mysql mysql -h mysql -uroot -pM0ngodb! -e "create database askbot"

	sudo docker run --link mysql:mysql -it mysql mysql -h mysql -uroot -pM0ngodb! -e "ALTER DATABASE  askbot CHARACTER SET utf8 COLLATE utf8_general_ci"

### start askbot

	sudo docker run --name askbot --link mysql:mysql -p 8080:8080 -d mongodb-china/askbot



### build & run docker image locally

	sudo docker build --rm=true -t mongodb-china/askbot .

	# make sure mysql is running,see above steps

	sudo docker run -it --link mysql:mysql -p 8080:8080 mongodb-china/askbot 

