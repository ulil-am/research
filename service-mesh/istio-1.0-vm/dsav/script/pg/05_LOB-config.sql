--
-- Name: 
--    05_LOB-config.sql
-- Purpose: 
--    This file stores all configuration specific to the Live Oak Bank (LOB)
--    implementation.  The LOB userRoles and associated core & model API 
--    entitlement configuration is stored in the 06_LOB-config-rolePermissions
--    file and should not be added here.
--


--
--
-- Data for Name: timeZones; Type: TABLE DATA; Schema: public; Owner: postgres
-- \c zbch_trn_db specifies to which database to use in pgsql

\c zbch_trn_db

BEGIN;

INSERT INTO public."tmZones" ("tzAbbrev", "tzName") VALUES 
('EST', 'Eastern Standard Time');

--
-- Data for Name: calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."calendar" ("holidays", "name", "tmZone") VALUES 
('[{"date": "2018-07-04", "isAllDay": true}, {"date": "2018-12-25", "isAllDay": true}, {"date": "2018-01-01", "isAllDay": true}, {"date": "2018-01-15", "isAllDay": true}, {"date": "2018-02-19", "isAllDay": true}, {"date": "2018-05-28", "isAllDay": true}, {"date": "2018-09-03", "isAllDay": true}, {"date": "2018-10-08", "isAllDay": true}, {"date": "2018-11-22", "isAllDay": true}]', 'Standard', 'EST');

--
-- Data for Name: calendarBusinessDays; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."calendarBusinessDays" ("_Ix","closeTm","dayOfWk","isAllDay","name","openTm") VALUES
(0,'17:00:00',1,false,'Standard','09:00:00'),
(1,'17:00:00',2,false,'Standard','09:00:00'),
(2,'17:00:00',3,false,'Standard','09:00:00'),
(3,'17:00:00',4,false,'Standard','09:00:00'),
(4,'17:00:00',5,false,'Standard','09:00:00');

-- Data for Name: acctGroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."acctGroup" ("acctGroup", "desc", "isAccumGL", "isChkPosn", "isRtPosnUpd", "posnClass", "posnDelim", "posnFixed") VALUES
(1, 'Banking', true, true, true, 'posn_bk', NULL, '[{"size": 11, "field": "AcctNbr", "offset": null}]'),
(2, 'General Ledger', false, false, false, 'posn_gl', NULL, '[{"size": 5, "field": "AcctNbr", "offset": null}, {"size": 3, "field": "DeptId", "offset": null}, {"size": 2, "field": "Vertical", "offset": null}]');

--
-- Data for Name: acct; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."acct" ("_Class", "acctGroup", "acctNbr", "acctTitle", "closeDtm", "desc", "openDtm") VALUES 
(NULL, 2, '14020', 'Due from PCBB', NULL, NULL, NULL),
(NULL, 2, '19120', 'Disputed Items', NULL, NULL, NULL),
(NULL, 2, '20110', 'Personal Savings <100K', NULL, NULL, NULL),
(NULL, 2, '20111', 'Personal Savings >100K', NULL, NULL, NULL),
(NULL, 2, '20115', 'Business Savings <100K', NULL, NULL, NULL),
(NULL, 2, '20117', 'Business Savings <100K', NULL, NULL, NULL),
(NULL, 2, '20120', 'DDA/Savings Unposted', NULL, NULL, NULL),
(NULL, 2, '20130', 'DDA/SAV Suspense', NULL, NULL, NULL),
(NULL, 2, '20136', 'SAV/DDA ACH Clearing Account', NULL, NULL, NULL),
(NULL, 2, '20137', 'SAV/DDA ACH Suspense/In Process Account', NULL, NULL, NULL),
(NULL, 2, '24010', 'Regular CDS (<100K)s', NULL, NULL, NULL),
(NULL, 2, '24012', 'CDS 100K-250K', NULL, NULL, NULL),
(NULL, 2, '24020', 'CDS >250K', NULL, NULL, NULL),
(NULL, 2, '24050', 'CD Unposted', NULL, NULL, NULL),
(NULL, 2, '24051', 'CD Suspense', NULL, NULL, NULL),
(NULL, 2, '24054', 'CD ACH Clearing Account', NULL, NULL, NULL),
(NULL, 2, '24055', 'CD ACH Suspense/In Process Account', NULL, NULL, NULL),
(NULL, 2, '24060', 'CD Check Clearing - CD Interest Checks', NULL, NULL, NULL),
(NULL, 2, '26080', 'Acc Int Exp Personal Savings <100K', NULL, NULL, NULL),
(NULL, 2, '26081', 'Acc Int Exp Personal Savings >100K', NULL, NULL, NULL),
(NULL, 2, '26085', 'Acc Int Exp Business Savings <100K', NULL, NULL, NULL),
(NULL, 2, '26086', 'Acc Int Exp Business Savings >100K', NULL, NULL, NULL),
(NULL, 2, '26090', 'Acc Int Exp CDs', NULL, NULL, NULL),
(NULL, 2, '26092', 'Acc Int Exp CDs 100-250k', NULL, NULL, NULL),
(NULL, 2, '26100', 'Acc Int Exp CDs >250k', NULL, NULL, NULL),
(NULL, 2, '28024', 'Federal Withholding', NULL, NULL, NULL),
(NULL, 2, '28026', 'State Withholding', NULL, NULL, NULL),
(NULL, 2, '28085', 'Acc Int Exp Business Savings <100K', NULL, NULL, NULL),
(NULL, 2, '28086', 'Acc Int Exp Business Savings >100K', NULL, NULL, NULL),
(NULL, 2, '46110', 'Service Charge - Personal Savings', NULL, NULL, NULL),
(NULL, 2, '46111', 'Waive - Service Charge Personal Savings', NULL, NULL, NULL),
(NULL, 2, '46117', 'Service Charge - Business Savings', NULL, NULL, NULL),
(NULL, 2, '46118', 'Waive- Service Charge Business Savings', NULL, NULL, NULL),
(NULL, 2, '46145', 'CD Penalty Income', NULL, NULL, NULL),
(NULL, 2, '48010', 'Wire Fee Income', NULL, NULL, NULL),
(NULL, 2, '52080', 'Int Exp Personal Savings <100K', NULL, NULL, NULL),
(NULL, 2, '52081', 'Int Exp Personal Savings >100K', NULL, NULL, NULL),
(NULL, 2, '52085', 'Int Exp Business Savings <100K', NULL, NULL, NULL),
(NULL, 2, '52086', 'Int Exp Business Savings >100K', NULL, NULL, NULL),
(NULL, 2, '52090', 'Int Exp Regular CDs (<100K)', NULL, NULL, NULL),
(NULL, 2, '52092', 'Int Exp CDs 100K - 250K', NULL, NULL, NULL),
(NULL, 2, '52100', 'Int Exp CDs >250K', NULL, NULL, NULL),
(NULL, 2, '57080', 'Bank Service Charge', NULL, NULL, NULL),
(NULL, 2, '57170', 'Cash/Over Short', NULL, NULL, NULL),
(NULL, 2, '57670', 'Misc Exp', NULL, NULL, NULL),
(NULL, 2, '57680', 'OD Chargeoffs & Recovery (Fraud)', NULL, NULL, NULL);

