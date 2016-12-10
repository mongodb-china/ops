FROM python:2.7
RUN apt-get update
RUN pip install  askbot
RUN pip install  mysql-python

RUN mkdir /opt/ask

WORKDIR /opt/ask
RUN askbot-setup -n . -e 3 -d askbot -u root -p xxx -domain ask.mongoing.com

ADD settings.py /opt/ask/settings.py
ADD setup.sh /opt/ask/setup.sh

RUN python manage.py collectstatic --help
ENTRYPOINT  ["/bin/sh", "/opt/ask/setup.sh"]

