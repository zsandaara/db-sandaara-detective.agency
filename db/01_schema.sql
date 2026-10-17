-- Лаба 1. Схема базы: таблицы, ключи, ограничения.
-- Скрипты из db/ выполняются по порядку имён при первом docker compose up.

CREATE TABLE clients (
    id      integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name    text NOT NULL,
    email   text NOT NULL UNIQUE,
    phone   text,
    address text
);

CREATE TABLE detectives (
    id        integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name      text NOT NULL,
    email     text NOT NULL UNIQUE,
    phone     text,
    rank      text NOT NULL CHECK (rank IN ('junior','senior','lead','consultant')),
    hire_date date NOT NULL
);

CREATE TABLE cases (
    id         integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id  integer NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    title      text NOT NULL,
    description text,
    status     text NOT NULL DEFAULT 'open' CHECK (status IN ('open','closed','suspended')),
    opened_at  timestamptz NOT NULL DEFAULT now(),
    closed_at  timestamptz,
    fee        numeric(10,2) NOT NULL CHECK (fee >= 0),
    CHECK (closed_at IS NULL OR closed_at > opened_at)
);

CREATE TABLE case_detectives (
    case_id      integer NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    detective_id integer NOT NULL REFERENCES detectives(id) ON DELETE RESTRICT,
    role         text NOT NULL DEFAULT 'member' CHECK (role IN ('lead','member','consultant')),
    assigned_at  timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (case_id, detective_id)
);

CREATE TABLE evidence (
    id          integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id     integer NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    description text NOT NULL,
    found_at    timestamptz NOT NULL,
    type        text NOT NULL CHECK (type IN ('physical','digital','testimony','document'))
);

CREATE TABLE suspects (
    id      integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id integer NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    name    text NOT NULL,
    alias   text,
    status  text NOT NULL DEFAULT 'person_of_interest'
            CHECK (status IN ('person_of_interest','suspect','cleared','arrested'))
);

CREATE TABLE reports (
    id           integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    case_id      integer NOT NULL REFERENCES cases(id) ON DELETE CASCADE,
    detective_id integer NOT NULL REFERENCES detectives(id) ON DELETE RESTRICT,
    created_at   timestamptz NOT NULL DEFAULT now(),
    content      text NOT NULL,
    hours_spent  numeric(5,2) NOT NULL CHECK (hours_spent > 0)
);