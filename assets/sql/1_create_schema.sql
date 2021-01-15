CREATE TABLE plan_it
(
    _id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    from_time BIGINT,
    date BIGINT,
    to_time BIGINT,
    reminder INT,
    priority INT,
    status INT
);