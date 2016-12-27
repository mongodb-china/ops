
## 服务器(宿主机)安装docker
具体安装步骤略(此处，TJ可以补充)

## 二、常用docker指令

### 2.1 基本指令

    docker images 查看本地的镜像文件
    docker ps -a 查询容器及状态

用-v挂载主机数据卷到容器内
  
    docker run -v /path/to/hostdir:/mnt 

### 2.2 拷贝相关

从容器内拷贝文件到主机上

    docker cp <containerId>:/file/path/within/container /host/path/target
    
比如: 
    
    sudo docker cp d901e46825b2:/etc/mysql/conf.d  /home/xinghua/

拷贝文件到container

    docker inspect -f '{{.Id}}' d901e46825b2 查看容器的执行ID号串码
    sudo  cp  mysql.cnf /var/lib/docker/aufs/mnt/d901e46825b216f833fdc3cc2f48590181bea1ababe960669b71ac7580207dff/etc/mysql/conf.d/mysql.cnf

### 2.3 查看log和ip

-d 表示后台运行，不加此参数是前台运行，可以看到打印的log
  
  docker logs wordpressdb 查看镜像日志：

查看容器IP地址

    docker inspect --format='{{.NetworkSettings.IPAddress}}' mysql，其中mysql是container的名字

查看容器中的文件内容

    docker exec -ti mysql cat /etc/hosts
    
## 三、安装应用容器container

### 2.1 mysql镜像
2.1.1 下载mysql镜像

从蜂巢163仓库中 Pull mysql 镜像，国内网速比较快。蜂巢网址：https://c.163.com/hub#/m/home/ 寻找镜像文件

    sudo docker pull hub.c.163.com/library/mysql:5.5.54 为兼容HK服务器中的MySQL版本现在5.5.54

2.1.2启动mysql容器

    sudo docker run -d -e MYSQL_ROOT_PASSWORD=xxxxxx --name mysql -v /data/mysql/wpdata:/var/lib/mysql -p 3306:3306 hub.c.163.com/library/mysql:5.5.54
    
其中 -v /data/mysql/wpdata:/var/lib/mysql 是将mysql容器中的数据库文件持久化到宿主机器 这样保证容器重启后数据不丢失。

安装好mysql客户端后，执行下面指令可以登录mysql容器，查看数据库状态。

    mysql -h 127.0.0.1 -u root -p 输入密码登录mysql数据库。
    mysql>show databases; 查看mysql中的数据库 
    mysql>use database_name; 切换数据库
    mysql>show tables;查看数据库中的表名字
    mysql>create database bitnami_wordpress; 创建数据库 为下面恢复数据做基础
    
2.1.3恢复数据库数据

	gunzip < /home/xinghua/backup_2016-12-22-1137_MongoDB_a5c35040332a-db.gz | mysql -uroot -pxxxxxx -h127.0.0.1 bitnami_wordpress
/home/xinghua/backup_2016-12-22-1137_MongoDB_a5c35040332a-db.gz 是HK服务器中，自动备份出的mysql数据库备份文件

### 2.2 wordpress镜像

2.2.1 创建wordpress 宿主机本地持久化文件夹，并赋予权限

    mkdir /data/wpdata 并将HK服务器中的wordpress整个网站文件拷贝至此
    sudo chown -R www-data:www-data /data/wpdata/ 路径宿主机持久化 必须保证权限 

2.2.2 下载wordpress镜像

    sudo docker pull hub.c.163.com/library/wordpress:php5.6-apache
    
2.2.3 启动wordpress容器

    sudo docker run --name mywp --link mysql:mysql -p 8080:80 -d -v /data/wpdata:/var/www/html -e WORDPRESS_DB_NAME=bitnami_wordpress hub.c.163.com/library/wordpress:php5.6-apache

查看container mywp的文件信息

    sudo docker exec -ti mywp cat /etc/hosts 可以坚持是否把mysql容器的IP地址关联到wordpress的容器中

wordpress php-fpm模式

    #sudo docker run --name mywp --link mysql:mysql -p 9000:9000  -d -v /data/wpdata:/var/www/html hub.c.163.com/library/wordpress:4-fpm 可以启动Nginx中php-fpm模式 

这种模式需要在Nginx配置文件中修改反向代理及数据文件所在路径root 

## 四、Nginx安装和配置
### 4.1 安装Nginx
	
	sudo apt-get install nginx 
	
默认安装后，Nginx命令在/usr/sbin/nginx
配置文件在/etc/nginx/

### 4.2 Nginx指令
宿机Nginx配置
	sudo /usr/sbin/nginx 启动
	sudo /usr/sbin/nginx -s stop 关闭

### 4.3 Nginx配置文件
 
修改site-enable中的网站配置文件
 
增加对网站的转发配置文件。
问答网站的配置，可以拷贝此文件后修改名字后。对应修改里面的server_name 和proxy_pass ip和端口
