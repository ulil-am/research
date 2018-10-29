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
DROP TABLE IF EXISTS "prepostLog";
CREATE TABLE "prepostLog" (
    "requestID"         varchar(255)	     NOT NULL,
    "requestDtm"        timestamptz        NOT NULL,
    "payload"           json               NOT NULL,
    PRIMARY KEY ("requestID")
);


-- Creating Table glEntriesSentLog
DROP TABLE IF EXISTS "glEntriesSentLog";
CREATE TABLE "glEntriesSentLog" (
    "_Id"         varchar(42)  NOT NULL ,
    PRIMARY KEY ("_Id")
);

-----------rolePermission



INSERT INTO public."rolePermission" ("isPermit", operation, "userRole") VALUES (true,'/history/accounts','developer');
INSERT INTO public."rolePermission" ("isPermit", operation, "userRole") VALUES (true,'/transactions/incoming/prepost','developer');
INSERT INTO public."rolePermission" ("isPermit", operation, "userRole") VALUES (true,'/transactions/internal/prepost','developer');
INSERT INTO public."rolePermission" ("isPermit", operation, "userRole") VALUES (true,'/transactions/outgoing/prepost','developer');
INSERT INTO public."rolePermission" ("isPermit", operation, "userRole") VALUES (true,'/transactions/post','developer');



----------systemCalendar

INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
('sendingGL', 'T2S', false, 'sendingGL','sendingGL', '2018-04-27 00:00:00', '2018-04-27 00:00:00'),
('readAutoSweep', 'T2S', true, 'readAutoSweep','readAutoSweep', '0001-01-01 00:00:00', '0001-01-01 00:00:00'),
('execAutoSweep', 'T2S', true, 'execAutoSweep','execAutoSweep', '0001-01-01 00:00:00', '0001-01-01 00:00:00'),
('extrAutoSweep', 'T2S', true, 'extrAutoSweep','extrAutoSweep', '0001-01-01 00:00:00', '0001-01-01 00:00:00');

-- Parameter for readAutoSweep event
INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
('readAutoSweep', '0', 'OFFSET', '0'),
('readAutoSweep', '1', 'FILENAME', 'SETTLEMENT_SWEEP_{DATE}.txt'),
('readAutoSweep', '2', 'PATH', '/application/file/internal/input');

-- Parameter for execAutoSweep event
INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
('execAutoSweep', '0', 'OFFSET', '0');

-- Parameter for extrAutoSweep event
INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
('extrAutoSweep', '0', 'OFFSET', '0'),
('extrAutoSweep', '1', 'FILENAME', 'SETTLEMENT_SWEEP_{DATE}_RS.txt'),
('extrAutoSweep', '2', 'PATH', '/application/file/internal/output');

END;