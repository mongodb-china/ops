FROM hub.c.163.com/library/python:2.7
ADD sources.list /etc/apt/sources.list
RUN apt-get update
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple askbot
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple mysql-python
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple python_wordpress_xmlrpc

RUN mkdir /opt/ask

WORKDIR /opt/ask
RUN askbot-setup -n . -e 3 -d askbot -u root -p xxx -domain ask.mongoing.com

ADD settings.py /opt/ask/settings.py
ADD setup.sh /opt/ask/setup.sh

RUN python manage.py collectstatic --noinput
ENTRYPOINT  ["/bin/sh", "/opt/ask/setup.sh"]

