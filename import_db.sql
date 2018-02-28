PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT
);

INSERT INTO
  users(id, fname, lname)
VALUES
  (1, 'Annie', 'Gu'),
  (2, 'Dude', 'Smith');

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT,
  author_id INTEGER,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
  questions(id, title, body, author_id)
VALUES
  (1, 'some_title', 'some_question', 2),
  (2, 'title_2', 'question_2', 1);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1, 2),
  (2, 1);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  parent_id INTEGER,
  user_id INTEGER,
  question_id INTEGER,
  body TEXT,

  FOREIGN KEY (parent_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
  replies(parent_id, user_id, question_id, body)
VALUES
  (1, 1, 1, 'Hello'),
  (1, 2, 2, "Hi");

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  question TEXT,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO
  question_likes(question_id, question, user_id)
VALUES
  (2, 'meaning of life?', 1),
  (1, 'what?', 2);