--
-- Data for Name: posn; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802141725027100000005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20110', 0.00, NULL, '', NULL, 'Personal Savings <100K', '2018-02-12 23:00:00+00', '2011035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142248024536990005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20111', 0.00, NULL, '', NULL, 'Personal Savings >100K', '2018-02-12 23:00:00+00', '2011135001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142341324617670005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26080', 0.00, NULL, '', NULL, 'Acc Int Exp Personal Savings <100K', '2018-02-12 23:00:00+00', '2608035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142343400029780005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26081', 0.00, NULL, '', NULL, 'Acc Int Exp Personal Savings >100K', '2018-02-12 23:00:00+00', '2608135001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142341324617770005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26085', 0.00, NULL, '', NULL, 'Acc Int Exp Business Savings <100K', '2018-02-12 23:00:00+00', '2608535001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142343400029880005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26086', 0.00, NULL, '', NULL, 'Acc Int Exp Business Savings >100K', '2018-02-12 23:00:00+00', '2608635001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142345341354430005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '57680', 0.00, NULL, '', NULL, 'OD Chargeoffs & Recovery (Fraud)', '2018-02-12 23:00:00+00', '5768035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142347497257010005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '28024', 0.00, NULL, '', NULL, 'Federal Withholding', '2018-02-12 23:00:00+00', '2802435001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142349034768830005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '28026', 0.00, NULL, '', NULL, 'State Withholding', '2018-02-12 23:00:00+00', '2802635001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142351545856750005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '19120', 0.00, NULL, '', NULL, 'Disputed Items', '2018-02-12 23:00:00+00', '1912035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142354010502410005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20115', 0.00, NULL, '', NULL, 'Business Savings <100K', '2018-02-12 23:00:00+00', '2011535001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142354525985040005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20117', 0.00, NULL, '', NULL, 'Business Savings >100K', '2018-02-12 23:00:00+00', '2011735001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142356300725580005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '28086', 0.00, NULL, '', NULL, 'Acct Int Exp Business Savings >100K', '2018-02-12 23:00:00+00', '2808635001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142357387076080005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '28085', 0.00, NULL, '', NULL, 'Acc Int Exp Business Savings <100K', '2018-02-12 23:00:00+00', '2808535001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802142359037985550005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '46117', 0.00, NULL, '', NULL, 'Service Charge - Business Savings', '2018-02-12 23:00:00+00', '4611735001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150002385623080005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '46118', 0.00, NULL, '', NULL, 'Waive- Service Charge Business Savings', '2018-02-12 23:00:00+00', '4611835001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150004081358830005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52086', 0.00, NULL, '', NULL, 'Int Exp Business Savings >100K', '2018-02-12 23:00:00+00', '5208635001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150005173691130005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52085', 0.00, NULL, '', NULL, 'Int Exp Business Savings <100K', '2018-02-12 23:00:00+00', '5208535001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150006144304620005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20120', 0.00, NULL, '', NULL, 'DDA/Savings Unposted', '2018-02-12 23:00:00+00', '2012035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150007197321630005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52080', 0.00, NULL, '', NULL, 'Int Exp Personal Savings <100K', '2018-02-12 23:00:00+00', '5208035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150007597586790005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52081', 0.00, NULL, '', NULL, 'Int Exp Personal Savings >100K', '2018-02-12 23:00:00+00', '5208135001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150009074119400005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '46110', 0.00, NULL, '', NULL, 'Service Charge - Personal Savings', '2018-02-12 23:00:00+00', '4611035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150009506705260005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '46111', 0.00, NULL, '', NULL, 'Waive - Service Charge Personal Savings', '2018-02-12 23:00:00+00', '4611135001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150011004293070005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24010', 0.00, NULL, '', NULL, 'Regular CDS (<100K)', '2018-02-12 23:00:00+00', '2401035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150011504269550005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24012', 0.00, NULL, '', NULL, 'CDS 100K-250K', '2018-02-12 23:00:00+00', '2401235001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150012380966410005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24020', 0.00, NULL, '', NULL, 'CDS >250K', '2018-02-12 23:00:00+00', '2402035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150013228608060005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24050', 0.00, NULL, '', NULL, 'CD Unposted', '2018-02-12 23:00:00+00', '2405035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150014150618100005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24051', 0.00, NULL, '', NULL, 'CD Suspense', '2018-02-12 23:00:00+00', '2405135001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150015247348460005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26090', 0.00, NULL, '', NULL, 'Acc Int Exp CDs', '2018-02-12 23:00:00+00', '2609035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150016190019210005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52090', 0.00, NULL, '', NULL, 'Int Exp Regular CDs (<100K)', '2018-02-12 23:00:00+00', '5209035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150016563700280005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52092', 0.00, NULL, '', NULL, 'Int Exp CDs 100K - 250K', '2018-02-12 23:00:00+00', '5209235001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150017493893990005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '52100', 0.00, NULL, '', NULL, 'Int Exp CDs >250K', '2018-02-12 23:00:00+00', '5210035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1802150018598653770005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '46145', 0.00, NULL, '', NULL, 'CD Penalty Income', '2018-02-12 23:00:00+00', '4614535001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081739506225230005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24054', 0.00, NULL, '', NULL, 'CD ACH Clearing Account', '2017-12-20 23:00:00+00', '2405435001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081742432156860005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20136', 0.00, NULL, '', NULL, 'SAV/DDA ACH Clearing Account', '2017-12-20 23:00:00+00', '2013635001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081745312137540005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24055', 0.00, NULL, '', NULL, 'CD ACH Suspense/In Process Account', '2017-12-20 23:00:00+00', '2405535001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081746235301930005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20137', 0.00, NULL, '', NULL, 'SAV/DDA ACH Suspense/In Process Account', '2017-12-20 23:00:00+00', '2013735001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081752008804250005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26092', 0.00, NULL, '', NULL, 'Acc Int Exp Cds 100-250k', '2017-12-20 23:00:00+00', '2609235001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081752544370120005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '26100', 0.00, NULL, '', NULL, 'Acc Int Exp Cds >250k', '2017-12-20 23:00:00+00', '2610035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081805018470110005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '20130', 0.00, NULL, '', NULL, 'DDA/SAV Suspense', '2017-12-20 23:00:00+00', '2013035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081806102696250005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '14020', 0.00, NULL, '', NULL, 'Due from PCBB', '2017-12-20 23:00:00+00', '1402035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081807180297720005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '48010', 0.00, NULL, '', NULL, 'Wire Fee Income', '2017-12-20 23:00:00+00', '4801035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081808322285140005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '57080', 0.00, NULL, '', NULL, 'Bank Service Charge', '2017-12-20 23:00:00+00', '5708035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081809487154590005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '57170', 0.00, NULL, '', NULL, 'Cash/Over Short', '2017-12-20 23:00:00+00', '5717035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081811424074730005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 2, '24060', 0.00, NULL, '', NULL, 'CD Check Clearing - CD Interest Checks', '2017-12-20 23:00:00+00', '2406035001', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1803081812374898420005', NULL, '2018-06-15 12:53:22+00', NULL, '2018-08-01 12:46:26.78186+00', 2, '57670', 0.00, NULL, '', NULL, 'Misc Exp', '2017-12-20 23:00:00+00', '5767035001', 1);

