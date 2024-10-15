CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

ALTER TABLE profiles ADD CONSTRAINT unique_uuid UNIQUE (uuid);

CREATE TABLE savings (
    id bigint primary key generated always as identity,
    profile_id UUID REFERENCES profiles(uuid) ON DELETE CASCADE,
    amount NUMERIC DEFAULT 0
);
