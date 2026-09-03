CREATE DATABASE IF NOT EXISTS wp_bedrock;
CREATE USER 'db_user'@'localhost' IDENTIFIED BY 'root_password';
GRANT ALL PRIVILEGES ON wp_bedrock.* TO 'db_user'@'localhost';
FLUSH PRIVILEGES;

