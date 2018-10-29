--
-- Name: 
--    50_tn_LOB-config.sql
-- Purpose: 
--    This file stores all configuration specific to the TN core
--    implementation.
--


--
--
-- Data for Name: timeZones; Type: TABLE DATA; Schema: public; Owner: postgres
-- \c zbch_trn_db specifies to which database to use in pgsql

\c zbch_trn_db

BEGIN;

INSERT INTO public."acct" ("_Class", "acctGroup", "acctNbr", "acctTitle", "closeDtm", "desc", "openDtm") VALUES
(NULL, 2, '99999', 'Inter Clearing', NULL, NULL, NULL),
(NULL, 2, '11111', 'SA001 Ledger Balance', NULL, NULL, NULL),
(NULL, 2, '22222', 'SA002 Ledger Balance', NULL, NULL, NULL),
(NULL, 2, '10003', 'SA003 Ledger Balance', NULL, NULL, NULL),
(NULL, 2, '10004', 'DSAV1001 Ledger Balance', NULL, NULL, NULL),
(NULL, 2, '10005', 'DSAV1002 Ledger Balance', NULL, NULL, NULL),
(NULL, 2, '88888', 'Interest Posting', NULL, NULL, NULL);

--
-- Data for Name: posn; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807180732125324710208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 2, '11111', 0.00, NULL, '', NULL, 'SA001 Ledger Balance dept 1 position 1', '2017-12-20 23:00:00+00', '1111100101', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807180733247121250208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 2, '22222', 0.00, NULL, '', NULL, 'SA002 Ledger Balance dept 1 position 1', '2017-12-20 23:00:00+00', '2222200101', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807180730238730120208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 2, '10003', 0.00, NULL, '', NULL, 'SA003 Ledger Balance dept 1', '2017-12-20 23:00:00+00', '1000300101', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807181592018381040208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 2, '10004', 0.00, NULL, '', NULL, 'DSAV1001 Ledger Balance dept 1', '2017-12-20 23:00:00+00', '1000400101', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807181589127838100208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 2, '10005', 0.00, NULL, '', NULL, 'DSAV1002 Ledger Balance dept 1', '2017-12-20 23:00:00+00', '1000500101', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807180735217354960208', NULL, '"2018-07-18 07:35:21.735496+00"', NULL, NULL, 2, '99999', 0.00, NULL, '', NULL, 'Inter Clearing for dept 1 position 1', '2017-12-20 23:00:00+00', '9999900101', 1);
INSERT INTO public.posn ("_Class", "_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "acctGroup", "acctNbr", bal, "closeDtm", "createLogRef", "logRef", name, "openDtm", "posnRef", "seqNbr") VALUES ('posn_gl', '1807180735442057280208', NULL, '"2018-07-18 07:35:44.206708+00"', NULL, NULL, 2, '88888', 0.00, NULL, '', NULL, 'Interest Posting for dept 1 position 1', '2017-12-20 23:00:00+00', '8888800101', 1);

--
-- Data for Name: posn_gl; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807180732125324710208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 'IDR', NULL, 1, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807180733247121250208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 'IDR', NULL, 1, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807180730238730120208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 'THB', NULL, 1, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807181592018381040208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 'THB', NULL, 1, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807181589127838100208', NULL, '2018-07-18 07:32:12.532471+00', NULL, NULL, 'THB', NULL, 1, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807180735217354960208', NULL, '2018-07-18 07:35:21.735496+00', NULL, NULL, 'IDR', NULL, 1, 1, NULL, 1);
INSERT INTO public.posn_gl ("_Id", "_asOfDt", "_cDt", "_dDt", "_uDt", "ccyCode", company, "deptId", "glCat", "logRef", vertical) VALUES ('1807180735442057280208', NULL, '2018-07-18 07:35:44.206708+00', NULL, NULL, 'IDR', NULL, 1, 1, NULL, 1);

--
-- Data for Name: tranCd; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Incoming Transaction', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IncomingTransaction', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Interest Posting', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'InterestPosting', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Internal Transaction', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'InternalTransaction', NULL);
INSERT INTO public."trnCode" ("desc", "isAccumDtl", "maxEntry", "networkExcl", "networkIncl", "roleExcl", "roleIncl", "statGroups", "trnCode", "trnInputs") VALUES ('Outgoing Transaction', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'OutgoingTransaction', NULL);

