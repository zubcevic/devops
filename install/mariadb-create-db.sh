#!/bin/bash

d_db="accountdb"
d_admin="accountadmin"

# Create a database
mysql -uroot -sp$d_db_password -e "create database $d_db default character set utf8 default collate utf8_bin;"

# Create a database admin user
mysql -uroot -sp$d_db_password -e "GRANT ALL PRIVILEGES ON ${d_db}.* to $d_admin@'localhost' IDENTIFIED BY '$d_admin_pwd';"