--
-- Data for Name: posn_gl; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802141725027100000005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142248024536990005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142341324617670005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142343400029780005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142345341354430005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142347497257010005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142349034768830005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142351545856750005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142354010502410005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142354525985040005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142356300725580005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142357387076080005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802142359037985550005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 4, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150002385623080005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 4, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150004081358830005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150005173691130005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150006144304620005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150007197321630005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150007597586790005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150009074119400005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 4, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150009506705260005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 4, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150011004293070005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150011504269550005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150012380966410005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150013228608060005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150014150618100005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150015247348460005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150016190019210005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150016563700280005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150017493893990005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1802150018598653770005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 4, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081739506225230005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081742432156860005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081745312137540005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081746235301930005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081752008804250005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081752544370120005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081805018470110005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081806102696250005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081807180297720005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 4, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081808322285140005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081809487154590005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 5, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081811424074730005', NULL, '2018-06-19 15:54:30.704215+00', NULL, NULL, 'USD', NULL, 350, 2, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1803081812374898420005', NULL, '2018-06-15 12:53:22+00', NULL, '2018-08-01 12:46:26.78186+00', 'USD', NULL, 350, 5, NULL, 1);

-- 
-- Data for Name: glSet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46117', '26085', 2, NULL, 'Business Savings >100k GL Set Code', NULL, 'BusSavgreat100k', '52085', '20115', NULL, NULL, '28024', '28026');
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46117', '26086', 2, NULL, 'Business Savings <100k GL Set Code', NULL, 'BusSavless100k', '52086', '20117', NULL, NULL, '28024', '28026');
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46145', '26092', 2, NULL, 'CD 100k -250k GL Set Code', NULL, 'CD100k-250k', '28026', '24012', NULL, NULL, '28024', '28026');
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46145', '26090', 2, NULL, 'CD <250k GL Set Code', NULL, 'CDgreater250k', '52100', '24020', NULL, NULL, '28024', '28026');
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46145', '26100', 2, NULL, 'CD <100k Set Code', NULL, 'CDless100k', '52090', '24010', NULL, NULL, '28024', '28026');
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES (NULL, NULL, NULL, NULL, NULL, NULL, 'Test', NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46110', '26081', 2, NULL, 'Personal Savings > 100k GL Set Code', NULL, 'PerSavgreat100k', '52081', '20111', NULL, NULL, '28024', '28026');
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES ('46110', '26080', 2, NULL, 'Personal Savings <100k GL Set Code', NULL, 'PerSavless100k', '52080', '20110', NULL, NULL, '28024', '28026');


--
-- Data for Name: tranStatsGroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."trnStatsGroup" ("accumCr", "accumDr", "dateTypes", "desc", "precision", "statGroup") VALUES 
(true, true, NULL, 'ACH Limits', 4, 'ACH Limits'),
(true, true, NULL, 'RDC Limits', 4, 'RDC Limits'),
(true, true, NULL, 'Reg D Counter', 4, 'Reg D Counter');

--
-- Data for Name: txLimits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."trnLimits" ("_Id", "increCrAmt", "increDrAmt", "maxCrAmt", "maxDrAmt", "minCrAmt", "minDrAmt", "name", "violationAct") VALUES 
('1', NULL, NULL, NULL, NULL, NULL, NULL, 'ACH Limit', NULL);

--
-- Data for Name: accumTxLimits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."accumTrnLimits" ("_Id", "crAmt", "crCnt", "drAmt", "drCnt", "name", "period", "startDtm", "statGroup", "totAmt", "totCnt", "violationAct") VALUES 
('1', NULL, 6, NULL, 6, 'Reg D Limits', 'P30D', NULL, 'Reg D Counter', NULL, NULL, '[1, 6, 7]'),
('2', 10000.00, NULL, NULL, NULL, 'RDC Limits Personal', 'P1M', NULL, 'RDC Limits', NULL, NULL, '[1, 6, 7]'),
('3', 10000.00, NULL, NULL, NULL, 'RDC Limits Business', 'P1M', NULL, 'RDC Limits', NULL, NULL, '[1, 6, 7]'),
('DELETE ACH Limits', NULL, NULL, NULL, NULL, 'ACH Limits', 'P30M', NULL, 'ACH Limits', 10000.00, NULL, '[5]');

--
-- Data for Name: componentTd; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."componentTd" ("componentName", "crTermExt", "earlyDrPen", "intMatrix", "intRate", "maturityOpt", "notice", "penMatrix", "rateSchedMatrix", "rollCrGrace", "rollDrGraceAdj", "rollGracePd", "rollGraceRate", "rollProd", "term", "version") VALUES 
('12M CD Business', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'B3012', '12M', 1),
('12M CD Personal', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'P3012', '12M', 1),
('18M CD Business', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'B3018', '18M', 1),
('18M CD Personal', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'P3018', '18M', 1),
('24M CD Business', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'B3024', '24M', 1),
('24M CD Personal', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'P3024', '24M', 1),
('36M CD Business', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'B3036', '36M', 1),
('36M CD Personal', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'P3036', '36M', 1),
('48M CD Business', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'B3048', '48M', 1),
('48M CD Personal', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'P3048', '48M', 1),
('6M CD Business', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'B3006', '6M', 1),
('6M CD Personal', NULL, 1, NULL, NULL, 1, '30D', 'LOB CD PenMat', NULL, '10D', 2, '10D', NULL, 'P3006', '6M', 1);

--
-- Data for Name: componentInt; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."componentInt" ("accrMinBal", "adjTerm", "balOpt", "calcMthd", "componentName", "disbmtOpt", "index", "isCompoundDly", "nomRate", "postFreq", "promoDtl", "version") VALUES 
(NULL, NULL, 1, 1, 'CD Interest', 1, '{"round": null, "offSet": null, "maxRate": null, "minRate": null, "indexName": "Term_prodSubType", "isBlended": null, "maxChngPer": null, "reviewFreq": null, "isReviewDly": null, "maxChngLife": null, "nextReviewDtm": null}', true, NULL, '0MAE', NULL, 1),
(NULL, NULL, 1, 1, 'Savings Interest', 1, '{"round": null, "offSet": null, "maxRate": null, "minRate": null, "indexName": "Bank Savings Rate", "isBlended": null, "maxChngPer": null, "reviewFreq": null, "isReviewDly": null, "maxChngLife": null, "nextReviewDtm": null}', true, NULL, '0MAE', NULL, 1);

--
-- Data for Name: componentLimits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."componentLimits" ("accumTrnLimits", "componentName", "deminimisAmt", "maxPosnBal", "minPosnBal", "minToOpen", "perTrnLimits", "restrictCr", "restrictCrFundExp", "restrictDr", "version") VALUES 
('[{"_Id": "RDC Limits Bus", "name": "RDC Limits Bus", "period": "1M", "startDtm": null, "drAmt": null, "drCnt": null, "totAmt": 20000, "totCnt": null, "crAmt": null, "crCnt": null, "statGroup": "RDC Limit", "violationAct": [1, 6, 7]}]', 'CD Limits Business', NULL, NULL, NULL, 2500.00, '[{"_Id": "ACH Limit", "name": "ACH Limit", "maxAmt": 250000, "minAmt": null, "incrementAmt": 0, "violationAct": [5, 7]}]', false, true, false, 1),
('[{"_Id": "RDC Limits  Personal", "name": "RDC Limits", "period": "1M", "startDtm": null, "drAmt": null, "drCnt": null, "totAmt": 10000, "totCnt": null, "crAmt": null, "crCnt": null, "statGroup": "RDC Limit", "violationAct": [1, 6, 7]}]', 'CD Limits Personal', NULL, NULL, NULL, 2500.00, '[{"_Id": "ACH Limit", "name": "ACH Limit", "maxAmt": 250000, "minAmt": null, "incrementAmt": 0, "violationAct": [5, 7]}]', false, true, false, 1),
('[{"_Id": "RDC Limits Business", "name": "RDC Limits", "period": "1M", "startDtm": null, "drAmt": null, "drCnt": null, "totAmt": 10000, "totCnt": null, "crAmt": null, "crCnt": null, "statGroup": "RDC Limit Business", "violationAct": [1, 6, 7]}, {"_Id": "RegD Limits", "name": "RegD Limits", "period": "1M", "startDtm": null, "drAmt": null, "drCnt": 6, "totAmt": null, "totCnt": null, "crAmt": null, "crCnt": null, "statGroup": "RegD Counter", "violationAct": [1, 6, 7]}]', 'Savings Limits Business', NULL, NULL, NULL, NULL, '[{"_Id": "ACH Limit", "name": "ACH Limit", "maxAmt": 250000, "minAmt": null, "incrementAmt": 0, "violationAct": [5, 7]}]', false, false, false, 1),
('[{"_Id": "RDC Limits Personal", "name": "RDC Limits", "period": "1M", "startDtm": null, "drAmt": null, "drCnt": null, "totAmt": 10000, "totCnt": null, "crAmt": null, "crCnt": null, "statGroup": "RDC Limit", "violationAct": [1, 6, 7]}, {"_Id": "RegD Limits", "name": "RegD Limits", "period": "1M", "startDtm": null, "drAmt": null, "drCnt": 6, "totAmt": null, "totCnt": null, "crAmt": null, "crCnt": null, "statGroup": "RegD Counter", "violationAct": [1, 6, 7]}]', 'Savings Limits Personal', NULL, NULL, NULL, NULL, '[{"_Id": "ACH Limit", "name": "ACH Limit", "maxAmt": 250000, "minAmt": null, "incrementAmt": 0, "violationAct": [5, 7]}]', false, false, false, 1);

--
-- Data for Name: tranCd; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Savings Miscellaneous Debit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '137', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Savings Deposit Correction Debit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '140', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('CD Miscellaneous Credit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '215', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('CD Miscellaneous Debit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '237', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Interest Accrual System', NULL, NULL, NULL, '["CORE"]', NULL, NULL, NULL, '451', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Interest Posting System', NULL, NULL, NULL, '["CORE"]', NULL, NULL, NULL, '450', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Interest Accrual Increase', NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Incoming ACH Payment', NULL, NULL, NULL, '["ACH"]', NULL, NULL, NULL, '180', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Incoming ACH Collection', NULL, NULL, NULL, '["ACH"]', NULL, NULL, '["Reg D Limits"]', '185', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('ACH Collection Return', NULL, NULL, NULL, '["ACH"]', NULL, NULL, NULL, '175', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Savings Withdrawal', NULL, NULL, NULL, NULL, NULL, NULL, '["Reg D Limits"]', '145', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Savings Deposit Cash', NULL, NULL, 'null', 'null', 'null', 'null', 'null', '146', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('ACH Payment Order Return', NULL, NULL, 'null', '["ACH"]', 'null', 'null', 'null', '170', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Return Item Fee', NULL, NULL, 'null', 'null', 'null', 'null', 'null', '020', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('NSF Fee', NULL, NULL, 'null', 'null', 'null', 'null', 'null', '025', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Reg D Violation Fee', NULL, NULL, 'null', 'null', 'null', 'null', 'null', '030', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Transfer Out', NULL, NULL, 'null', '["ACH"]', 'null', 'null', '["ACH Limits", "Reg D Limits"]', '150', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Transfer In', NULL, NULL, 'null', '["ACH"]', 'null', 'null', '["ACH Limits"]', '105', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Funds Transfer', NULL, NULL, 'null', 'null', 'null', 'null', '["Reg D Limits"]', '015', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('ACH Debit InProcess-Clearing', NULL, NULL, 'null', '["ACH"]', 'null', 'null', 'null', '151', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('ACH Credit InProcess-Clearing', NULL, NULL, 'null', '["ACH"]', 'null', 'null', 'null', '1051', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Interest Accrual Decrease', NULL, NULL, 'null', 'null', 'null', 'null', 'null', '124', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Savings Miscellaneous Credit', NULL, NULL, 'null', 'null', 'null', 'null', 'null', '138', NULL);

--
-- Data for Name: tranCdEntries; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'CSR Withdrawal', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '137', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, '', NULL, NULL, 350, NULL, 'Cash Offset', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '137', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Deposit Corr Debit', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '140', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, '', NULL, NULL, 350, NULL, 'Cash Offset', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '140', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'CSR CD Credit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '215', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, '', NULL, NULL, 350, NULL, 'Cash Offset', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '215', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'CD CSR Withdrawal', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '237', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, '', NULL, NULL, 350, NULL, 'Cash Offset', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '237', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Interest Accrual', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '451', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Int Accrual Offset', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '451', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Interest Posting', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '450', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Int Post Offset', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '450', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Int Accr Adj', NULL, NULL, 'false', 'false', NULL, NULL, NULL, NULL, '123', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '=glset.intExpAcct', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'Accrual Adj', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '123', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'ACH Deposit', NULL, NULL, 'false', 'false', NULL, NULL, NULL, NULL, '180', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '20137', NULL, NULL, NULL, NULL, 'trnEntries[0].acctNbr', NULL, NULL, 350, NULL, 'ACH Deposit', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '180', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'ACH Debit', NULL, NULL, 'false', 'true', NULL, NULL, NULL, NULL, '185', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '20137', NULL, NULL, NULL, NULL, 'trnEntries[0].acctNbr', NULL, NULL, 350, NULL, 'ACH Debit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '185', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, NULL, 'ACH Collect Return', NULL, NULL, 'false', 'true', NULL, NULL, NULL, NULL, '175', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '20137', NULL, NULL, NULL, NULL, 'trnEntries[0].acctNbr', NULL, NULL, 350, NULL, 'ACH Collect Return', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '175', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Withdrawal', NULL, NULL, 350, NULL, NULL, NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '145', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, 'trnEntries[0].acctNbr', NULL, NULL, 350, NULL, 'Cash Offset', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '145', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Savings Deposit Cash', NULL, NULL, 350, 'null', 'Sav Deposit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '146', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, 'Savings Deposit Cash', NULL, NULL, 350, 'null', 'Cash Offset', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '146', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 350, 'null', 'ACH Payment Return', NULL, NULL, 'false', 'false', NULL, NULL, NULL, NULL, '170', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '14020', NULL, NULL, NULL, NULL, 'ACH Payment Return', NULL, NULL, 350, 'null', 'ACH Payment Return', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '170', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Return Item Fee', NULL, NULL, 350, 'null', 'Return Item Fee', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '020', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '46110', NULL, NULL, NULL, NULL, 'Return Item Fee', NULL, NULL, 350, 'null', 'Return Item Fee', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '020', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'NSF Fee Account', NULL, NULL, 350, 'null', 'NSF Fee', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '025', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '46110', NULL, NULL, NULL, NULL, 'NSF Fee Account', NULL, NULL, 350, 'null', 'NSF Fee Account', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '025', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Reg D Fee', NULL, NULL, 350, 'null', 'Reg D Fee', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '030', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '46110', NULL, NULL, NULL, NULL, 'Reg D Fee', NULL, NULL, 350, 'null', 'Reg D Fee', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '030', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'ACH Transfer Out', NULL, NULL, 350, 'null', 'ACH Transfer OUt', NULL, NULL, 'true', 'true', NULL, NULL, NULL, NULL, '150', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '20137', NULL, NULL, NULL, NULL, 'ACH Transfer Out', NULL, NULL, 350, 'null', 'Cred-ACH-InProc', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '150', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, '{"dur": "4B", "posnId": "=trn.entries[0].posnId", "reason": "funds ver", "acctNbr": "=trn.entries[0].acctNbr", "holdAmt": "=trn.entries[0].amount", "holdType": 1, "acctGroup": "=trn.entries[0].acctGroup"}', NULL, NULL, NULL, 'ACH Transfer In', NULL, NULL, 350, 'null', 'ACH Transfer In', NULL, NULL, 'true', 'false', NULL, NULL, NULL, NULL, '105', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '20137', NULL, NULL, NULL, NULL, 'ACH Transfer In', NULL, NULL, 350, 'null', 'Debit-ACH-InProc', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '105', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Internal Transfer Out', NULL, NULL, 350, 'null', 'Outgoing Transfer', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '015', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 1, NULL, NULL, NULL, NULL, NULL, 'Internal Transfer In', NULL, NULL, 350, 'null', 'Incoming Transfer', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '015', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 2, '20137', NULL, NULL, NULL, NULL, 'ACH Clearing', NULL, NULL, 350, 'null', 'Debit-ACH-InProc', NULL, NULL, 'false', 'true', NULL, NULL, NULL, NULL, '151', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '14020', NULL, NULL, NULL, NULL, 'ACH Clearing', NULL, NULL, 350, 'null', 'Cred-ACH-Clear', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '151', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 2, '20137', NULL, NULL, NULL, NULL, 'ACH Clearing', NULL, NULL, 350, 'null', 'Cred-ACH-InProc', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '1051', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '14020', NULL, NULL, NULL, NULL, 'ACH Clearing', NULL, NULL, 350, 'null', 'Debit-SAV-Clear', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '1051', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Interest Accr Dec Manual', NULL, NULL, 350, 'null', 'Int Accr Adj', NULL, NULL, 'false', 'true', NULL, NULL, NULL, NULL, '124', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '=glset.intExpAcct', NULL, NULL, NULL, NULL, 'Interest Accr Dec Manual', NULL, NULL, 350, 'null', 'Accrual Adj', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '124', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, 'Sav Misc Credit', NULL, NULL, 350, 'null', 'CSR Misc Credit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, '138', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '57670', NULL, NULL, NULL, NULL, 'Sav Misc Credit', NULL, NULL, 350, 'null', 'Cash Offset', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, '138', 1);


--
-- Data for Name: party; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."party" ("_Class", "_Id", "contactPref", "cntry", "folderId", "name", "preferAddrId", "preferEmailId", "preferPhoneId", "taxid") VALUES 
('party_organization', '1805051238591493910005', NULL, NULL, NULL, 'Live Oak Bank', NULL, NULL, NULL, '800182298'),
('party_organization', '1805081213039283840005', NULL, NULL, NULL, 'FRB Richmond', NULL, NULL, NULL, NULL);

--
-- Data for Name: party_organization; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."party_organization" ("_Id", "dba", "dbaName", "desc", "dunsNbr", "emailDomain", "estDate", "isGovtOwn", "isIntrntl", "isPubliclyHeld", "isSmallBusiness", "isTaxExempt", "legalForm", "moFiscalYrEnd", "nbrEmployed", "primaryBankId", "region", "taxExemptType", "tradeName", "webSiteURL") VALUES 
('1805051238591493910005', '053112916', 'Live Oak Bank', NULL, 829635999, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'https://www.liveoakbank.com/'),
('1805081213039283840005', '051000033', 'FRB Richmond', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

--
-- Data for Name: party_organization_fininst; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."party_organization_fininst" ("_Id", "finInstAba", "finInstBic") VALUES 
('1805081213039283840005', 51000033, NULL),
('1805051238591493910005', 53112916, NULL);
--
-- Data for Name: bankparam; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."bankparam" ("_Id", "calendar", "pageTrnCnt") VALUES 
('1805051238591493910005', 'Standard', 50);

--
-- Data for Name: network; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."network" ("calendar", "contacts", "desc", "destination", "extCrAccts", "extDrAccts", "inputPath", "isAmlChk", "isAutoReturn", "isChkNbr", "isChkValid", "isDrBalGrace", "isFraudChk", "isInteractive", "isNegPay", "isNsfOptIn", "isOrderVerifyReqd", "isPosPay", "isReturnFundsAvl", "isStoreForward", "maxRetry", "network", "nsfPost", "odSweep", "outputPath", "pageTrnCnt", "paging", "partyId", "postOrder", "returnDecideTm", "retryFreq", "submitTm", "trnCode", "userRole") VALUES 
(NULL, NULL, 'Internal System Processing', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'CORE', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, '[{"trnCode": "450", "procName": "intPost", "procType": 0}, {"trnCode": "451", "procName": "glAccrual", "procType": 3}, {"trnCode": "015", "procName": "bookXfr", "procType": 0}]', NULL),
(NULL, NULL, 'Automated Clearing House', '1805081213039283840005', 2, 2, '/ach/', true, true, false, false, false, false, false, false, false, false, false, NULL, NULL, 3, 'ACH', 1, NULL, '/ach/', 10, 3, NULL, 7, '00-04:00', NULL, '00-04:00', '[{"trnCode": "150", "procName": "achOut", "procType": 1}, {"trnCode": "105", "procName": "achOut", "procType": 2}, {"trnCode": "151", "procName": "achOut", "procType": 3}, {"trnCode": "180", "procName": "achIn", "procType": 1}, {"trnCode": "185", "procName": "achIn", "procType": 2}]', NULL);

--
-- Data for Name: prodType; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."prodType" ("desc", "prodType") VALUES 
('Deposit Products', 'Deposit'),
('Loan products', 'Loan');

--
-- Data for Name: prodSubType; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."prodSubType" ("accrCalcTm", "desc", "drBalGrace", "glSetCode", "isRegD", "prodSubType", "prodType", "stmtFreq") VALUES 
(NULL, 'Business Deposit Product', NULL, NULL, NULL, 'Business', 'Deposit', NULL),
(NULL, 'Personal Deposit Products', NULL, NULL, NULL, 'Personal', 'Deposit', NULL);

--
-- Data for Name: prodGroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."prodGroup" ("accrCalcTm", "desc", "drBalGrace", "glCat", "glSetCode", "isRegD", "prodGroup", "prodSubType", "prodType", "rollGraceRate") VALUES 
(NULL, 'CD Business Products', NULL, 2, NULL, true, 'CD', 'Business', 'Deposit', NULL),
(NULL, 'Savings Business Products', NULL, 2, NULL, true, 'SAV', 'Business', 'Deposit', NULL),
(NULL, 'CD Personal Products', NULL, 2, NULL, true, 'CD', 'Personal', 'Deposit', NULL),
(NULL, 'Savings Personal Products', NULL, 2, NULL, true, 'SAV', 'Personal', 'Deposit', NULL);

--
-- Data for Name: prod_bk; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."prod_bk" ("avlEndDtm", "avlStartDtm", "components", "ccyCode", "desc", "fundTerm", "glCat", "glSetCode", "ifxAcctType", "isFedExempt", "isRegD", "isStateExempt", "logRef", "name", "prodGroup", "prodSubType", "prodType", "stmtFreq", "version") VALUES 
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "Savings Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "Savings Limits Business", "componentClass": "componentLimits"}]', 'USD', 'Business Savings', '30D', 2, 'BusSavless100k', 'SDA', NULL, true, NULL, NULL, 'B2001', 'SAV', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Business", "componentClass": "componentLimits"}, {"version": 1, "componentName": "6M CD Business", "componentClass": "componentTd"}]', 'USD', '6 Month Compounding-Business', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'B3006', 'CD', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Business", "componentClass": "componentLimits"}, {"version": 1, "componentName": "12M CD Business", "componentClass": "componentTd"}]', 'USD', '12 Month Compounding-Business', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'B3012', 'CD', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Business", "componentClass": "componentLimits"}, {"version": 1, "componentName": "18M CD Business", "componentClass": "componentTd"}]', 'USD', '18 Month Compounding-Business', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'B3018', 'CD', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Business", "componentClass": "componentLimits"}, {"version": 1, "componentName": "24M CD Business", "componentClass": "componentTd"}]', 'USD', '24 Month Compounding-Business', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'B3024', 'CD', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Business", "componentClass": "componentLimits"}, {"version": 1, "componentName": "36M CD Business", "componentClass": "componentTd"}]', 'USD', '36 Month Compounding-Business', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'B3036', 'CD', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Business", "componentClass": "componentLimits"}, {"version": 1, "componentName": "48M CD Business", "componentClass": "componentTd"}]', 'USD', '48 Month Compounding-Business', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'B3048', 'CD', 'Business', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "Savings Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "Savings Limits Personal", "componentClass": "componentLimits"}]', 'USD', 'Personal Savings', '30D', 2, 'PerSavless100k', 'SDA', NULL, true, NULL, NULL, 'P2001', 'SAV', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Personal", "componentClass": "componentLimits"}, {"version": 1, "componentName": "6M CD Personal", "componentClass": "componentTd"}]', 'USD', '6 Month Compounding-Personal', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'P3006', 'CD', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Personal", "componentClass": "componentLimits"}, {"version": 1, "componentName": "12M CD Personal", "componentClass": "componentTd"}]', 'USD', '12 Month Compounding-Personal', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'P3012', 'CD', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Personal", "componentClass": "componentLimits"}, {"version": 1, "componentName": "18M CD Personal", "componentClass": "componentTd"}]', 'USD', '18 Month Compounding-Personal', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'P3018', 'CD', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Personal", "componentClass": "componentLimits"}, {"version": 1, "componentName": "24M CD Personal", "componentClass": "componentTd"}]', 'USD', '24 Month Compounding-Personal', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'P3024', 'CD', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Personal", "componentClass": "componentLimits"}, {"version": 1, "componentName": "36M CD Personal", "componentClass": "componentTd"}]', 'USD', '36 Month Compounding-Personal', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'P3036', 'CD', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, '2017-10-20 23:00:00', '[{"version": 1, "componentName": "CD Interest", "componentClass": "componentInt"}, {"version": 1, "componentName": "CD Limits Personal", "componentClass": "componentLimits"}, {"version": 1, "componentName": "48M CD Personal", "componentClass": "componentTd"}]', 'USD', '48 Month Compounding-Personal', '10D', 2, 'CDless100k', 'CDA', NULL, true, NULL, NULL, 'P3048', 'CD', 'Personal', 'Deposit', '0MAE', NULL),
(NULL, NULL, '[{"version": 3, "componentName": "Personal Savings", "componentClass": null}]', 'USD', 'TEST Savings', '30D', NULL, 'PerSavless100k', 'SDA', NULL, true, NULL, NULL, 'PerSAVDELETE', 'SAV', 'Personal', 'Deposit', '30D', 1);

