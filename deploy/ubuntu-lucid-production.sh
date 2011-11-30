# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
cp deploy/silcc /etc/init.d/silcc
chmod +x /etc/init.d/silcc
update-rc.d silcc defaults
cd ..
wget http://nltk.googlecode.com/files/nltk-2.0b8.zip
unzip nltk-2.0b8.zip
rm -f nltk-2.0b8.zip
cd nltk-2.0b8
python setup.py install
cd ..
rm -rf nltk-2.0b8
cd SiLCC
echo "create database silcc default charset utf8;grant all on silcc.* to silcc@localhost identified by 'password';" | mysql -u root -p
python db_repository/manage.py version_control mysql://silcc:password@localhost:3306/silcc
migrate manage manage.py --repository=db_repository --url=mysql://silcc:password@localhost:3306/silcc
python manage.py upgrade
echo "insert into apikey set keystr = 'AAAABBBB', valid_domains = '*';" | mysql -u root -p silcc
adduser --disabled-password --gecos "" silcc
cd ..
chown -R silcc SiLCC
mv SiLCC /home/silcc/
su silcc
python -c "import nltk;nltk.download('maxent_treebank_pos_tagger')"
exit
/etc/init.d/silcc start
