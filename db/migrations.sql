CREATE DATABASE kiwitypedev;

\c kiwitypedev

CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	password_digest VARCHAR(255) NOT NULL,
	session_token VARCHAR(255) NOT NULL
);

CREATE TABLE excerpts(
	id SERIAL PRIMARY KEY,
	author VARCHAR(255),
	title VARCHAR(255),
	description VARCHAR(255),
	body TEXT
);

CREATE TABLE attempts(
	id SERIAL PRIMARY KEY,
	user_id INT REFERENCES users(id),
	excerpt_id INT REFERENCES excerpts(id),
	wpm NUMERIC,
	creation_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);