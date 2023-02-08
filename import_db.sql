PRAGMA foreign_keys = ON; 

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    queston_id INTEGER NOT NULL,
    parent_reply_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL, 
	user_id INTEGER NOT NULL, 

	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
)

INSERT INTO  -- Users
	users(fname, lname)
VALUES 
	('Justin', 'Diner'),
	('Milner', 'Chen');

INSERT INTO -- Questions
	questions(title, body, user_id)
VALUES
	('How do you do SQL?', 'Help Please! I don''t know how to do homework!', (SELECT id FROM users WHERE fname = 'Milner')),
	('Do you need to use LIKE or = for string comparison?', "Help Me Too! I'm lost!!", (SELECT id FROM users WHERE fname = 'Justin'));

INSERT INTO 
	question_follows(question_id, user_id)
VALUES
	((SELECT id FROM questions WHERE title = 'How do you do SQL?'), 
	(SELECT id from users WHERE fname = 'Justin')),
	((SELECT id FROM questions WHERE title = 'Do you need to use LIKE or = for string comparison?'), 
	(SELECT id from users WHERE fname = 'Milner'));


