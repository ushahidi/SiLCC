#!/bin/bash
aptitude update
aptitude safe-upgrade -y
aptitude install -y git-core unzip python-virtualenv python-setuptools python-dev python-pastescript python-numpy mysql-server-5.1 libmysqlclient-dev
easy_install mysql-python
easy_install pyyaml
easy_install SQLAlchemy==0.6.0
easy_install sqlalchemy-migrate==0.5.4
git clone https://github.com/ushahidi/SiLCC.git
cd SiLCC
python setup.py develop
cd ..
wget http://nltk.googlecode.com/files/nltk-2.0b8.zip
unzip nltk-2.0b8.zip
rm -f nltk-2.0b8.zip
cd nltk-2.0b8
python setup.py install
python -c "import nltk;nltk.download('maxent_treebank_pos_tagger')"
cd ..
rm -rf nltk-2.0b8
cd SiLCC
echo "create database silcc default charset utf8;grant all on silcc.* to silcc@localhost identified by 'password';" | mysql -u root -p
python db_repository/manage.py version_control mysql://silcc:password@localhost:3306/silcc
migrate manage manage.py --repository=db_repository --url=mysql://silcc:password@localhost:3306/silcc
python manage.py upgrade
echo "insert into apikey set keystr = 'AAAABBBB', valid_domains = '*';" | mysql -u root -p silcc
paster serve --daemon development.ini
