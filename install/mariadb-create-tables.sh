#!/bin/bash

d_db="accountdb"
d_admin="accountadmin"

mysql -u$d_admin -p$d_admin_pwd -D$d_db < accountdb-create.sql
 

