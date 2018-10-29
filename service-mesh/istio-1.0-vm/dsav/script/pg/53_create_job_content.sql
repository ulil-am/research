--
-- Name:
--    51_prepost-log_gl-entry.sql
-- Purpose:
--    This file stores all core & model for SMITH.
-- \c zbch_trn_db specifies to which database to use in pgsql


\c zbch_trn_db
SET TIME ZONE 'UTC';
BEGIN;

-- Creating Table prepostLog
DROP TABLE IF EXISTS "job_content";
CREATE TABLE "job_content" (
    "date"         date	     NOT NULL,
    "name"        varchar(255)        NOT NULL,
    "key"           varchar(255)               NOT NULL,
    "msg_rq"           json               DEFAULT NULL,
    "msg_rs"           json               DEFAULT NULL,
    "status"           boolean               NOT NULL DEFAULT false,
    PRIMARY KEY ("date","name","key")
);

END;