#!/usr/bin/env bash

# create hive user and hive_metastore database
mysql -uroot -proot -e "create user 'hive'@'localhost' identified by 'hive';
create database hive_metastore;
grant all on hive_metastore.* to 'hive'@'localhost';
flush privileges;"