--
-- Data for Name: matrixType; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."matrixType" ("desc", "dimensions", "isBlended", "name", "valFmt", "valType") VALUES 
('Flat Rate Schedule', '[{"propFmt": "string", "dimLable": null, "propName": "prod_bk.prodSubType", "propType": "string", "whenBtwn": 3}]', false, 'Bank Savings Rate', 'rate', 'number'),
('Penalty Matrix', '[{"propFmt": "freq", "dimLable": null, "propName": "posn_bkTd.Term", "propType": "string", "whenBtwn": 2}]', false, 'LOB CD PenMat', 'frequency', 'string'),
('Tiered by Term and prodSubType', '[{"propFmt": "text", "dimLable": null, "propName": "prod_bk.prodSubType", "propType": "string", "whenBtwn": 3}, {"propFmt": "freq", "dimLable": null, "propName": "posn_bkTd.term", "propType": "string", "whenBtwn": 3}]', true, 'Term_prodSubType', 'rate', 'number');

--
-- Data for Name: matrix; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."matrix" ("dimKey", "name", "validFromDtm", "validToDtm", "val") VALUES 
('Business', 'Bank Savings Rate', '2018-03-13 00:00:00', NULL, '1.6'),
('Personal', 'Bank Savings Rate', '2018-03-13 00:00:00', NULL, '1.6'),
('Business,12M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.0783'),
('Business,18M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.274'),
('Business,24M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.3228'),
('Business,36M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.3717'),
('Business,48M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.4205'),
('Business,60M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.518'),
('Business,6M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '1.6366'),
('Personal,12M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.0783'),
('Personal,18M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.274'),
('Personal,24M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.3228'),
('Personal,36M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.3717'),
('Personal,48M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.4205'),
('Personal,60M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '2.518'),
('Personal,6M', 'Term_prodSubType', '2018-03-13 00:00:00', NULL, '1.6366');

--
-- Data for Name: systemCalendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1804271520128657215575', 'T1M', false, 'glAccum','glAccum', '2018-04-27 00:00:00', '2018-04-27 00:00:00');
-- ('1804271520128657215576', '1DAT4:00AM', false, 'glAccrual','glAccrual', '2018-04-27 00:00:00', '2018-04-27 00:00:00'),
-- ('1805141743440859786765','1DT4:05AM', false, 'glExtract','glExtract', '2018-04-27 00:00:00', '2018-04-27 00:00:00');
 
--INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
--('1805141743440859786765', '0', 'extractName', 'glExtract_'),
--('1805141743440859786765', '1', 'suppressZero', 'true');


--
-- Data for Name: configSystemAccount; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."configSystemAcct" ("acctGroup", "acctName", "acctNbr", "desc", "posnRef") VALUES 
(2, 'SETTLEMENT', '20130', 'System Settlement Account', '2013035001'),
(2, 'SUSPENSE', '20130', 'System Suspense Account', '2013035001');

--
-- Data for Name: exceptRules; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "exceptRules" ("code", "trnRoleIncl","trnRoleExcl") VALUES
('posn.balance','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn.openDt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn.closeDt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bk.availBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bk.authAvailBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bk.collectedBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bk.pledgedBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bk.fundingExpDt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkTd.expDrGraceDt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkTd.expCrGraceDt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkInt.acrMinBal.balance','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkInt.acrMinBal.availBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkInt.acrMinBal.authAvailBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.minToOpen','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.minPosnBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.maxPosnBal','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.restrictDr','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.restrictCrFundExp','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.restrictCr','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.txLimits.minCrAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.txLimits.maxCrAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.txLimits.incrementCrAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.txLimits.minDrAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.txLimits.maxDrAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.txLimits.incrementDrAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.accumTxLimits.debitAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.accumTxLimits.debitCnt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.accumTxLimits.creditAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.accumTxLimits.creditCnt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.accumTxLimits.totalAmt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]'),
('posn_bkLimits.accumTxLimits.totalCnt','["MANAGER"]','["DEP_REP","DEP_REP_POST"]');

-- system events for reports
-- bal 2 scheduled report
-- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301948199077808394','1DT07:30AM', false, 'scheduledReport','bal_2', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301948199077808394', '0', 'format', 'pdf'),
-- ('1805301948199077808394', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- 10 am 1DT02:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301948550911008406','1DT02:00PM', false, 'scheduledReport','bal_2', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301948550911008406', '0', 'format', 'pdf'),
-- ('1805301948550911008406', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- 12 pm 1DT04:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301949049448838416','1DT04:00PM', false, 'scheduledReport','bal_2', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301949049448838416', '0', 'format', 'pdf'),
-- ('1805301949049448838416', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- 2 pm 1DT06:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301949145511588425','1DT06:00PM', false, 'scheduledReport','bal_2', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301949145511588425', '0', 'format', 'pdf'),
-- ('1805301949145511588425', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- 4 pm 1DT10:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301949243669578435','1DT10:00PM', false, 'scheduledReport','bal_2', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301949243669578435', '0', 'format', 'pdf'),
-- ('1805301949243669578435', '1', 'procdate::fxtime', 'T10:00PM');
--
-- -- bal 2a scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301950464549698475','1DT07:30AM', false, 'scheduledReport','bal_2a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301950464549698475', '0', 'format', 'pdf'),
-- ('1805301950464549698475', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- 10 am 1DT02:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301950577574368491','1DT02:00PM', false, 'scheduledReport','bal_2a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301950577574368491', '0', 'format', 'pdf'),
-- ('1805301950577574368491', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- 12 pm 1DT04:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301951106095378508','1DT04:00PM', false, 'scheduledReport','bal_2a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301951106095378508', '0', 'format', 'pdf'),
-- ('1805301951106095378508', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- 2 pm 1DT06:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301958430973298583','1DT06:00PM', false, 'scheduledReport','bal_2a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301958430973298583', '0', 'format', 'pdf'),
-- ('1805301958430973298583', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- 4 pm 1DT10:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805301958525179278599','1DT10:00PM', false, 'scheduledReport','bal_2a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805301958525179278599', '0', 'format', 'pdf'),
-- ('1805301958525179278599', '1', 'procdate::fxtime', 'T10:00PM');
--
-- -- bal 5 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302000067658978624','1DT07:30AM', false, 'scheduledReport','bal_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302000067658978624', '0', 'format', 'pdf'),
-- ('1805302000067658978624', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- 10 am 1DT02:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302000152393968632','1DT02:00PM', false, 'scheduledReport','bal_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302000152393968632', '0', 'format', 'pdf'),
-- ('1805302000152393968632', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- 12 pm 1DT04:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302000257689518650','1DT04:00PM', false, 'scheduledReport','bal_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302000257689518650', '0', 'format', 'pdf'),
-- ('1805302000257689518650', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- 2 pm 1DT06:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302000360640428660','1DT06:00PM', false, 'scheduledReport','bal_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302000360640428660', '0', 'format', 'pdf'),
-- ('1805302000360640428660', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- 4 pm 1DT10:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302000450061798671','1DT10:00PM', false, 'scheduledReport','bal_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302000450061798671', '0', 'format', 'pdf'),
-- ('1805302000450061798671', '1', 'procdate::fxtime', 'T10:00PM');
--
-- -- bal 6 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302002221094478699','1DT07:30AM', false, 'scheduledReport','bal_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302002221094478699', '0', 'format', 'pdf'),
-- ('1805302002221094478699', '1', 'procdate::fxtime', 'T11:59PM');
--
-- -- 10 am 1DT02:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302002336882138707','1DT02:00PM', false, 'scheduledReport','bal_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302002336882138707', '0', 'format', 'pdf'),
-- ('1805302002336882138707', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- 12 pm 1DT04:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302002458020388726','1DT04:00PM', false, 'scheduledReport','bal_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302002458020388726', '0', 'format', 'pdf'),
-- ('1805302002458020388726', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- 2 pm 1DT06:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302002545051778734','1DT06:00PM', false, 'scheduledReport','bal_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302002545051778734', '0', 'format', 'pdf'),
-- ('1805302002545051778734', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- 4 pm 1DT10:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302003051526298752','1DT10:00PM', false, 'scheduledReport','bal_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302003051526298752', '0', 'format', 'pdf'),
-- ('1805302003051526298752', '1', 'procdate::fxtime', 'T10:00PM');
--
-- -- dep 4 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302007327735778804','1DT07:30AM', false, 'scheduledReport','dep_4', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302007327735778804', '0', 'format', 'pdf'),
-- ('1805302007327735778804', '1', 'frprocdate::fxtime', '-1DT11:59PM'),
-- ('1805302007327735778804', '2', 'toprocdate::fxtime', '-1DT11:59PM');
--
-- -- dep 5 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302032232850339347','1DT07:30AM', false, 'scheduledReport','dep_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302032232850339347', '0', 'format', 'pdf'),
-- ('1805302032232850339347', '1', 'frprocdate::fxtime', '-1DT11:59PM'),
-- ('1805302032232850339347', '2', 'toprocdate::fxtime', '-1DT11:59PM');
--
-- -- 10 am
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302032321658729355','1DT02:00PM', false, 'scheduledReport','dep_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302032321658729355', '0', 'format', 'pdf'),
-- ('1805302032321658729355', '1', 'frprocdate::fxtime', 'T02:00PM'),
-- ('1805302032321658729355', '2', 'toprocdate::fxtime', 'T02:00PM');
--
-- -- 12 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302032407420189364','1DT04:00PM', false, 'scheduledReport','dep_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302032407420189364', '0', 'format', 'pdf'),
-- ('1805302032407420189364', '1', 'frprocdate::fxtime', 'T04:00PM'),
-- ('1805302032407420189364', '2', 'toprocdate::fxtime', 'T04:00PM');
--
-- -- 2pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302032531195589375','1DT06:00PM', false, 'scheduledReport','dep_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302032531195589375', '0', 'format', 'pdf'),
-- ('1805302032531195589375', '1', 'frprocdate::fxtime', 'T06:00PM'),
-- ('1805302032531195589375', '2', 'toprocdate::fxtime', 'T06:00PM');
--
-- -- 4 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302033069102439385','1DT08:00PM', false, 'scheduledReport','dep_5', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302033069102439385', '0', 'format', 'pdf'),
-- ('1805302033069102439385', '1', 'frprocdate::fxtime', 'T09:15PM'),
-- ('1805302033069102439385', '2', 'toprocdate::fxtime', 'T09:15PM');
--
-- -- sav 2 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805141743440859786782','1DT07:30AM', false, 'scheduledReport','sav_2', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805141743440859786782', '0', 'format', 'pdf'),
-- ('1805141743440859786782', '1', 'frprocdate::fxtime', '-1MA1'),
-- ('1805141743440859786782', '2', 'toprocdate::fxtime', '-1DT11:59PM');
--
-- -- sav 6 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310039061153910724','1DT07:30AM', false, 'scheduledReport','sav_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310039061153910724', '0', 'format', 'pdf'),
-- ('1805310039061153910724', '1', 'fropendate::fxtime', '-1DT11:59PM'),
-- ('1805310039061153910724', '2', 'toopendate::fxtime', '-1DT11:59PM'),
-- ('1805310039061153910724', '3', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- sav 6 scheduled report
-- -- 10 am
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310039145314680733','1DT02:00PM', false, 'scheduledReport','sav_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310039145314680733', '0', 'format', 'pdf'),
-- ('1805310039145314680733', '1', 'fropendate::fxtime', 'T02:00PM'),
-- ('1805310039145314680733', '2', 'toopendate::fxtime', 'T02:00PM'),
-- ('1805310039145314680733', '3', 'procdate::fxtime', 'T02:00PM');
--
-- -- sav 6 scheduled report
-- -- 12 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310039255216530750','1DT04:00PM', false, 'scheduledReport','sav_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310039255216530750', '0', 'format', 'pdf'),
-- ('1805310039255216530750', '1', 'fropendate::fxtime', 'T04:00PM'),
-- ('1805310039255216530750', '2', 'toopendate::fxtime', 'T04:00PM'),
-- ('1805310039255216530750', '3', 'procdate::fxtime', 'T04:00PM');
-- -- sav 6 scheduled report
-- --2 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310039367602600760','1DT06:00PM', false, 'scheduledReport','sav_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310039367602600760', '0', 'format', 'pdf'),
-- ('1805310039367602600760', '1', 'fropendate::fxtime', 'T06:00PM'),
-- ('1805310039367602600760', '2', 'toopendate::fxtime', 'T06:00PM'),
-- ('1805310039367602600760', '3', 'procdate::fxtime', 'T06:00PM');
--
-- -- sav 6 scheduled report
-- -- 4 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310039462549350769','1DT08:00PM', false, 'scheduledReport','sav_6', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310039462549350769', '0', 'format', 'pdf'),
-- ('1805310039462549350769', '1', 'fropendate::fxtime', 'T09:15PM'),
-- ('1805310039462549350769', '2', 'toopendate::fxtime', 'T09:15PM'),
-- ('1805310039462549350769', '3', 'procdate::fxtime', 'T09:15PM');
--
-- -- sav 10 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310039553224060780','1DT07:30AM', false, 'scheduledReport','sav_10', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310039553224060780', '0', 'format', 'pdf'),
-- ('1805310039553224060780', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- 10 am
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310040164109380803','1DT02:00PM', false, 'scheduledReport','sav_10', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310040164109380803', '0', 'format', 'pdf'),
-- ('1805310040164109380803', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- 12 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310040249468870811','1DT04:00PM', false, 'scheduledReport','sav_10', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310040249468870811', '0', 'format', 'pdf'),
-- ('1805310040249468870811', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- 2 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310040353268950820','1DT06:00PM', false, 'scheduledReport','sav_10', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310040353268950820', '0', 'format', 'pdf'),
-- ('1805310040353268950820', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- 4 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310040495647280831','1DT08:00PM', false, 'scheduledReport','sav_10', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310040495647280831', '0', 'format', 'pdf'),
-- ('1805310040495647280831', '1', 'procdate::fxtime', 'T09:15PM');
--
-- -- sav 10a scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310045414319490956','1DT07:30AM', false, 'scheduledReport','sav_10a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310045414319490956', '0', 'format', 'pdf'),
-- ('1805310045414319490956', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- sav 10a scheduled report
-- -- 10 am
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310045493382780964','1DT02:00PM', false, 'scheduledReport','sav_10a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310045493382780964', '0', 'format', 'pdf'),
-- ('1805310045493382780964', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- sav 10a scheduled report
-- -- 12 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310046124875170993','1DT04:00PM', false, 'scheduledReport','sav_10a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310046124875170993', '0', 'format', 'pdf'),
-- ('1805310046124875170993', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- sav 10a scheduled report
-- -- 2 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310046216554431011','1DT06:00PM', false, 'scheduledReport','sav_10a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310046216554431011', '0', 'format', 'pdf'),
-- ('1805310046216554431011', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- sav 10a scheduled report
-- -- 4 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310046544914511029','1DT08:00PM', false, 'scheduledReport','sav_10a', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310046544914511029', '0', 'format', 'pdf'),
-- ('1805310046544914511029', '1', 'procdate::fxtime', 'T09:15PM');
--
--
-- -- sav 11 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302011401843038869','1DT07:30AM', false, 'scheduledReport','sav_11', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302011401843038869', '0', 'format', 'pdf'),
-- ('1805302011401843038869', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- 10 am 1DT02:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302011488268998878','1DT02:00PM', false, 'scheduledReport','sav_11', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302011488268998878', '0', 'format', 'pdf'),
-- ('1805302011488268998878', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- 12 pm 1DT04:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302011565519518887','1DT04:00PM', false, 'scheduledReport','sav_11', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302011565519518887', '0', 'format', 'pdf'),
-- ('1805302011565519518887', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- 2 pm 1DT06:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302012060917828897','1DT06:00PM', false, 'scheduledReport','sav_11', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302012060917828897', '0', 'format', 'pdf'),
-- ('1805302012060917828897', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- 4 pm 1DT08:00PM UTC
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805302012188821758907','1DT08:00PM', false, 'scheduledReport','sav_11', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805302012188821758907', '0', 'format', 'pdf'),
-- ('1805302012188821758907', '1', 'procdate::fxtime', 'T09:15PM');
--
-- -- trns 4 scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310051214505781135','1DT07:30AM', false, 'scheduledReport','trns_4', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310051214505781135', '0', 'format', 'pdf'),
-- ('1805310051214505781135', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- gl_bal scheduled report
-- -- END OF DAY
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310051566404441145','1DT07:30AM', false, 'scheduledReport','gl_bal', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310051566404441145', '0', 'format', 'pdf'),
-- ('1805310051566404441145', '1', 'procdate::fxtime', '-1DT11:59PM');
--
-- -- gl_bal scheduled report
-- -- 10 am
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310052077362131156','1DT02:00PM', false, 'scheduledReport','gl_bal', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310052077362131156', '0', 'format', 'pdf'),
-- ('1805310052077362131156', '1', 'procdate::fxtime', 'T02:00PM');
--
-- -- gl_bal scheduled report
-- -- 12 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310052153621221166','1DT04:00PM', false, 'scheduledReport','gl_bal', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310052153621221166', '0', 'format', 'pdf'),
-- ('1805310052153621221166', '1', 'procdate::fxtime', 'T04:00PM');
--
-- -- gl_bal scheduled report
-- -- 2 pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310052258476401175','1DT06:00PM', false, 'scheduledReport','gl_bal', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310052258476401175', '0', 'format', 'pdf'),
-- ('1805310052258476401175', '1', 'procdate::fxtime', 'T06:00PM');
--
-- -- gl_bal scheduled report
-- -- 4pm
-- INSERT INTO public."systemCalendar" ("_Id", "eventFreq", "isScheduled", "eventType", "name", "nextSchedDtm", "prevSchedDtm") VALUES
-- ('1805310052367676741184','1DT08:00PM', false, 'scheduledReport','gl_bal', '2018-05-30 00:00:00', '2018-04-27 00:00:00');
-- INSERT INTO "systemCalendarArgs" ("_Id","_Ix","key","val") VALUES
-- ('1805310052367676741184', '0', 'format', 'pdf'),
-- ('1805310052367676741184', '1', 'procdate::fxtime', 'T09:15PM');


END;
