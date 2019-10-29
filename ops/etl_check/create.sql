/*10.10.64.79*/
create database check_db;
flush privileges;
GRANT ALL PRIVILEGES ON check_db.* TO 'check_user'@'%' IDENTIFIED BY 'Uiop123!' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON check_db.* TO 'check_user'@'localhost' IDENTIFIED BY 'Uiop123!' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON check_db.* TO 'check_user'@'10-10-64-79' IDENTIFIED BY 'Uiop123!' WITH GRANT OPTION;
flush privileges;