
CREATE DATABASE stores_bd;

USE stores_db;

CREATE TABLE stores_db.users (
	id int auto_increment primary key,
	name varchar(100) not null,
	email varchar(100) not null,
	password varchar(100) not null
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_bin;