create table
    users (
        id bigint primary key generated always as identity,
        name text,
        created_at timestamptz default now ()
    );