# askbot installation

### delete existing askbot container:

	sudo docker ps -a | grep askbot | awk '{print$1}' | xargs --no-run-if-empty sudo docker rm -f

### start mysql

Bring up mysql docker:

	sudo mkdir -p /data/mysql
	sudo docker run --name mysql -p 3306:3306 -v /data/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=xxxxx! -d mysql

Create askbot database:

	sudo docker run --link mysql:mysql -it hub.c.163.com/library/mysql:5.5.54 mysql -h mysql -uroot -p[password] -e "CREATE DATABASE askbot;"
	sudo docker run --link mysql:mysql -it hub.c.163.com/library/mysql:5.5.54 mysql -h mysql -uroot -p[password] -e "ALTER DATABASE askbot CHARACTER SET utf8 COLLATE utf8_general_ci;"
	sudo docker run --link mysql:mysql -it hub.c.163.com/library/mysql:5.5.54 mysql -h mysql -uroot -p[password] -e "CREATE USER [user]@'%' IDENTIFIED BY '[password]';"
	sudo docker run --link mysql:mysql -it hub.c.163.com/library/mysql:5.5.54 mysql -h mysql -uroot -p[password] -e "GRANT ALL ON askbot.* TO [user]@'%';"
	
### start askbot

	sudo docker run --name mongo-askbot --link mysql:mysql -p 8081:8080 -d mongodb-china/askbot

### build & run docker image locally

	sudo docker build --rm=true -t mongodb-china/askbot .

	# make sure mysql is running,see above steps
	sudo docker run --name mongo-askbot -it --link mysql:mysql -p 8081:8080 mongodb-china/askbot 
	sudo docker run --name mongo-askbot -d --link mysql:mysql -p 8081:8080 mongodb-china/askbot
	
