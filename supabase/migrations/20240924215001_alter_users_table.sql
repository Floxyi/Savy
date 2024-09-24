ALTER TABLE users RENAME TO profiles;

ALTER TABLE profiles RENAME COLUMN name TO username;

ALTER TABLE profiles ADD COLUMN uuid uuid;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
