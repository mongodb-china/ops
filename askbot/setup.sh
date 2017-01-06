#!/bin/sh

cd /opt/ask

sed -i s/user_id=/id=/g /usr/local/lib/python2.7/site-packages/askbot/deps/django_authopenid/views.py
sed -i s/user_id\)/id\)/g /usr/local/lib/python2.7/site-packages/askbot/deps/django_authopenid/views.py

python manage.py syncdb
python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8080
