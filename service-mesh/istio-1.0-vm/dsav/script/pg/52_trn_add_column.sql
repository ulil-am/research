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
ALTER TABLE public."acct_bk"
    ADD COLUMN account_branch INTEGER ,
    ADD COLUMN cif_customer_type VARCHAR;

COMMENT ON COLUMN public."acct_bk".account_branch
    IS 'Account Branch';

COMMENT ON COLUMN public."acct_bk".cif_customer_type
    IS 'CIF Customer Type';

-- ALTER TABLE public."trnEntries"
--     ADD COLUMN account_branch INTEGER ,
--     ADD COLUMN accounting_type VARCHAR ,
--     ADD COLUMN cif_customer_type VARCHAR ,
--     ADD COLUMN bank_code INTEGER ,
--     ADD COLUMN service_branch INTEGER ,
--     ADD COLUMN from_account_branch INTEGER ,
--     ADD COLUMN to_account_branch INTEGER ,
--     ADD COLUMN otherProperties jsonb ;
--
-- COMMENT ON COLUMN public."trnEntries".account_branch
--     IS 'Account Branch';
--
-- COMMENT ON COLUMN public."trnEntries".accounting_type
--     IS 'Accounting Type';
--
-- COMMENT ON COLUMN public."trnEntries".cif_customer_type
--     IS 'CIF Customer Type';
--
-- COMMENT ON COLUMN public."trnEntries".bank_code
--     IS 'Bank Code';
--
-- COMMENT ON COLUMN public."trnEntries".service_branch
--     IS 'Service Branch';
--
-- COMMENT ON COLUMN public."trnEntries".from_account_branch
--     IS 'From Account Branch';
--
-- COMMENT ON COLUMN public."trnEntries".to_account_branch
--     IS 'To Account Branch';
--
-- COMMENT ON COLUMN public."trnEntries".otherProperties
--     IS 'Other Properties';

END;
