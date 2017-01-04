#!/bin/sh

cd /opt/ask

sed -i s/user_id=/id=/g /usr/local/lib/python2.7/site-packages/askbot-0.10.1-py2.7.egg/askbot/deps/django_authopenid/views.py
sed -i s/user_id\)/id\)/g /usr/local/lib/python2.7/site-packages/askbot-0.10.1-py2.7.egg/askbot/deps/django_authopenid/views.py

python manage.py syncdb
python manage.py migrate
python manage.py runserver 0.0.0.0:8080