--
-- Data for Name: tranCdEntries; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 2, '99999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'Incoming Debit', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, 'IncomingTransaction', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Incoming Credit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, 'IncomingTransaction', NULL);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 2, '88888', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'IntPost Debit', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, 'InterestPosting', 1);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'IntPost Credit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, 'InterestPosting', NULL);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Internal Debit', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, 'InternalTransaction', NULL);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Internal Credit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, 'InternalTransaction', NULL);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (0, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Outgoing Debit', NULL, NULL, NULL, 'true', NULL, NULL, NULL, NULL, 'OutgoingTransaction', NULL);
INSERT INTO public."trnCodeEntries" ("_Ix", "acctGroup", "acctNbr", "addHold", "assetClass", "assetId", "ccyCode", comment, company, "conFilter", "deptId", "entryInputs", "entryName", "glDist", "immutableDflt", "isContact", "isDr", note, "posnId", "removeHold", "trnAmt", "trnCode", vertical) VALUES (1, 2, '99999', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'Outgoing Credit', NULL, NULL, NULL, 'false', NULL, NULL, NULL, NULL, 'OutgoingTransaction', 1);

--
-- Data for Name: glSet; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES (NULL, NULL, 2, NULL, 'Personal Saving without interest', NULL, 'SA001', NULL, '11111', NULL, NULL, NULL, NULL);
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES (NULL, NULL, 2, NULL, 'Personal Saving with interest', NULL, 'SA002', NULL, '22222', NULL, NULL, NULL, NULL);
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES (NULL, NULL, 2, NULL, 'THB Personal Saving with interest', NULL, 'SA003', NULL, '10003', NULL, NULL, NULL, NULL);
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES (NULL, NULL, 2, NULL, 'Digital Saving 1001', NULL, 'DSAV1001', NULL, '10004', NULL, NULL, NULL, NULL);
INSERT INTO public."glSet" ("accrFeeAcct", "accrIntAcct", "acctGroup", "avlIntAcct", "desc", "feeIncAcct", "glSetCode", "intExpAcct", "ledgerAcct", "negIntAcct", "penIncAcct", "wthFedAcct", "wthStateAcct") VALUES (NULL, NULL, 2, NULL, 'Digital Saving 1002', NULL, 'DSAV1002', NULL, '10005', NULL, NULL, NULL, NULL);

--
-- Data for Name: prod_bk; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."prod_bk" ("avlEndDtm", "avlStartDtm", "components", "ccyCode", "desc", "fundTerm", "glCat", "glSetCode", "ifxAcctType", "isFedExempt", "isRegD", "isStateExempt", "logRef", "name", "prodGroup", "prodSubType", "prodType", "stmtFreq", "version") VALUES
(NULL, NULL, NULL, 'IDR', 'Personal Saving without interest', NULL, 2, 'SA001', NULL, NULL, false, NULL, NULL, 'SA001', 'SAV', 'Personal', 'Deposit', NULL, NULL);
INSERT INTO public."prod_bk" ("avlEndDtm", "avlStartDtm", "components", "ccyCode", "desc", "fundTerm", "glCat", "glSetCode", "ifxAcctType", "isFedExempt", "isRegD", "isStateExempt", "logRef", "name", "prodGroup", "prodSubType", "prodType", "stmtFreq", "version") VALUES
(NULL, NULL, NULL, 'IDR', 'Personal Saving with interest', NULL, 2, 'SA002', NULL, NULL, false, NULL, NULL, 'SA002', 'SAV', 'Personal', 'Deposit', NULL, NULL);
INSERT INTO public."prod_bk" ("avlEndDtm", "avlStartDtm", "components", "ccyCode", "desc", "fundTerm", "glCat", "glSetCode", "ifxAcctType", "isFedExempt", "isRegD", "isStateExempt", "logRef", "name", "prodGroup", "prodSubType", "prodType", "stmtFreq", "version") VALUES
(NULL, NULL, NULL, 'THB', 'THB Personal Saving with interest', NULL, 2, 'SA003', NULL, NULL, false, NULL, NULL, 'SA003', 'SAV', 'Personal', 'Deposit', NULL, NULL);
INSERT INTO public."prod_bk" ("avlEndDtm", "avlStartDtm", "components", "ccyCode", "desc", "fundTerm", "glCat", "glSetCode", "ifxAcctType", "isFedExempt", "isRegD", "isStateExempt", "logRef", "name", "prodGroup", "prodSubType", "prodType", "stmtFreq", "version") VALUES
(NULL, NULL, NULL, 'THB', 'DSAV1001', NULL, 2, 'DSAV1001', NULL, NULL, false, NULL, NULL, 'DSAV1001', 'SAV', 'Personal', 'Deposit', NULL, NULL);
INSERT INTO public."prod_bk" ("avlEndDtm", "avlStartDtm", "components", "ccyCode", "desc", "fundTerm", "glCat", "glSetCode", "ifxAcctType", "isFedExempt", "isRegD", "isStateExempt", "logRef", "name", "prodGroup", "prodSubType", "prodType", "stmtFreq", "version") VALUES
(NULL, NULL, NULL, 'THB', 'DSAV1002', NULL, 2, 'DSAV1002', NULL, NULL, false, NULL, NULL, 'DSAV1002', 'SAV', 'Personal', 'Deposit', NULL, NULL);

END;
